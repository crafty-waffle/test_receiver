$fn=64;

headspace=9/32;

difference() {
    union() {
        // base
        cylinder(r=(1+5/16) /2, h=1/4-0.015);

        // shell holder
        cylinder(r=(1+1/4) /2, h=3/4);
    }

    // belt recess
    translate([0, 0, headspace]) {
        adapter_diameter=15/16;
        adapter_height=3/8;
        taper_height=1/8;
        hull() {
            cylinder(r=adapter_diameter/2, h=adapter_height+taper_height);
            translate([2, 0, 0])
                cylinder(r=adapter_diameter/2, h=adapter_height+taper_height);
        }

        belt_height=1/8+0.030;
        belt_diameter=adapter_diameter+0.0525;
        translate([0, 0, adapter_height/2]) hull() {
            cylinder(r=belt_diameter/2, h=belt_height, center=true);
            translate([2, 0, 0]) cylinder(r=belt_diameter/2, h=belt_height, center=true);
        }

        // overhang chamfer
        translate([0, 0, adapter_height/2 - 0.1]) hull() {
            cylinder(r1=adapter_diameter/2, r2=belt_diameter/2, h=0.050, center=true);
            translate([2, 0, 0]) cylinder(r1=adapter_diameter/2, r2=belt_diameter/2, h=0.050, center=true);
        }
    }

    // firing pin hole
    cylinder(r=5/32 /2, h=1);
}