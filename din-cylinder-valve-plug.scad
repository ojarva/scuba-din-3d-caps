use <threadlib/threadlib.scad>

number_of_thread_turns = 4;
main_body_height = 16;
notches_count = 11;
$fn = 100;

// Downscale everything 1% so that threads fit nicely
scale([0.99, 0.99, 0.99]) {
    difference() {
        union() {
            // Threads
            translate([0,0,5]) bolt("G5/8", number_of_thread_turns);
            // Bottom / inner part
            difference() {
                // Main body; overlaps with bolt defined above
                union() {
                    cylinder(h=main_body_height, r=10.12, $fn=100);
                    translate([0,0,main_body_height]) rotate_extrude() translate([8,0,0]) circle(2.1);

                }
                // Cross two cylinders to have nice overpressure channels
                rotate([0, 90, 0])
                    translate([-19, 0, -(main_body_height + 2)])
                        cylinder(h=40, r=2);
                rotate([90, 90, 0])
                    translate([-19, 0, -(main_body_height+2)])
                        cylinder(h=40, r=2);
            }
            // Move by -1mm to avoid rendering errors for overlapping elements
            translate([0,0,-1]) {
                // Lid / top part
                difference() {
                    intersection() {
                        // Main body
                        cylinder(h=8, r=14, center=true);
                        // & rounding for top and bottoms
                        translate([0,0,8]) sphere(r=17);
                        translate([0,0,-8.5]) sphere(r=17);
                    }
                    // Notches for opening and closing the plug
                    for (i = [ 0: notches_count ]) {
                        rotate([0,0,i*(360 / (notches_count + 1))])
                            translate([17,0,-5])
                                cylinder(r=4, h=10);
                    }
                    // Hole for a cord; offset to a side so that there's no intersection with overpressure hole.
                    translate([6.8,30,-.5]) rotate([90,0,0]) cylinder(h=60, r=1.5);
                }
            }
        }
        // Overpressure hole
        cylinder(h=40, r=2, center=true);
        // Round indent on the inner side
        translate([0,0,16]) sphere(r=6);
    }
}