/* Copyright 2023 crafty_waffle
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE
 *
 * --- PRINT SETTINGS ---
 * Print with at least 3mm of walls, preferably in a good glass fiber or carbon
 * fiber reinforced nylon like Polymaker's PA6-GF. Ensure filament is DRY
 * before printing.
 *
 * Print top down with 0.12mm-0.2mm layer height using a 0.4mm-0.6mm nozzle
 *
 * Scale up x2540 if your slicer expects measurements in mm
 *
 */

$fn=64;

// stolen from here
// https://gist.github.com/groovenectar/92174cb1c98c1089347e
module rounded_cube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

    //echo(str("roundedcube([",size[0],size[1],size[2],"], radius=", radius, ", apply_to=",apply_to));
	translate_min = 0;
	translate_xmax = size[0];
	translate_ymax = size[1];
	translate_zmax = size[2];

	diameter = radius * 2;

    function adj2(i,dt,df) = (i==0)?dt:df;
    function adj(i,d) = adj2(i,d,-d);
    function adjR(i) = adj(i,radius);
    
	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (xi = [0:1]) {
                translate_x = [translate_min, translate_xmax][xi];
				x_at = (xi == 0) ? "min" : "max";
				for (yi = [0:1]) {
                    translate_y = [translate_min, translate_ymax][yi];
   				    y_at = (yi == 0) ? "min" : "max";
					for (zi = [0:1]) {
                        translate_z = [translate_min, translate_zmax][zi];
    	     			z_at = (zi == 0) ? "min" : "max";

						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
                            // GGS: Separate translates to asccomodate changes allowing sizes < 3 x radius
    						translate(v = [translate_x+adjR(xi), translate_y+adjR(yi), translate_z+adjR(zi)])
							  sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
                            //Compute cylinder height to make it work with cubbe sizes up to 3xradius which did not work
                            // in original because cylinders would "eat" spheres
                            h1 =
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? size[0]-radius : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? size[1]-radius :
								size[2]-radius
							);
                            h2 =
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? size[0]/4 : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? size[1]/4 :
								size[2]/4
							);
                            h=(h1<h2 && h1>0)?h1:h2;
                            height=(h<radius)?h:radius;
                            //echo(str("h1=",h1));
                            //echo(str("h2=",h2));
                            //echo(str("h=",h));
                            //echo(str("height=",height));
                            trans =
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [adj2(xi,0,-height),adjR(yi),adjR(zi)] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [adjR(xi),adj2(yi,0,-height),adjR(zi)] :
								[adjR(xi),adjR(yi),adj2(zi,0,-height)]
							);
                            //echo(trans);
                            translate(v = [translate_x+trans[0], translate_y+trans[1], translate_z+trans[2]])
		  					  rotate(a = rotate)
							    cylinder(h = height, r = radius, center = false);
						}
					}
				}
			}
		}
	}
}

center=0.750;
distance_between_pins=6+7/16;
receiver_length=6+3/8;
receiver_width=1+3/4;
receiver_height=1+1/4;
lug_width=0.490;

intersection() {
    difference() {
        union() {
            rounded_cube(size=[receiver_length, receiver_width, receiver_height], radius=0.125, apply_to="z");
            translate([receiver_length, receiver_width/2, receiver_height/2])
                cube(size=[1+7/64, lug_width, receiver_height], center=true);

            // front lug
            translate([lug_width/2, receiver_width/2, -lug_width/2]) difference() {
                hull() {
                    rotate([90, 0, 0]) cylinder(r=lug_width/2, h=lug_width, center=true);
                    translate([0, 0, 1]) rotate([90, 0, 0])
                        cylinder(r=lug_width/2, h=lug_width, center=true);
                }

                translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(r=5/16 /2, h=0.5, center=true);
            }

            // rear lug
            translate([lug_width/2 + distance_between_pins, receiver_width/2, -lug_width/2]) difference() {
                hull() {
                    rotate([90, 0, 0]) cylinder(r=lug_width/2, h=lug_width, center=true);
                    translate([0, 0, 1]) rotate([90, 0, 0])
                        cylinder(r=lug_width/2, h=lug_width, center=true);
                }
                translate([0, 0, 0]) rotate([90, 0, 0]) cylinder(r=5/16 /2, h=0.5, center=true);
            }
        }

        // firing pin channel
        translate([1.85, receiver_width/2, center]) rotate([0, 90, 0]) {
            cylinder(r=0.165 /2, h=3.155, center=true);
            translate([0, 0.0, 3.155/2 - 0.57/2])
                cylinder(r=0.380 /2, h=0.57, center=true);
        }

        // firing pin retaining pin channel
        translate([3+1/4, receiver_width/2, center-0.15]) rotate([90, 0, 0]) {
            cylinder(r=0.125 /2, h=receiver_width-0.42, center=true);
            translate([0, 0, receiver_width/2]) sphere(r=0.425 /2);
        }

        // outer adapter recess
        hull() {
            translate([0, receiver_width/2, center]) rotate([0, 90, 0])
                cylinder(r=(1+1/4) /2, h=1/4);
            translate([0, receiver_width/2, center+1]) rotate([0, 90, 0])
                cylinder(r=(1+1/4) /2, h=1/4);
        }
 
        // inner adapter recess
        hull() {
            translate([0.25, receiver_width/2, center]) rotate([0, 90, 0])
                cylinder(r=(1+1/2) /2, h=1/4);
            translate([0.25, receiver_width/2, center+1]) rotate([0, 90, 0])
                cylinder(r=(1+1/2) /2, h=1/4);
        }

        // hammer relief
        translate([3.35, receiver_width/2-receiver_width*9/16/2, 0])
            rounded_cube([2.65 , receiver_width*9/16, receiver_height], radius=0.125, apply_to="z");

        // front material reliefs
        translate([0, 4/8, 0]) hull() {
            translate([1, 0, -0.5]) cylinder(r=3/16, h=2);
            translate([2.75, 0, -0.5]) cylinder(r=3/16, h=2);
        }

        translate([0, receiver_width-4/8, 0]) hull() {
            translate([1, 0, -0.5]) cylinder(r=3/16, h=2);
            translate([2.75, 0, -0.5]) cylinder(r=3/16, h=2);
        }
    }

    // corner chamfers
    translate([0, receiver_width/2, -6/8]) rotate([45, 0, 0])
        cube([receiver_length+1, receiver_width*1.125, receiver_width*1.125]);
}
