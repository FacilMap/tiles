@cobblestone-color: #A45A52; /* Rust Red */

#cobblestone_lines {
	line-join: round;
	line-cap: round;
	line-width: 0; /* Default to 0 so unmapped tags remain hidden */
	line-color: @cobblestone-color;

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

#cobblestone_areas {
	polygon-fill: @cobblestone-color;
}