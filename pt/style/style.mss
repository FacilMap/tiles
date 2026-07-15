/* ================================================================== */
/* ROUTE LINES                                                        */
/* ================================================================== */

#pt_lines {
    line-join: round;
    line-cap: round;

    [mode='ferry'] {
        line-color: #ff7fbf;
        [zoom >= 12][zoom <= 14] { line-width: 3; }
        [zoom >= 15] { line-width: 6; }
    }

    [mode='bus'] {
        line-color: #f00;
        [zoom >= 12][zoom <= 14] { line-width: 3; }
        [zoom >= 15] { line-width: 6; }

        [state='alternate'] {
            [zoom >= 12][zoom <= 14] { line-dasharray: 6, 6; }
            [zoom >= 15] { line-dasharray: 12, 12; }
        }
    }

    [mode='tram'], [mode='monorail'], [mode='funicular'] {
        line-color: #d0f;
        [zoom = 11] { line-width: 3; }
        [zoom >= 12] { line-width: 6; }
    }

    [mode='trolleybus'] {
        line-color: #b22;
        [zoom >= 11][zoom <= 14] { line-width: 3; }
        [zoom >= 15] { line-width: 6; }
    }

    [mode='aerialway'] {
        line-color: #642;
        [zoom >= 11][zoom <= 14] { line-width: 3; }
        [zoom >= 15] { line-width: 6; }
    }

    [mode='subway'] {
        line-color: #00f;
        [zoom = 11] { line-width: 3; }
        [zoom >= 12] { line-width: 6; }
    }

    [mode='fbahn'] {
        line-color: #000;
        [zoom >= 5][zoom <= 6] { line-width: 1; }
        [zoom = 6] { line-width: 2; }
        [zoom >= 7][zoom <= 8] { line-width: 5; }
        [zoom >= 9] { line-width: 8; }
    }

    [mode='sbahn'] {
        [zoom = 6] { line-color: #000; line-width: 1; }
        [zoom >= 7][zoom <= 8] { line-color: #0c0; line-width: 3; }
        [zoom >= 9] { line-color: #0c0; line-width: 6; }
    }
}

/* ================================================================== */
/* ROUTE LABELS (TEXT)                                                */
/* ================================================================== */

#pt_lines_text {
    text-name: "' ' + [ref] + ' '";
    text-face-name: "bold-fonts";
    text-halo-radius: 1;
    text-placement: line;
    text-repeat-distance: 30;
    text-spacing: 200;
    text-wrap-width: 12;
    text-wrap-character: ";";
    text-avoid-edges: true;

    [mode='ferry'] {
        text-fill: #ff7fbf;
        [zoom >= 12][zoom <= 14] { text-size: 8; }
        [zoom >= 15] { text-size: 11; }
    }

    [mode='bus'] {
        text-fill: #f00;
        [state='alternate'] { text-name: "'  (' + [ref] + ')  '"; }
        [state!='alternate'] { text-name: "'  ' + [ref] + '  '"; }
        [zoom >= 12][zoom <= 14] { text-size: 8; }
        [zoom >= 15] { text-size: 11; }
    }

    [mode='tram'], [mode='monorail'], [mode='funicular'] {
        text-fill: #d0f;
        [zoom = 11] { text-size: 8; }
        [zoom >= 12] { text-size: 11; }
    }

    [mode='trolleybus'] {
        text-fill: #b22;
        [zoom >= 11][zoom <= 14] { text-size: 8; }
        [zoom >= 15] { text-size: 11; }
    }

    [mode='aerialway'] {
        text-fill: #642;
        [zoom >= 11][zoom <= 14] { text-size: 8; }
        [zoom >= 15] { text-size: 11; }
    }

    [mode='subway'] {
        text-fill: #00f;
        [zoom = 11] { text-size: 8; }
        [zoom >= 12] { text-size: 11; }
    }

    [mode='fbahn'] {
        text-fill: #000;
        [zoom >= 7][zoom <= 8] { text-size: 9; }
        [zoom >= 9] { text-size: 12; }
    }

    [mode='sbahn'] {
        text-fill: #0c0;
        [zoom >= 7][zoom <= 8] { text-size: 8; }
        [zoom >= 9] { text-size: 11; }
    }
}

/* ================================================================== */
/* STATIONS (POINTS & POLYGONS)                                       */
/* ================================================================== */

#pt_stations_point, #pt_stations_poly {

    [type='mainstation'] {
        [zoom >= 7][zoom <= 10] {
            text-name: "[shortname]";
            text-face-name: "bold-fonts";
            text-size: 12;
            text-fill: black;
            text-halo-radius: 2;
        }
    }

    [type='station'] {
        [zoom >= 12][zoom <= 14] {
            marker-file: url('./symbols/station_small.png');
            text-name: "[name]";
            text-face-name: "bold-fonts";
            text-size: 10;
            text-fill: #000;
            text-dy: -8;
            text-halo-radius: 1;
        }
        [zoom >= 15] {
            marker-file: url('./symbols/station.png');
            text-name: "[name]";
            text-face-name: "bold-fonts";
            text-size: 12;
            text-fill: #000;
            text-dy: -10;
            text-halo-radius: 1;
        }
    }

    [type='halt'], [type='tram_stop'], [type='aerialway_station'] {
        [zoom >= 12][zoom <= 14] { marker-file: url('./symbols/halt.png'); }
        [zoom >= 13][zoom <= 14] {
            text-name: "[name]";
            text-face-name: "book-fonts";
            text-size: 9;
            text-fill: #000;
            text-dy: -7;
            text-halo-radius: 1;
        }
        [zoom >= 15] {
            marker-file: url('./symbols/station_small.png');
            text-name: "[name]";
            text-face-name: "book-fonts";
            text-size: 11;
            text-fill: #000;
            text-dy: -8;
            text-halo-radius: 1;
        }
    }

    [type='bus_stop'] {
        [zoom >= 13][zoom <= 14] { marker-file: url('./symbols/bus_stop_small.png'); }
        [zoom >= 15] {
            marker-file: url('./symbols/halt.png');
            text-name: "[name]";
            text-face-name: "book-fonts";
            text-size: 9;
            text-fill: #000;
            text-dy: -7;
            text-halo-radius: 1;
        }
    }

    [type='bus_station'] {
        [zoom >= 13][zoom <= 14] {
            marker-file: url('./symbols/halt.png');
            text-name: "[name]";
            text-face-name: "book-fonts";
            text-size: 9;
            text-fill: #000;
            text-dy: -7;
            text-halo-radius: 1;
        }
        [zoom >= 15] {
            marker-file: url('./symbols/station_small.png');
            text-name: "[name]";
            text-face-name: "book-fonts";
            text-size: 11;
            text-fill: #000;
            text-dy: -8;
            text-halo-radius: 1;
        }
    }
}