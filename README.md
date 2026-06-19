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

## Self-host

Using a combination of the [postgis/postgis](https://hub.docker.com/r/postgis/postgis), [iboates/osm2pgsql](https://hub.docker.com/r/iboates/osm2pgsql) and [facilmap/openstreetmap-tile-server](https://hub.docker.com/r/facilmap/openstreetmap-tile-server) docker images is a comparatively easy way to self-host a tile server. The [docker-compose.yml](./docker-compose.yml) file in this repository is configured to serve all the sets of tiles contained in this repository and can be used as a starting point for your own configuration.

Generally speaking, `postgis` is a Postgres database with support for geometric data. `osm2pgsql` is used to initially import the geometric data of the world (or a specific region) from OpenStreetMap into this database, and optionally to keep it up to date by applying deltas (“replication”). `openstreetmap-tile-server` runs a web server that generates and serves the actual tiles from the geometric data upon request.

Follow these steps to get the provided docker-compose configuration up and running:
1. Download [the whole planet](https://planet.openstreetmap.org/pbf/) or [a region](https://download.geofabrik.de/) and save it in this directory as `region.osm.pbf`.
2. Adjust `OSM2PGSQL_ARGS` in `docker-compose.yml`:
    * For importing the whole planet rather than just one region, add `--flat-nodes /data/flat_nodes.bin` to drastically speed up the import.
    * If you are _not_ planning to use replication, add `--drop` (and remove the `cron` service). Importing the whole planet in 2026-04 requires about 300 GiB of disk space for metadata. `--drop` will delete this metadata when the import is finished, but for applying deltas, the metadata needs to be kept.
3. Run `docker compose run --rm import` for the initial import. For the whole planet, this can take several days.
4. Run `docker compose up -d` to start the tile server.

It should be noted that each tile set keeps its own tables with its own independent copy of its relevant geometric data in the PostGIS database. Each tile set’s Lua script decides which geometric data to store in what structure during the import. On the other hand, each tile set’s style determines how to read that data again and how to display it when the tile is actually rendered. This means that an update to the configuration of a tile set might require a whole reimport of the data (if the Lua script was changed).

Read about more details in the [openstreetmap-tile-server](https://github.com/FacilMap/openstreetmap-tile-server) docs.

## Create your own styles

The [overlay-template](./overlay-template/) folder contains a useful starting point for creating an overlay similar to the existing ones. The value of the `highway` tag is stored in the PostGIS database for each way, and the style is configured to mimic the minimum zoom level and width for each type of road in the [OpenStreetMap Carto](https://github.com/openstreetmap-carto/openstreetmap-carto/blob/master/style/roads.mss) style. This way the overlay for a road will always exactly cover the underlying road in the OpenStreetMap default style.