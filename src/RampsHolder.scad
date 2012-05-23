// PRUSA Mendel
// RampsHolder [rh]
// Used to attach endstops to 8mm rods
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

include <units.scad>
include <metric.scad>
include <config.scad>

rh_mode = "-";
//rh_mode = "print";  $fn=24*4;
//rh_mode = "print Long";  $fn=24*4;
//rh_mode = "print mirrored";  $fn=24*4;
//rh_mode = "print Long mirrored";  $fn=24*4;
//rh_mode = "assembly";  $fn=24*4;


module ramps_holder(hole_offset=0,endstop_width=10,with_foot=false, addLength = 8){
	outer_diameter= m8_diameter+3.3*2;
	screw_hole_spacing=48.26;
	opening_size = m8_diameter-1.5; //openingsize

	distHolder_height = 2.5;

	xdirRodAltitude = c_xDirSupp_thredRod_altitude[0];
	foot_height=xdirRodAltitude - outer_diameter/2 ;
	difference()
	{
		union()
		{
			translate([outer_diameter/2, outer_diameter/2, 0])
				cylinder(h=endstop_width, r = outer_diameter/2, $fn = 20);
			translate([outer_diameter/2, 0, 0])
				cube([15.5,outer_diameter,endstop_width]);
			translate([-(screw_hole_spacing+addLength), 0, 0])
				cube([screw_hole_spacing+addLength+10, 4, endstop_width]);

			if (with_foot)
			{
				translate([-addLength + 8, 0, 0]) {
					translate([-screw_hole_spacing+4,-foot_height,0])
						cube([4, foot_height+1, endstop_width]);

					translate([-screw_hole_spacing+4+3,-foot_height,0])
					difference()
					{
						cube([foot_height, foot_height, endstop_width]);
						translate([foot_height,0,-1])
							cylinder(r=foot_height,h=endstop_width+2);
					}
				}
			}

			translate([-addLength + 8, 0, 0]) {
				for(hole=[-1,1])
				translate([-4-screw_hole_spacing/2-screw_hole_spacing/2*hole,
					4,endstop_width/2+hole*hole_offset/2])
				rotate([-90, 0, 0])
				cylinder(h=distHolder_height, r = m3_diameter/2+1, $fn = 10);

				for(hole=[-1,1])
				translate([-4-screw_hole_spacing/2-screw_hole_spacing/2*hole,
					3.99,endstop_width/2+hole*hole_offset/2])
				rotate([-90, 0, 0])
				render()
				intersection()
				{
				cylinder(h=distHolder_height, r2 = m3_diameter/2+1,r1 = m3_diameter/2+2.7, $fn = 10);
				translate([-m3_diameter/2-1,0,0])
				cube([m3_diameter+2,endstop_width/2-hole_offset/2,distHolder_height]);
				}
			}
		}


		translate([9, outer_diameter/2-opening_size/2,-1])
		cube([18,opening_size,endstop_width+2]);
		translate([outer_diameter/2, outer_diameter/2, -1])
		cylinder(h=endstop_width+2, r = m8_diameter/2, $fn = 18);

		translate([17,-1,endstop_width/2])
		rotate([-90, 0, 0])
		{
			cylinder(h=outer_diameter+2, r = m3_diameter/2, $fn = 10);
			cylinder(h=3, r = m3_nut_diameter/2, $fn = 6);
		}

		translate([-addLength + 8, 0, 0])
		for(hole=[-1,1])
		translate([-4-screw_hole_spacing/2-screw_hole_spacing/2*hole,
			-1,endstop_width/2+hole*hole_offset/2])
		rotate([-90, 0, 0])
		{
			cylinder(h=outer_diameter+2, r = m3_diameter/2, $fn = 10);
			cylinder(h=3, r = m3_nut_diameter/2, $fn = 6);
		}
	}
}

module rh_rampsholder_print(addLength = 8, isMirrored = false)
{
	if (isMirrored) {
		translate([0,18,0])
			ramps_holder(hole_offset=-6.35,endstop_width=15,with_foot=true,addLength=addLength);
		ramps_holder(hole_offset=1.3,endstop_width=10,with_foot=true,addLength=addLength);
	} else {
		translate([0,18,0])
			ramps_holder(hole_offset=6.35,endstop_width=14,with_foot=true,addLength=addLength);
		ramps_holder(hole_offset=-1.3,endstop_width=10,with_foot=true,addLength=addLength);
	}
}

if (rh_mode == "print") {
	rh_rampsholder_print(addLength = 8);
}
if (rh_mode == "print Long") {
	rh_rampsholder_print(addLength = 18);
}
if (rh_mode == "print mirrored") {
	rh_rampsholder_print(addLength = 8, isMirrored = true);
}
if (rh_mode == "print Long mirrored") {
	rh_rampsholder_print(addLength = 18, isMirrored = true);
}

module rh_assembly() {
	rotate(a=90,v=Z)
	translate([-7.5, 0, -7.5]) {
		rotate(a=90,v=X)
			ramps_holder(hole_offset=0,endstop_width=10,with_foot=true);
		translate([0, -70, 0])
		rotate(a=90,v=X)
			ramps_holder(hole_offset=6.35,endstop_width=14,with_foot=true);
	}
}

if (rh_mode == "assembly") {
	rh_assembly();
}



