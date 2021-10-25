use <threadlib/threadlib.scad>

name = "XX";
number_of_thread_turns = 3;
main_body_height = 12;
notches_count = 11;
top_part_height = 8;
main_body_width = 10.12;
inner_sphere_r = 6;

$fn = 100;

// Downscale everything 1% so that threads fit nicely
scale([0.99, 0.99, 0.99]) {
    difference() {
        union() {
            // Threads
            translate([0, 0, (top_part_height)+3])
                bolt("G5/8", number_of_thread_turns);
            // Bottom / inner part
            translate([0, 0, top_part_height]) {
                difference() {
                    // Main body; overlaps with bolt defined above
                    union() {
                        cylinder(h=main_body_height, r=main_body_width, $fn=100);
                        translate([0,0,main_body_height])
                            rotate_extrude()
                                translate([8, 0, 0])
                                    circle((main_body_width-inner_sphere_r)/2);

                    }
                    // Cross two cylinders to have nice overpressure channels
                    translate([0, 0, (main_body_height + 2.1 + 0.75)]) {
                        rotate([0, 90, 0]) {
                            cylinder(h=40, r=2, center=true);
                            rotate([90, 0, 0])
                                cylinder(h=40, r=2, center=true);
                        }
                    }
                }
            }
            // Lid / top part
            difference() {
                // Move by +.01mm to avoid rendering errors for overlapping elements
                translate([0, 0, top_part_height/2+0.01]) {
                    intersection() {
                        // Main body
                        cylinder(h=top_part_height, r=14, center=true);
                        // & rounding for top and bottoms
                        translate([0, 0, top_part_height]) sphere(r=17);
                        translate([0, 0, -top_part_height]) sphere(r=17);
                    }
                }
                // Notches for opening and closing the plug
                for (i = [ 0: notches_count ]) {
                    rotate([0, 0, i*(360 / (notches_count + 1))])
                        translate([17, 0, 0])
                            cylinder(r=4, h=top_part_height);
                }
                translate([-6, 0, -.5])
                    rotate([0, 0, 90])
                        mirror([1, 0, 0])
                        linear_extrude(1)
                            scale([0.7, 0.7, 0.7])
                                text(name, halign="center", valign="center");
            }
        }
        // Hole for a cord; offset to a side so that there's no intersection with overpressure hole.
        translate([7,0,top_part_height/2])
            rotate([90,0,0])
                cylinder(h=30, r=1.5, center=true);

        // Overpressure hole
        cylinder(h=40, r=2, center=true);
        // Round indent on the inner side
        translate([0,0,main_body_height+top_part_height]) cylinder(h=14, r=inner_sphere_r, center=true);
        translate([0,0,main_body_height+top_part_height-7]) sphere(r=inner_sphere_r);
    }
}