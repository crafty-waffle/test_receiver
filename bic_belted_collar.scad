$fn=64;

module bic_belted_collar(bic_diameter, adapter_diameter, adapter_height) {
    difference() {
        union () {
            // body
            cylinder(r=adapter_diameter/2, h=adapter_height+1/8);

            // outer belt
            belt_diameter=adapter_diameter+0.050;
            translate([0, 0, adapter_height/2])
                    cylinder(r=belt_diameter/2, h=1/8, center=true);

            // overhang chamfer
            translate([0, 0, adapter_height/2 - (1/16 + 0.025)])
                cylinder(r1=adapter_diameter/2, r2=belt_diameter/2, h=0.050, center=true);
        }

        // inside
        cylinder(r=bic_diameter/2, h=adapter_height);

        // interior taper
        translate([0, 0, adapter_height])
            cylinder(r1=bic_diameter/2, r2=(bic_diameter+0.025)/2, h=1/8);
    }
}

bic_belted_collar(0.715, 15/16, 3/8);