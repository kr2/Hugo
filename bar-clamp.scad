// PRUSA Mendel  
// Bar clamp
// Used for joining 8mm rods
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

include <configuration.scad>
use <teardrop.scad>

/**
 * @name Bar clamp
 * @category Printed
 * @using 2 m8nut
 * @using 2 m8washer
 */ 

module barclamp()
{
	outer_radius=m8_diameter/2+3.3;
	clamp_length=17.5;
	clamp_height=2*outer_radius;
	slot_width=5;

	difference()
	{
		union()
		{			
			translate([outer_radius, outer_radius, 0])
			cylinder(h=outer_radius*2,r=outer_radius, $fn = 20);

			translate([outer_radius, 0, 0])
			cube([clamp_length-outer_radius,outer_radius*2,clamp_height]);

			rotate(90)
			translate([0,-18,outer_radius])
			teardrop(r=outer_radius,h=clamp_height,top_and_bottom=true);
		}
	
		translate([outer_radius,outer_radius-slot_width/2,-1])
		cube([clamp_length+1,slot_width,clamp_height+2]);

		translate([outer_radius, outer_radius,-1]) 
		#cylinder(h=clamp_height+2,r=m8_diameter/2,$fn=18);

		translate([17,outer_radius*2+1,outer_radius]) rotate([90,0,0]) 
		#cylinder(h=outer_radius*2+2,r=m8_diameter/2,$fn=20);
	}
}

barclamp();
