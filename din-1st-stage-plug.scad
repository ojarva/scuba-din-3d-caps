use <threadlib.scad>
include <BOSL2/std.scad>
include <BOSL2/knurling.scad>

// Change this for whatever you want to have on the top; leave empty for no text.
name = "XX";

type = "G5/8";
turns = 4;
Douter = 27;
higbee_arc = 45;
$fn = 100;

module donut(r1, r2) {
    rotate_extrude() translate([r1,0,0]) circle(r2);
}

difference() {
    union() {
        // Upscale everything a tiny bit so that threads fit nicely
        scale([1.02, 1.02, 1.02]) {
            translate([0,0,9]) nut(type, turns, Douter, higbee_arc=higbee_arc);
            // Top part
            difference() {
                intersection () {
                    difference() {
                        // Top cylinder
                        knurled_cylinder(r=16.16, count=60, l=6);
                        // Minus text
                        mirror([1, 0, 0]) translate([-9, -5, -5.6])
                            linear_extrude(3.2) text(name);
                    }
                    // Round the edges nicely
                    translate([0, 0, -4.1])
                        union() {
                            // This is just a filler for intersection with a donut.
                            cylinder(h=8, r=13.16);
                            translate([0, 0, 4]) donut(13.7, 3.2);
                        }
                }
                // Inset for 300-bar 1st stage knob
                translate([0,0,1.1]) cylinder(h=4, r=5.25, center=true);
            }
            // Raised platform for the o ring
            translate([0,0,3])
            difference() {
                cylinder(h=0.3, r=8.75);
                translate([0, 0, -0.1]) cylinder(h=0.6, r=5.75);
            }
            // Sides
            difference() {
                translate([0,0,9]) cylinder(h=20, r=14, center=true);
                translate([0,0,9]) cylinder(h=20.2, r=11.6, center=true);
            }
            // Rounded bottom
            translate([0,0,19]) donut(12.8,1.2);
        }
    }
    rotate([0,0,90])
        translate([12,20,0])
            rotate([90,0,0])
                cylinder(r=2.5/2, h=40);
}