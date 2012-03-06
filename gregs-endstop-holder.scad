// PRUSA Mendel  
// Endstop holder
// Used to attach endstops to 8mm rods
// GNU GPL v2
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel

include <metric.scad>

/**
 * @name Endstop holder
 * @category Printed
 * @using 1 m3x20
 * @using 1 m3nut
 * @using 2 m3washer
 */
module endstop()
{
	outer_radius=m8_diameter/2+3.3;
	opening_size=m8_diameter-1.5;
	endstop_thickness=outer_radius-opening_size/2;
	screw_support_x=2.5;
	screw_support_z=1.5;
	hole_x_spacing=22.2;
	hole_y_spacing=10.3;
	endstop_clamp_height=10;
	endstop_height=15.9;

	full_height=hole_y_spacing+m3_nut_diameter+2*screw_support_z;
	screw_surround=m3_nut_diameter+screw_support_x*2;
	full_length=hole_x_spacing+m3_nut_diameter+screw_support_x*2;
	
	intersection()
	{
	difference()
	{
		union()
		{
			#cylinder(h=10,r=outer_radius,$fn=20);

			translate([0,-outer_radius, 0]) 
			cube([hole_x_spacing/2+m3_nut_diameter/2+screw_support_x,
				outer_radius*2,endstop_clamp_height]);

			translate([-hole_x_spacing/2-m3_nut_diameter/2-screw_support_x,
				outer_radius-endstop_thickness,0])
			cube([full_length,endstop_thickness,full_height]);


			for(i=[-1,1])
			translate([0,0,endstop_height/2])
			rotate([90, 0, 0]) 
			translate([i*hole_x_spacing/2,-1*i*hole_y_spacing/2,0])
			{
				if(i==1)
				translate([0,0,outer_radius-screw_support_z])
				cylinder(h=screw_support_z*2,
					r=(m3_nut_diameter/2+screw_support_z)/cos(30),$fn = 6);

				if(i==-1)
				translate([0,0,-outer_radius+endstop_thickness])
				render()
				intersection()
				{
				translate([0,-screw_support_z,0])
				cube([(m3_nut_diameter/2+screw_support_z)/cos(30)*2,
					m3_nut_diameter+screw_support_z*2+2*screw_support_z,								screw_support_z*2+2],center=true);

				cylinder(h=screw_support_z,
					r2=(m3_nut_diameter/2+screw_support_z)/cos(30),
					r1=(m3_nut_diameter/2+screw_support_z)/cos(30)+screw_support_z,$fn = 6);
				}
			}

		}
	
		translate([0,-opening_size/2,-1]) 
		cube([18,opening_size,endstop_clamp_height+2]);

		translate([0,0,-1]) 
		cylinder(h=hole_y_spacing+m3_nut_diameter+2*screw_support_z+2,r=m8_diameter/2,$fn=18);

		for(i=[-1,1])
		translate([0,0,endstop_height/2])
		rotate([90, 0, 0]) 
		translate([i*hole_x_spacing/2,-1*i*hole_y_spacing/2,0])
		{
			cylinder(h=outer_radius*2+2,r=m3_diameter/2,$fn=10,center=true);
			translate((i==-1)?
				[0,0,-outer_radius+endstop_thickness-1]:
				[0,0,outer_radius-1])
			cylinder(h=4,r= m3_nut_diameter/2,$fn=6);
		}

		translate([full_length/2,0,full_height])
		scale([(full_length-screw_surround)/(full_height-endstop_clamp_height),1,1])
		rotate([90,0,0])
		cylinder(r=full_height-endstop_clamp_height,h=outer_radius*2+2,center=true,$fn=50);
	}
	translate([-full_length/2,-outer_radius-5])
	cube([full_length,outer_radius*2+10,endstop_height]);
	}
}
endstop();

