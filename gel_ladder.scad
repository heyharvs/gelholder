$fn = 100;

gels = 4;
gel_width = 36; //431
gel_cut_width = 29;
gel_opening = 5;
gel_spacing = 15;

ladder_margin = 15;
ladder_length = gel_opening * gels + gel_spacing * (gels - 1) + ladder_margin * 2;
ladder_width = gel_width + gel_opening * 2;
ladder_thickness = 4;
ladder_round = 1;

stem_diameter = 46.5;
stem_radius = stem_diameter / 2;

zip_thickness = 1.5;
zip_width = 3.5;
zip_height = 6;

logo_head = 10;
logo_m_thick = 6;
logo_m_thin = 4;

module slot() {
    translate([0, 0, -(ladder_thickness / 2)]) {
        hull() {
            cube([gel_opening, gel_width, 0.01], true);
            translate([gel_opening, 0, ladder_thickness]) {
                cube([gel_opening, gel_cut_width, 0.01], true);
            }
        }
    }
}

module ladder() {
    difference() {
        union() {
            // initial ladder
            cube([ladder_length, ladder_width, ladder_thickness], true);
            
            // add on the front ring for the zip tie
            translate([-(ladder_length / 2 + stem_radius + ladder_margin) + zip_height, 0, zip_height / 2]) {
                    cylinder(ladder_thickness + zip_height, stem_diameter, stem_diameter, true);
            }        
        }
        
        translate([-(ladder_length / 2 + stem_radius + ladder_margin), 0, 0]) {
            cylinder(ladder_thickness * 5, stem_diameter, stem_diameter, true);
        }

        translate([-ladder_length, ladder_width, 0]) {
            cube([ladder_length * 2, ladder_width, ladder_thickness * 5], true);
        }

        translate([-ladder_length, -ladder_width, 0]) {
            cube([ladder_length * 2, ladder_width, ladder_thickness * 5], true);
        }
    }
    

    // round off the end of the ladder
    difference() {
        translate([ladder_length / 2 - stem_diameter * .8, 0, 0]) {
            cylinder(ladder_thickness, stem_diameter, stem_diameter, true);
        }
        translate([0, ladder_width, 0]) {
            cube([ladder_length * 10, ladder_width, ladder_thickness + .1], true);
        }
        translate([0, -ladder_width, 0]) {
            cube([ladder_length * 10, ladder_width, ladder_thickness + .1], true);
        }
    }

}

module stemzip() {
    difference() {
        cylinder(zip_height, stem_diameter, stem_diameter, true);
        scale([.95, .95, .95]) {
            cylinder(zip_height * 2, stem_diameter, stem_diameter, true);
        }
    }
}


// showtime!
module main() {
    difference() {
        ladder();
        translate([-(ladder_length / 2 + stem_radius + ladder_margin) + zip_height - zip_thickness, 0, zip_height / 2]) {
            stemzip();
        }    
        for (offset = [0: gels - 1]) {
            translate([(gel_opening + gel_spacing) * offset - ladder_length / 2 + ladder_margin * 1.75, 0, 0]) {
                slot();
                if (offset > 0) {
                    translate([- (gel_spacing / 2), ladder_width / 2, 0]) {
                        cube([zip_height, zip_width, ladder_thickness * 2], true);
                    }
                    translate([- (gel_spacing / 2), -ladder_width / 2, 0]) {
                        cube([zip_height, zip_width, ladder_thickness * 2], true);
                    }
                }
            }

        }
    }
}

module logo_half() {
    translate([0, -(logo_m_thick / 2 + 6), 0]) {    
        hull() {
            
            translate([-(logo_m_thick * 1), 4.5, 0]) {
                cube([logo_m_thick, logo_m_thick, logo_head], true);
            }
         
            translate([logo_m_thick + (logo_m_thick - logo_m_thin) / 2, 7, 0]) {
                cube([logo_m_thin, logo_m_thin, logo_head], true) {
                }
            }
        }
        translate([-(logo_m_thick * 1), 0, 0]) {
            cube([logo_m_thick, logo_m_thick, logo_head], true);
        }
        
        translate([0, 0, 0]) {
            cube([logo_m_thick * 3, logo_m_thick, logo_head], true);
        }
    }
}

module logo() {
    translate([0, logo_m_thick * 3 - 3, 0]) {
        cylinder(logo_head, 4.5, 4.5, true);
    }
    rotate([0, 0, -90]) {
        translate([0, logo_m_thin / 2, 0]) {
            logo_half();
        }
        translate([0, -(logo_m_thin / 2), 0]) {
            mirror([0, 1, 0]) {
                logo_half();
            }
        }
    }
}


rotate([0, 0, -90]) {
    main();
}

translate([0, ladder_length / 2 - ladder_margin - gel_spacing + 8, 2]) {
    scale([.3, .3, .3]) {
        logo();
    }
}