# FacilMap tiles

This repository contains the configuration to render various sets of tiles offered by [FacilMap](https://facilmap.org/):
* [`cobblestone`](./cobblestone/) is an overlay that highlights roads with a cobblestone surface.
* [`cycling-restrictions`](./cycling-restrictions/) is an overlay that highlights roads where cycling is forbidden or restricted in different ways.
* [`tolls`](./tolls/) is an overlay that highlights toll roads.

## Hosted tiles

The tiles served from https://tiles.facilmap.org/, where you can also see a demo of all the tile sets. Feel free to embed those tiles in your project. For now there are no usage limitations, but feel free to [donate](https://docs.facilmap.org/users/contribute/) if you are using the tiles in a larger or commercial project.

To use the tiles on a Leaflet map, use the following code (replace `tolls` with whatever tile set you want to use):
```javascript
L.tileLayer("https://tolls.facilmap.org/tolls/{z}/{x}/{y}.png", {
	attribution: '<a href="https://facilmap.org/" target="_blank">FacilMap</a> / © <a href="https://www.openstreetmap.org/copyright" target="_blank">OSM Contributors</a>',
	zIndex: 300, // Keep above regular tile layers
	opacity: 0.7,
	className: "fm-tolls-layer" // Needed if you want to adjust styles, see below
}).addTo(map);
```

You can adjust the opacity as you wish. For those overlays that only use a single colour, you can apply a CSS `filter` to the `.fm-tolls-layer img` selector to adjust the colour. It seems like creating the right filter expression is quite complicated. It is probably easiest to ask an AI something like:

> I am embedding an image into my website that has a transparent background and contains some lines with the colour #800080. Write me a CSS `filter` that I can apply to the `img` element to show the lines in colour #xxx instead.

At the moment the FacilMap tile server is configured to apply minutely live updates of the OpenStreetMap database, so changes should be applied within a few minutes. Tiles are rendered on request, meaning that when you open a region that no one has viewed before, it can take a few seconds for the map to load (in times of high server load it is sometimes necessary to reload the map after a minute or so).

## Self-host

Using a combination of the [postgis/postgis](https://hub.docker.com/r/postgis/postgis), [iboates/osm2pgsql](https://hub.docker.com/r/iboates/osm2pgsql) and [facilmap/openstreetmap-tile-server](https://hub.docker.com/r/facilmap/openstreetmap-tile-server) docker images is a comparatively easy way to self-host a tile server. The [docker-compose.yml](./docker-compose.yml) file in this repository is configured to serve all the sets of tiles contained in this repository and can be used as a starting point for your own configuration.

Generally speaking, `postgis` is a Postgres database with support for geometric data. `osm2pgsql` is used to initially import the geometric data of the world (or a specific region) from OpenStreetMap into this database, and optionally to keep it up to date by applying deltas (“replication”). `openstreetmap-tile-server` runs a web server that generates and serves the actual tiles from the geometric data upon request.

Follow these steps to get the provided docker-compose configuration up and running:
1. Download [the whole planet](https://planet.openstreetmap.org/pbf/) or [a region](https://download.geofabrik.de/) and save it in this directory as `region.osm.pbf`.
2. Adjust `OSM2PGSQL_ARGS` in `docker-compose.yml`:
    * For importing the whole planet rather than just one region, add `--flat-nodes /data/flat_nodes.bin` to drastically speed up the import.
    * If you are _not_ planning to use replication, add `--drop`. Importing the whole planet in 2026-06 requires about 300 GiB of disk space for metadata. `--drop` will delete this metadata when the import is finished, but for applying deltas, the metadata needs to be kept.
3. Run `docker compose run --rm import` for the initial import. For the whole planet, this can take several days.
4. If you want to use replication, run `docker compose run --rm replication osm2pgsql-replication init` to initialize it, and then start the service by running `docker compose up -d replication`. Otherwise, delete the service or simply keep it stopped.
5. Run `docker compose up -d tileserver` to start the tile server.

It should be noted that each tile set keeps its own tables with its own independent copy of its relevant geometric data in the PostGIS database. Each tile set’s Lua script decides which geometric data to store in what structure during the import. On the other hand, each tile set’s style determines how to read that data again and how to display it when the tile is actually rendered. This means that when the Lua script is changed, a whole reimport of the data is needed, but if only the style changes, deleting the tile cache and restarting the tile server is enough.

Read about more details in the [openstreetmap-tile-server](https://github.com/FacilMap/openstreetmap-tile-server) docs.

### Disk space requirements

To give you a rough estimate what to expect, here are some numbers from importing the whole planet in 2026-06.

The disk usage after the import is:
* 88 GiB for the planet file (can be deleted once the import has finished)
* 104 GiB for the flat nodes file. This stores the coordinates of all nodes on the planet. Calling the import without `--flat-nodes` would store them in the Postgres database instead, which makes the import take dramatically longer and probably also uses more disk space. If you are not planning to apply updates using replication, you can delete this file after the import.
* 309 GiB for the Postgres database, most of which is metadata (all the ways and relations with their members and tags are stored so that when a single node changes in the future, the replication script can call updates on all the ways/relations that contain it). If you are not planning to use replication, you can delete the metadata after the import (using `--drop` for the import or deleting the `planet_osm_*` tables manually afterwards). Presumably, this leaves about 8 GiB of actual data.

This means that for a successful import, you need at least 500 GiB of free disk space. It is better to have a bit of buffer, as the import takes several days, and if it fails due to the disk running full, there is no resume option and you have to restart it. After the import, about 415 GiB will be permanently occupied with replication, and about 8 GiB without replication. Keep in mind that this is just for the database; after the import, no tiles are created yet. Tiles will be created on request and then cached, so keep at least a few GiB free for the tile cache.

Keep in mind that it is vital to run the import on a machine with a fast SSD. With a HDD, the import may take several weeks.

Here is an overview over the table sizes after the import:

| Table                         | Size    |
|-------------------------------|---------|
| `osm2pgsql_properties`        | 16 kB   |
| `planet_osm_rels`             | 6794 MB |
| `planet_osm_ways`             | 234 GB  |
| `spatial_ref_sys`             | 6936 kB |
| `cobblestone_areas`           | 10 MB   |
| `cobblestone_lines`           | 126 MB  |
| `cycling_restrictions_areas`  | 46 MB   |
| `cycling_restrictions_lines`  | 7041 MB |
| `toll_lines`                  | 116 MB  |

Considering how small the actual data is in relation to the metadata, you might consider running the import (and possibly also the replication) on a local machine where disk space is cheaper and upload the final data to your server after the import.

The size of the rendered tiles is suprisingly low. For example, prerendering all 3 map styles up to zoom level 8 takes less than 50 MiB of disk space. Of course, at higher zoom levels the number of tiles rises exponentially. But having 10 GiB of space available for tiles should be way enough for hosting all 3 map styles long-term.

### Memory requirements

It is advised to run the tileserver on a system with at least 32 GiB of memory and ideally another 32 GiB of swap. This is not just relevant for the import, but also for rendering the tiles. When renderd is running with 4 threads (the default for FacilMap/openstreetmap-tile-server), it frequently consumes around 16 GiB of memory while rendering tiles. Make sure to have enough memory/swap available, as otherwise renderd will crash and the container will restart and might get stuck in an infinite loop of rerendering the same tile.

### Import time

This is the output of importing the planet in 2026-06 on an AMD EPYC-Rome processor with 32 GB of RAM:

```
2026-06-20 14:03:30  osm2pgsql version 2.2.0 (2.2.0-2-g7629962d)
2026-06-20 14:03:30  Database version: 17.5 (Debian 17.5-1.pgdg110+1)
2026-06-20 14:03:30  PostGIS version: 3.5
2026-06-20 14:03:30  Initializing properties table '"public"."osm2pgsql_properties"'.
2026-06-20 14:03:30  Storing properties to table '"public"."osm2pgsql_properties"'.
Processing: Node(10691251k 17188.5k/s) Way(223064k 6.02k/s) Relation(0 0.0/s)
2026-06-22 02:03:31  Reading input files done in 129601s (36h 0m 1s).
2026-06-22 02:03:31    Processed 10691251192 nodes in 622s (10m 22s) - 17189k/s
2026-06-22 02:03:31    Processed 1197484086 ways in 127819s (35h 30m 19s) - 9k/s
2026-06-22 02:03:31    Processed 14482579 relations in 1160s (19m 20s) - 12k/s
2026-06-22 02:03:31  No marked nodes or ways (Skipping stage 2).
2026-06-22 02:03:32  Building index on middle ways table
2026-06-22 02:03:32  Clustering table 'cycling_restrictions_areas' by geometry...
2026-06-22 02:03:32  Clustering table 'cobblestone_lines' by geometry...
2026-06-22 02:03:32  Clustering table 'cobblestone_areas' by geometry...
2026-06-22 02:03:32  Clustering table 'cycling_restrictions_lines' by geometry...
2026-06-22 02:03:32  Building indexes on middle rels table
2026-06-22 02:03:32  Done postprocessing on table 'planet_osm_nodes' in 0s
2026-06-22 02:03:32  Creating index on table 'cobblestone_areas' ("geom")...
2026-06-22 02:03:32  Creating id index on table 'cobblestone_areas'...
2026-06-22 02:03:32  Analyzing table 'cobblestone_areas'...
2026-06-22 02:03:32  Clustering table 'toll_lines' by geometry...
2026-06-22 02:03:33  Creating index on table 'cycling_restrictions_areas' ("geom")...
2026-06-22 02:03:33  Creating id index on table 'cycling_restrictions_areas'...
2026-06-22 02:03:33  Analyzing table 'cycling_restrictions_areas'...
2026-06-22 02:03:37  Creating index on table 'toll_lines' ("geom")...
2026-06-22 02:03:38  Creating index on table 'cobblestone_lines' ("geom")...
2026-06-22 02:03:39  Creating id index on table 'toll_lines'...
2026-06-22 02:03:39  Analyzing table 'toll_lines'...
2026-06-22 02:03:40  Creating id index on table 'cobblestone_lines'...
2026-06-22 02:03:44  Analyzing table 'cobblestone_lines'...
2026-06-22 02:13:27  Creating index on table 'cycling_restrictions_lines' ("geom")...
2026-06-22 02:16:25  Creating id index on table 'cycling_restrictions_lines'...
2026-06-22 02:17:26  Analyzing table 'cycling_restrictions_lines'...
2026-06-24 00:57:26  Done postprocessing on table 'planet_osm_ways' in 168832s (46h 53m 52s)
2026-06-24 00:57:26  Done postprocessing on table 'planet_osm_rels' in 5793s (1h 36m 33s)
2026-06-24 00:57:26  All postprocessing on table 'cobblestone_lines' done in 13s.
2026-06-24 00:57:26  All postprocessing on table 'cobblestone_areas' done in 1s.
2026-06-24 00:57:26  All postprocessing on table 'cycling_restrictions_lines' done in 843s (14m 3s).
2026-06-24 00:57:26  All postprocessing on table 'cycling_restrictions_areas' done in 2s.
2026-06-24 00:57:26  All postprocessing on table 'toll_lines' done in 7s.
2026-06-24 00:57:26  Storing properties to table '"public"."osm2pgsql_properties"'.
2026-06-24 00:57:26  osm2pgsql took 298436s (82h 53m 56s) overall.
```

The import took 3½ days in total. Of this, importing and processing the planet itself took 1½ hours. After that, the “Analyzing table” step is run to optimize the speed of geospatial queries. This step took only a second on the `toll` tables, 10 minutes on the `cobblestone` tables but almost 2 days on the `cycling-restrictions` tables. So if you don’t need that last map style, removing it will save a lot of time.

## Create your own styles

The [overlay-template](./overlay-template/) folder contains a useful starting point for creating an overlay similar to the existing ones. The value of the `highway` tag is stored in the PostGIS database for each way, and the style is configured to mimic the minimum zoom level and width for each type of road in the [OpenStreetMap Carto](https://github.com/openstreetmap-carto/openstreetmap-carto/blob/master/style/roads.mss) style. This way the overlay for a road will always exactly cover the underlying road in the OpenStreetMap default style.