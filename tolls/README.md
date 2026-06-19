Renders an overlay that highlights any toll roads in purple (`#800080`). The tiles have a transparent background.

The tiles are created from OpenStreetMap data. Any ways with [`toll=yes`](https://wiki.openstreetmap.org/wiki/Key:toll) are highlighted. Since some ferry lines have this tag as well, any `route=ferry` ways are excluded.