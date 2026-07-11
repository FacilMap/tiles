@motorway-color: #4B0082; /* Deep Royal Purple */
@motorroad-color: #8B008B; /* Dark Magenta */
@restricted-color: #D32F2F; /* Crimson Red */
@pedestrian-color: #00695C; /* Deep Teal */
@sidepath-color: #FF6600; /* Safety Orange */
@optional-color: #AEEA00; /* High-Vis Lime */
@allowed-color:  #00C853; /* Vivid Emerald Green */

#cycling_restrictions_lines {
	line-join: round;
	line-cap: round;
	line-width: 0; /* Default to 0 so unmapped tags remain hidden */

	[access='motorway'] { line-color: @motorway-color; }
	[access='motorroad'] { line-color: @motorroad-color; }
	[access='restricted'] { line-color: @restricted-color; }
	[access='pedestrian'] { line-color: @pedestrian-color; }
	[access='sidepath'] { line-color: @sidepath-color; }
	[access='optional'] { line-color: @optional-color; }

	/* Apply forward/backward direction markers. These are shown starting from a zoom level where the line width is at least 5,
	   and at zoom level 18 for ways that never reach this width (such as footways). */
	[highway='motorway'][zoom >= 13],
	[highway='motorway_link'][zoom >= 15],
	[highway='trunk'][zoom >= 13],
	[highway='trunk_link'][zoom >= 15],
	[highway='primary'][zoom >= 13],
	[highway='primary_link'][zoom >= 15],
	[highway='secondary'][zoom >= 13],
	[highway='secondary_link'][zoom >= 15],
	[highway='tertiary'][zoom >= 14],
	[highway='tertiary_link'][zoom >= 15],
	[highway='residential'][zoom >= 15],
	[highway='unclassified'][zoom >= 15],
	[highway='living_street'][zoom >= 15],
	[highway='pedestrian'][zoom >= 15],
	[highway='raceway'][zoom >= 15],
	[highway='platform'][zoom >= 16],
	[zoom >= 17] {
		::forward[forward != null], ::backward[backward != null] {
			marker-placement: line;
			marker-allow-overlap: true;

			marker-width: 15;
			marker-spacing: 36; /* OSM Carto has 180, so with this we align with its arrows */

			[zoom >= 16] {
				marker-width: 25;
				marker-spacing: 60;
			}

			[zoom >= 19] {
				marker-width: 35;
				marker-spacing: 100;
			}
		}

		::forward[forward != null] {
			marker-file: url('./oneway.svg');

			[forward='motorway'] { marker-fill: @motorway-color; }
			[forward='motorroad'] { marker-fill: @motorroad-color; }
			[forward='restricted'] { marker-fill: @restricted-color; }
			[forward='pedestrian'] { marker-fill: @pedestrian-color; }
			[forward='sidepath'] { marker-fill: @sidepath-color; }
			[forward='optional'] { marker-fill: @optional-color; }
			[forward='allowed'] { marker-fill: @allowed-color; }
		}

		::backward[backward != null] {
			marker-file: url('./oneway-reverse.svg');

			marker-transform: "translate(-15, 0)";
			[zoom >= 16] { marker-transform: "translate(-25, 0)"; }
			[zoom >= 19] { marker-transform: "translate(-35, 0)"; }

			[backward='motorway'] { marker-fill: @motorway-color; }
			[backward='motorroad'] { marker-fill: @motorroad-color; }
			[backward='restricted'] { marker-fill: @restricted-color; }
			[backward='pedestrian'] { marker-fill: @pedestrian-color; }
			[backward='sidepath'] { marker-fill: @sidepath-color; }
			[backward='optional'] { marker-fill: @optional-color; }
			[backward='allowed'] { marker-fill: @allowed-color; }
		}
	}


	[access != null] {
		/* Width & min zoom are designed to mirror openstreetmap-carto hierarchy */

		[highway='motorway'] {
			[zoom >= 6]  { line-width: 0.4; }
			[zoom >= 7]  { line-width: 0.8; }
			[zoom >= 8]  { line-width: 1; }
			[zoom >= 9]  { line-width: 1.4; }
			[zoom >= 10]  { line-width: 1.9; }
			[zoom >= 11]  { line-width: 2.0; }
			[zoom >= 12] { line-width: 3.5; }
			[zoom >= 13] { line-width: 6; }
			[zoom >= 15] { line-width: 10; }
			[zoom >= 17] { line-width: 18; }
			[zoom >= 18] { line-width: 21; }
			[zoom >= 19] { line-width: 27; }
			[zoom >= 20] { line-width: 33; }
		}

		[highway='motorway_link'] {
			[zoom >= 12] { line-width: 1.5; }
			[zoom >= 13] { line-width: 4; }
			[zoom >= 15] { line-width: 7.8; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 16; }
			[zoom >= 20] { line-width: 33; }
		}

		[highway='trunk'] {
			[zoom >= 6]  { line-width: 0.4; }
			[zoom >= 7]  { line-width: 0.6; }
			[zoom >= 8]  { line-width: 1; }
			[zoom >= 9]  { line-width: 1.4; }
			[zoom >= 10] { line-width: 1.9; }
			[zoom >= 11] { line-width: 1.9; }
			[zoom >= 12] { line-width: 3.5; }
			[zoom >= 13] { line-width: 6; }
			[zoom >= 15] { line-width: 10; }
			[zoom >= 17] { line-width: 18; }
			[zoom >= 18] { line-width: 21; }
			[zoom >= 19] { line-width: 27; }
		}

		[highway='trunk_link'] {
			[zoom >= 12] { line-width: 1.5; }
			[zoom >= 13] { line-width: 4; }
			[zoom >= 15] { line-width: 7.8; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 16; }
		}

		[highway='primary'] {
			[zoom >= 8]  { line-width: 1; }
			[zoom >= 9]  { line-width: 1.4; }
			[zoom >= 10] { line-width: 1.8; }
			[zoom >= 11] { line-width: 1.8; }
			[zoom >= 12] { line-width: 3.5; }
			[zoom >= 13] { line-width: 5; }
			[zoom >= 15] { line-width: 10; }
			[zoom >= 17] { line-width: 18; }
			[zoom >= 18] { line-width: 21; }
			[zoom >= 19] { line-width: 27; }
		}

		[highway='primary_link'] {
			[zoom >= 12] { line-width: 1.5; }
			[zoom >= 13] { line-width: 4; }
			[zoom >= 15] { line-width: 7.8; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 16; }
		}

		[highway='secondary'] {
			[zoom >= 9]  { line-width: 1; }
			[zoom >= 10] { line-width: 1.1; }
			[zoom >= 11] { line-width: 1.1; }
			[zoom >= 12] { line-width: 3.5; }
			[zoom >= 13] { line-width: 5; }
			[zoom >= 14] { line-width: 5; }
			[zoom >= 15] { line-width: 9; }
			[zoom >= 16] { line-width: 10; }
			[zoom >= 17] { line-width: 18; }
			[zoom >= 18] { line-width: 21; }
			[zoom >= 19] { line-width: 27; }
		}

		[highway='secondary_link'] {
			[zoom >= 12] { line-width: 1.5; }
			[zoom >= 13] { line-width: 4; }
			[zoom >= 15] { line-width: 7; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 16; }
		}

		[highway='tertiary'] {
			[zoom >= 10] { line-width: 0.7; }
			[zoom >= 11] { line-width: 0.7; }
			[zoom >= 12] { line-width: 2.5; }
			[zoom >= 13] { line-width: 4; }
			[zoom >= 14] { line-width: 5; }
			[zoom >= 15] { line-width: 9; }
			[zoom >= 16] { line-width: 10; }
			[zoom >= 17] { line-width: 18; }
			[zoom >= 18] { line-width: 21; }
			[zoom >= 19] { line-width: 27; }
		}

		[highway='tertiary_link'] {
			[zoom >= 12] { line-width: 1.5; }
			[zoom >= 13] { line-width: 3; }
			[zoom >= 15] { line-width: 7; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 16; }
		}

		[highway='residential'] {
			[zoom >= 12] { line-width: 0.5; }
		}

		[highway='unclassified'] {
			[zoom >= 12] { line-width: 0.8; }
		}

		[highway='residential'],
		[highway='unclassified'] {
			[zoom >= 13] { line-width: 2.5; }
			[zoom >= 14] { line-width: 3; }
			[zoom >= 15] { line-width: 5; }
			[zoom >= 16] { line-width: 6; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 17; }
		}

		[highway='living_street'] {
			[zoom >= 13] { line-width: 2; }
			[zoom >= 14] { line-width: 3; }
			[zoom >= 15] { line-width: 5; }
			[zoom >= 16] { line-width: 6; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 17; }
		}

		[highway='road'] {
			[zoom >= 14] { line-width: 2; }
			[zoom >= 16] { line-width: 3.5; }
			[zoom >= 17] { line-width: 7; }
			[zoom >= 18] { line-width: 8.5; }
			[zoom >= 19] { line-width: 11; }
		}

		[highway='service'] {
			[zoom >= 14] { line-width: 2; }
			[zoom >= 16] { line-width: 3.5; }
			[zoom >= 17] { line-width: 7; }
			[zoom >= 18] { line-width: 8.5; }
			[zoom >= 19] { line-width: 11; }
			[zoom >= 20] { line-width: 12; }
		}

		[highway='service-minor'] {
			[zoom >= 16] { line-width: 2; }
			[zoom >= 17] { line-width: 3.5; }
			[zoom >= 18] { line-width: 4.75; }
			[zoom >= 19] { line-width: 5.5; }
			[zoom >= 20] { line-width: 8.5; }
		}

		[highway='pedestrian'] {
			[zoom >= 14] { line-width: 3; }
			[zoom >= 15] { line-width: 5; }
			[zoom >= 16] { line-width: 6; }
			[zoom >= 17] { line-width: 12; }
			[zoom >= 18] { line-width: 13; }
			[zoom >= 19] { line-width: 17; }
		}

		[highway='raceway'] {
			[zoom >= 12] { line-width: 1.2; }
			[zoom >= 13] { line-width: 2; }
			[zoom >= 14] { line-width: 3; }
			[zoom >= 15] { line-width: 6; }
			[zoom >= 18] { line-width: 8; }
			[zoom >= 19] { line-width: 12; }
			[zoom >= 20] { line-width: 24; }
		}

		[highway='platform'] {
			[zoom >= 16] { line-width: 6; }
		}

		[highway='steps'] {
			[zoom >= 14] { line-width: 1.4; /* doubled for better visibility */ }
			[zoom >= 15] { line-width: 3; }
		}

		[highway='bridleway'] {
			[zoom >= 13] { line-width: 0.6; }
			[zoom >= 15] { line-width: 2.4; }
		}

		[highway='footway'],
		[highway='path'] {
			/* doubled for better visibility */
			[zoom >= 14] { line-width: 1.4; }
			[zoom >= 15] { line-width: 2; }
			[zoom >= 16] { line-width: 2.6; }
			[zoom >= 18] { line-width: 2.6; }
			[zoom >= 19] { line-width: 3.2; }
		}

		[highway='footway'][access='restricted'] {
			/* Since "restricted" is the default for footways, we show them only at a higher zoom level and with less width.
			If we showed them like other paths, the map would be completely cluttered with red lines along many roads
			because cycling is forbidden on their sidewalk. */

			line-width: 0;
			[zoom >= 16] { line-width: 1.3; }
			[zoom >= 18] { line-width: 1.3; }
			[zoom >= 19] { line-width: 1.6; }
		}

		[highway='cycleway'] {
			/* doubled for better visibility */
			[zoom >= 13] { line-width: 1.4; }
			[zoom >= 15] { line-width: 1.8; }
			[zoom >= 16] { line-width: 1.8; }
			[zoom >= 18] { line-width: 2; }
			[zoom >= 19] { line-width: 2.6; }
		}

		[highway='track'] {
			/* doubled for better visibility */
			[zoom >= 13] { line-width: 1; }
			[zoom >= 15] { line-width: 3; }
		}

		[highway='bus_guideway'] {
			[zoom >= 11] { line-width: 0.6; }
			[zoom >= 12] { line-width: 1; }
			[zoom >= 13] { line-width: 3; }
		}
	}
}

#cycling_restrictions_areas {
	[access='motorway'] { polygon-fill: @motorway-color; }
	[access='motorroad'] { polygon-fill: @motorroad-color; }
	[access='restricted'] { polygon-fill: @restricted-color; }
	[access='pedestrian'] { polygon-fill: @pedestrian-color; }
	[access='sidepath'] { polygon-fill: @sidepath-color; }
}