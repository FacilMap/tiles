@motorway-color: #4B0082; /* Deep Royal Purple */
@motorroad-color: #8B008B; /* Dark Magenta */
@restricted-color: #D32F2F; /* Crimson Red */
@pedestrian-color: #00695C; /* Deep Teal */
@sidepath-color: #FF6600; /* Safety Orange */

#cycling_restrictions_lines, #cycling_restrictions_lines2, #cycling_restrictions_lines::backward {
	line-join: round;
	line-width: 0; /* Default to 0 so unmapped tags remain hidden */
}

#cycling_restrictions_lines {
	line-cap: round;

	[access='motorway'] { line-color: @motorway-color; }
	[access='motorroad'] { line-color: @motorroad-color; }
	[access='restricted'] { line-color: @restricted-color; }
	[access='pedestrian'] { line-color: @pedestrian-color; }
	[access='sidepath'] { line-color: @sidepath-color; }
}

#cycling_restrictions_lines2 {
	line-dasharray: 10, 10;

	[forward='motorway'] { line-color: @motorway-color; }
	[forward='motorroad'] { line-color: @motorroad-color; }
	[forward='restricted'] { line-color: @restricted-color; }
	[forward='pedestrian'] { line-color: @pedestrian-color; }
	[forward='sidepath'] { line-color: @sidepath-color; }

	::backward {
		line-dasharray: 0, 10, 10, 0;

		[backward='motorway'] { line-color: @motorway-color; }
		[backward='motorroad'] { line-color: @motorroad-color; }
		[backward='restricted'] { line-color: @restricted-color; }
		[backward='pedestrian'] { line-color: @pedestrian-color; }
		[backward='sidepath'] { line-color: @sidepath-color; }
	}
}

#cycling_restrictions_lines, #cycling_restrictions_lines2, #cycling_restrictions_lines2::backward {
	/* Width & min zoom are designed to mirror openstreetmap-carto hierarchy */

	[highway='motorway'] {
		[zoom >= 6] {
			line-width: 0.4;
			#cycling_restrictions_lines2 { line-dasharray: 0.8, 0.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 0.8, 0.8, 0; }
		}
		[zoom >= 7] {
			line-width: 0.8;
			#cycling_restrictions_lines2 { line-dasharray: 1.6, 1.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.6, 1.6, 0; }
		}
		[zoom >= 8] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 9] {
			line-width: 1.4;
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 10] {
			line-width: 1.9;
			#cycling_restrictions_lines2 { line-dasharray: 3.8, 3.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.8, 3.8, 0; }
		}
		[zoom >= 11] {
			line-width: 2.0;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 12] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 13] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 15] {
			line-width: 10;
			#cycling_restrictions_lines2 { line-dasharray: 20, 20; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 20, 20, 0; }
		}
		[zoom >= 17] {
			line-width: 18;
			#cycling_restrictions_lines2 { line-dasharray: 36, 36; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 36, 36, 0; }
		}
		[zoom >= 18] {
			line-width: 21;
			#cycling_restrictions_lines2 { line-dasharray: 42, 42; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 42, 42, 0; }
		}
		[zoom >= 19] {
			line-width: 27;
			#cycling_restrictions_lines2 { line-dasharray: 54, 54; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 54, 54, 0; }
		}
		[zoom >= 20] {
			line-width: 33;
			#cycling_restrictions_lines2 { line-dasharray: 66, 66; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 66, 66, 0; }
		}
	}

	[highway='motorway_link'] {
		[zoom >= 12] {
			line-width: 1.5;
			#cycling_restrictions_lines2 { line-dasharray: 3, 3; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3, 3, 0; }
		}
		[zoom >= 13] {
			line-width: 4;
			#cycling_restrictions_lines2 { line-dasharray: 8, 8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 8, 8, 0; }
		}
		[zoom >= 15] {
			line-width: 7.8;
			#cycling_restrictions_lines2 { line-dasharray: 15.6, 15.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 15.6, 15.6, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 16;
			#cycling_restrictions_lines2 { line-dasharray: 32, 32; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 32, 32, 0; }
		}
		[zoom >= 20] {
			line-width: 33;
			#cycling_restrictions_lines2 { line-dasharray: 66, 66; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 66, 66, 0; }
		}
	}

	[highway='trunk'] {
		[zoom >= 6] {
			line-width: 0.4;
			#cycling_restrictions_lines2 { line-dasharray: 0.8, 0.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 0.8, 0.8, 0; }
		}
		[zoom >= 7] {
			line-width: 0.6;
			#cycling_restrictions_lines2 { line-dasharray: 1.2, 1.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.2, 1.2, 0; }
		}
		[zoom >= 8] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 9] {
			line-width: 1.4;
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 10] {
			line-width: 1.9;
			#cycling_restrictions_lines2 { line-dasharray: 3.8, 3.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.8, 3.8, 0; }
		}
		[zoom >= 11] {
			line-width: 1.9;
			#cycling_restrictions_lines2 { line-dasharray: 3.8, 3.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.8, 3.8, 0; }
		}
		[zoom >= 12] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 13] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 15] {
			line-width: 10;
			#cycling_restrictions_lines2 { line-dasharray: 20, 20; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 20, 20, 0; }
		}
		[zoom >= 17] {
			line-width: 18;
			#cycling_restrictions_lines2 { line-dasharray: 36, 36; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 36, 36, 0; }
		}
		[zoom >= 18] {
			line-width: 21;
			#cycling_restrictions_lines2 { line-dasharray: 42, 42; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 42, 42, 0; }
		}
		[zoom >= 19] {
			line-width: 27;
			#cycling_restrictions_lines2 { line-dasharray: 54, 54; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 54, 54, 0; }
		}
	}

	[highway='trunk_link'] {
		[zoom >= 12] {
			line-width: 1.5;
			#cycling_restrictions_lines2 { line-dasharray: 3, 3; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3, 3, 0; }
		}
		[zoom >= 13] {
			line-width: 4;
			#cycling_restrictions_lines2 { line-dasharray: 8, 8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 8, 8, 0; }
		}
		[zoom >= 15] {
			line-width: 7.8;
			#cycling_restrictions_lines2 { line-dasharray: 15.6, 15.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 15.6, 15.6, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 16;
			#cycling_restrictions_lines2 { line-dasharray: 32, 32; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 32, 32, 0; }
		}
	}

	[highway='primary'] {
		[zoom >= 8] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 9] {
			line-width: 1.4;
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 10] {
			line-width: 1.8;
			#cycling_restrictions_lines2 { line-dasharray: 3.6, 3.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.6, 3.6, 0; }
		}
		[zoom >= 11] {
			line-width: 1.8;
			#cycling_restrictions_lines2 { line-dasharray: 3.6, 3.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.6, 3.6, 0; }
		}
		[zoom >= 12] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 13] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 15] {
			line-width: 10;
			#cycling_restrictions_lines2 { line-dasharray: 20, 20; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 20, 20, 0; }
		}
		[zoom >= 17] {
			line-width: 18;
			#cycling_restrictions_lines2 { line-dasharray: 36, 36; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 36, 36, 0; }
		}
		[zoom >= 18] {
			line-width: 21;
			#cycling_restrictions_lines2 { line-dasharray: 42, 42; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 42, 42, 0; }
		}
		[zoom >= 19] {
			line-width: 27;
			#cycling_restrictions_lines2 { line-dasharray: 54, 54; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 54, 54, 0; }
		}
	}

	[highway='primary_link'] {
		[zoom >= 12] {
			line-width: 1.5;
			#cycling_restrictions_lines2 { line-dasharray: 3, 3; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3, 3, 0; }
		}
		[zoom >= 13] {
			line-width: 4;
			#cycling_restrictions_lines2 { line-dasharray: 8, 8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 8, 8, 0; }
		}
		[zoom >= 15] {
			line-width: 7.8;
			#cycling_restrictions_lines2 { line-dasharray: 15.6, 15.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 15.6, 15.6, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 16;
			#cycling_restrictions_lines2 { line-dasharray: 32, 32; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 32, 32, 0; }
		}
	}

	[highway='secondary'] {
		[zoom >= 9] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 10] {
			line-width: 1.1;
			#cycling_restrictions_lines2 { line-dasharray: 2.2, 2.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.2, 2.2, 0; }
		}
		[zoom >= 11] {
			line-width: 1.1;
			#cycling_restrictions_lines2 { line-dasharray: 2.2, 2.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.2, 2.2, 0; }
		}
		[zoom >= 12] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 13] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 14] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 15] {
			line-width: 9;
			#cycling_restrictions_lines2 { line-dasharray: 18, 18; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 18, 18, 0; }
		}
		[zoom >= 16] {
			line-width: 10;
			#cycling_restrictions_lines2 { line-dasharray: 20, 20; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 20, 20, 0; }
		}
		[zoom >= 17] {
			line-width: 18;
			#cycling_restrictions_lines2 { line-dasharray: 36, 36; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 36, 36, 0; }
		}
		[zoom >= 18] {
			line-width: 21;
			#cycling_restrictions_lines2 { line-dasharray: 42, 42; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 42, 42, 0; }
		}
		[zoom >= 19] {
			line-width: 27;
			#cycling_restrictions_lines2 { line-dasharray: 54, 54; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 54, 54, 0; }
		}
	}

	[highway='secondary_link'] {
		[zoom >= 12] {
			line-width: 1.5;
			#cycling_restrictions_lines2 { line-dasharray: 3, 3; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3, 3, 0; }
		}
		[zoom >= 13] {
			line-width: 4;
			#cycling_restrictions_lines2 { line-dasharray: 8, 8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 8, 8, 0; }
		}
		[zoom >= 15] {
			line-width: 7;
			#cycling_restrictions_lines2 { line-dasharray: 14, 14; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 14, 14, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 16;
			#cycling_restrictions_lines2 { line-dasharray: 32, 32; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 32, 32, 0; }
		}
	}

	[highway='tertiary'] {
		[zoom >= 10] {
			line-width: 0.7;
			#cycling_restrictions_lines2 { line-dasharray: 1.4, 1.4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.4, 1.4, 0; }
		}
		[zoom >= 11] {
			line-width: 0.7;
			#cycling_restrictions_lines2 { line-dasharray: 1.4, 1.4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.4, 1.4, 0; }
		}
		[zoom >= 12] {
			line-width: 2.5;
			#cycling_restrictions_lines2 { line-dasharray: 5, 5; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 5, 5, 0; }
		}
		[zoom >= 13] {
			line-width: 4;
			#cycling_restrictions_lines2 { line-dasharray: 8, 8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 8, 8, 0; }
		}
		[zoom >= 14] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 15] {
			line-width: 9;
			#cycling_restrictions_lines2 { line-dasharray: 18, 18; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 18, 18, 0; }
		}
		[zoom >= 16] {
			line-width: 10;
			#cycling_restrictions_lines2 { line-dasharray: 20, 20; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 20, 20, 0; }
		}
		[zoom >= 17] {
			line-width: 18;
			#cycling_restrictions_lines2 { line-dasharray: 36, 36; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 36, 36, 0; }
		}
		[zoom >= 18] {
			line-width: 21;
			#cycling_restrictions_lines2 { line-dasharray: 42, 42; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 42, 42, 0; }
		}
		[zoom >= 19] {
			line-width: 27;
			#cycling_restrictions_lines2 { line-dasharray: 54, 54; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 54, 54, 0; }
		}
	}

	[highway='tertiary_link'] {
		[zoom >= 12] {
			line-width: 1.5;
			#cycling_restrictions_lines2 { line-dasharray: 3, 3; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3, 3, 0; }
		}
		[zoom >= 13] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
		[zoom >= 15] {
			line-width: 7;
			#cycling_restrictions_lines2 { line-dasharray: 14, 14; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 14, 14, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 16;
			#cycling_restrictions_lines2 { line-dasharray: 32, 32; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 32, 32, 0; }
		}
	}

	[highway='residential'] {
		[zoom >= 12] {
			line-width: 0.5;
			#cycling_restrictions_lines2 { line-dasharray: 1, 1; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1, 1, 0; }
		}
	}

	[highway='unclassified'] {
		[zoom >= 12] {
			line-width: 0.8;
			#cycling_restrictions_lines2 { line-dasharray: 1.6, 1.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.6, 1.6, 0; }
		}
	}

	[highway='residential'],
	[highway='unclassified'] {
		[zoom >= 13] {
			line-width: 2.5;
			#cycling_restrictions_lines2 { line-dasharray: 5, 5; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 5, 5, 0; }
		}
		[zoom >= 14] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
		[zoom >= 15] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 16] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 17;
			#cycling_restrictions_lines2 { line-dasharray: 34, 34; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 34, 34, 0; }
		}
	}

	[highway='living_street'] {
		[zoom >= 13] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 14] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
		[zoom >= 15] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 16] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 17;
			#cycling_restrictions_lines2 { line-dasharray: 34, 34; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 34, 34, 0; }
		}
	}

	[highway='road'] {
		[zoom >= 14] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 16] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 17] {
			line-width: 7;
			#cycling_restrictions_lines2 { line-dasharray: 14, 14; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 14, 14, 0; }
		}
		[zoom >= 18] {
			line-width: 8.5;
			#cycling_restrictions_lines2 { line-dasharray: 17, 17; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 17, 17, 0; }
		}
		[zoom >= 19] {
			line-width: 11;
			#cycling_restrictions_lines2 { line-dasharray: 22, 22; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 22, 22, 0; }
		}
	}

	[highway='service'] {
		[zoom >= 14] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 16] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 17] {
			line-width: 7;
			#cycling_restrictions_lines2 { line-dasharray: 14, 14; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 14, 14, 0; }
		}
		[zoom >= 18] {
			line-width: 8.5;
			#cycling_restrictions_lines2 { line-dasharray: 17, 17; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 17, 17, 0; }
		}
		[zoom >= 19] {
			line-width: 11;
			#cycling_restrictions_lines2 { line-dasharray: 22, 22; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 22, 22, 0; }
		}
		[zoom >= 20] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
	}

	[highway='service-minor'] {
		[zoom >= 16] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 17] {
			line-width: 3.5;
			#cycling_restrictions_lines2 { line-dasharray: 7, 7; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 7, 7, 0; }
		}
		[zoom >= 18] {
			line-width: 4.75;
			#cycling_restrictions_lines2 { line-dasharray: 9.5, 9.5; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 9.5, 9.5, 0; }
		}
		[zoom >= 19] {
			line-width: 5.5;
			#cycling_restrictions_lines2 { line-dasharray: 11, 11; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 11, 11, 0; }
		}
		[zoom >= 20] {
			line-width: 8.5;
			#cycling_restrictions_lines2 { line-dasharray: 17, 17; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 17, 17, 0; }
		}
	}

	[highway='pedestrian'] {
		[zoom >= 14] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
		[zoom >= 15] {
			line-width: 5;
			#cycling_restrictions_lines2 { line-dasharray: 10, 10; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 10, 10, 0; }
		}
		[zoom >= 16] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 17] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 18] {
			line-width: 13;
			#cycling_restrictions_lines2 { line-dasharray: 26, 26; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 26, 26, 0; }
		}
		[zoom >= 19] {
			line-width: 17;
			#cycling_restrictions_lines2 { line-dasharray: 34, 34; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 34, 34, 0; }
		}
	}

	[highway='raceway'] {
		[zoom >= 12] {
			line-width: 1.2;
			#cycling_restrictions_lines2 { line-dasharray: 2.4, 2.4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.4, 2.4, 0; }
		}
		[zoom >= 13] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 14] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
		[zoom >= 15] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
		[zoom >= 18] {
			line-width: 8;
			#cycling_restrictions_lines2 { line-dasharray: 16, 16; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 16, 16, 0; }
		}
		[zoom >= 19] {
			line-width: 12;
			#cycling_restrictions_lines2 { line-dasharray: 24, 24; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 24, 24, 0; }
		}
		[zoom >= 20] {
			line-width: 24;
			#cycling_restrictions_lines2 { line-dasharray: 48, 48; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 48, 48, 0; }
		}
	}

	[highway='platform'] {
		[zoom >= 16] {
			line-width: 6;
			#cycling_restrictions_lines2 { line-dasharray: 12, 12; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 12, 12, 0; }
		}
	}

	[highway='steps'] {
		[zoom >= 14] {
			line-width: 1.4; /* doubled for better visibility */
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 15] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
	}

	[highway='bridleway'] {
		[zoom >= 13] {
			line-width: 0.6;
			#cycling_restrictions_lines2 { line-dasharray: 1.2, 1.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.2, 1.2, 0; }
		}
		[zoom >= 15] {
			line-width: 2.4;
			#cycling_restrictions_lines2 { line-dasharray: 4.8, 4.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4.8, 4.8, 0; }
		}
	}

	[highway='footway'],
	[highway='path'] {
		/* doubled for better visibility */
		[zoom >= 14] {
			line-width: 1.4;
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 15] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 16] {
			line-width: 2.6;
			#cycling_restrictions_lines2 { line-dasharray: 5.2, 5.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 5.2, 5.2, 0; }
		}
		[zoom >= 18] {
			line-width: 2.6;
			#cycling_restrictions_lines2 { line-dasharray: 5.2, 5.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 5.2, 5.2, 0; }
		}
		[zoom >= 19] {
			line-width: 3.2;
			#cycling_restrictions_lines2 { line-dasharray: 6.4, 6.4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6.4, 6.4, 0; }
		}
	}

	[highway='cycleway'] {
		/* doubled for better visibility */
		[zoom >= 13] {
			line-width: 1.4;
			#cycling_restrictions_lines2 { line-dasharray: 2.8, 2.8; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2.8, 2.8, 0; }
		}
		[zoom >= 15] {
			line-width: 1.8;
			#cycling_restrictions_lines2 { line-dasharray: 3.6, 3.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.6, 3.6, 0; }
		}
		[zoom >= 16] {
			line-width: 1.8;
			#cycling_restrictions_lines2 { line-dasharray: 3.6, 3.6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 3.6, 3.6, 0; }
		}
		[zoom >= 18] {
			line-width: 2;
			#cycling_restrictions_lines2 { line-dasharray: 4, 4; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 4, 4, 0; }
		}
		[zoom >= 19] {
			line-width: 2.6;
			#cycling_restrictions_lines2 { line-dasharray: 5.2, 5.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 5.2, 5.2, 0; }
		}
	}

	[highway='track'] {
		/* doubled for better visibility */
		[zoom >= 13] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 15] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
	}

	[highway='bus_guideway'] {
		[zoom >= 11] {
			line-width: 0.6;
			#cycling_restrictions_lines2 { line-dasharray: 1.2, 1.2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 1.2, 1.2, 0; }
		}
		[zoom >= 12] {
			line-width: 1;
			#cycling_restrictions_lines2 { line-dasharray: 2, 2; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 2, 2, 0; }
		}
		[zoom >= 13] {
			line-width: 3;
			#cycling_restrictions_lines2 { line-dasharray: 6, 6; }
			#cycling_restrictions_lines2::backward { line-dasharray: 0, 6, 6, 0; }
		}
	}
}

#cycling_restrictions_lines {
	[highway='footway'][access='restricted'] {
		/* Since "restricted" is the default for footways, we show them only at a higher zoom level and with less width.
		   If we showed them like other paths, the map would be completely cluttered with red lines along many roads
		   because cycling is forbidden on their sidewalk. */

		line-width: 0;
		[zoom >= 16] { line-width: 1.3; }
		[zoom >= 18] { line-width: 1.3; }
		[zoom >= 19] { line-width: 1.6; }
	}
}

#cycling_restrictions_lines2 {
	[forward=""] {
		line-width: 0;
	}

	::backward[backward=""] {
		line-width: 0;
	}
}

#cycling_restrictions_areas {
	[access='motorway'] { polygon-fill: @motorway-color; }
	[access='motorroad'] { polygon-fill: @motorroad-color; }
	[access='restricted'] { polygon-fill: @restricted-color; }
	[access='pedestrian'] { polygon-fill: @pedestrian-color; }
	[access='sidepath'] { polygon-fill: @sidepath-color; }
}