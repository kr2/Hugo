/* TabelClamp [tc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>
include <metric.scad>
include <H-Y-beltClamp_alternativ.scad>
include <teardrop.scad>


/*------------------------------------general---------------------------------*/
tc_mode = "-";
tc_mode = "printSet";  $fn=24*4;    // can be print or inspect [overlays the tc_model with the original tc_model] (uncomment next line)
//tc_mode = "print";  $fn=24*4;
//tc_mode = "inspect";

tc_thinWallThickness         = 1;
tc_genWallThickness          = 3;
tc_strongWallThickness       = 9;

tc_horizontalSuportThickness = 0.35;
tc_verticalSupportThickness  = 0.5;


/*------------------------------------rod-------------------------------------*/
tc_rod_diam                  = m8_diameter;

/*------------------------------------general---------------------------------*/

tc_thickness                 = tc_strongWallThickness;
tc_side                      = tc_rod_diam + 2*tc_genWallThickness;
tc_clip_offset               = tc_rod_diam/2 + 6;
tc_clip_size                 = [tc_side,7,3.5];

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
module TabelClamp() {
	difference() {
		union(){
			cube(size=[tc_side, tc_thickness, tc_side], center=true);

			translate([-tc_side/2, -tc_thickness/2, 0]) 
			cube(size=[tc_side, tc_thickness, tc_clip_offset], center=false);

			translate([0, 0, tc_clip_offset]) 
			rotate(a=90,v=Y) 
			rotate(a=90,v=Z) 
			linear_extrude(height = tc_clip_size[0], center = true, convexity = 10, twist = 0)
				polygon(points=[[-tc_thickness/2,0], [tc_thickness/2 + tc_clip_size[1],0], [tc_thickness/2,tc_clip_size[2]], [-tc_thickness/2,tc_clip_size[2]]]);
		}
		union(){
			rotate(a=90,v=X) 
				cylinder(r=tc_rod_diam/2, h=tc_thickness+2*OS, center=true);
		}
	}
}

module beltClamp() {
	translate([0, 0, tc_genWallThickness]) 
	difference() {
		union(){
			H_yBeltClam_alt(HasFoot = false);

			translate([0, -_Ybda_base_size[1]/2, tc_rod_diam/2]) 
			rotate(a=90,v=Z) 
			rotate(a=180,v=X) 
				teardropFlat (r=tc_rod_diam/2 + tc_genWallThickness,h=_Ybda_base_size[1],top_and_bottom=false);	
		}
		union(){
			translate([0, -_Ybda_base_size[1]/2 - OS, tc_rod_diam/2]) 
			rotate(a=90,v=Z) 
				teardrop (r=tc_rod_diam/2,h=_Ybda_base_size[1]+2*OS,top_and_bottom=false);
		}
	}
}
//!beltClamp();



if (tc_mode == "inspect") {
	TabelClamp();
}
module TabelClamp_print() {
	translate([0, 0, tc_side/2]) 
	rotate(a=90,v=Y) 
		TabelClamp();
}
module TabelClamp_printSet() {
	translate([0, tc_thickness + 2, 0]) {
		translate([0, -tc_thickness/2 - 0.5, 0]) 
		TabelClamp_print();

		translate([0, tc_thickness/2 + 0.5, 0]) 
		rotate(a=180,v=Z) 
			TabelClamp_print();
	}

	for (i=[-1 ,1]) 
	translate([i*( tc_genWallThickness + tc_rod_diam/2 + 0.5), -_Ybda_base_size[1]/2-0.5, 0]) 
		beltClamp();
}
if (tc_mode == "printSet") {
	TabelClamp_printSet();
}
if (tc_mode == "print") {
	TabelClamp_print();
}


