/* H-BedClamp [Bc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>
include <metric.scad>
include <utilities.scad>


/*------------------------------------general---------------------------------*/
Bc_mode = "-";
Bc_mode = "printSet";  $fn=24*4;    // can be print or inspect [overlays the Bc_model with the original Bc_model] (uncomment next line)
//Bc_mode = "print";  $fn=24*4;
//Bc_mode = "inspect";
//Bc_mode = "assembly";

Bc_thinWallThickness         = 1;
Bc_genWallThickness          = 3;
Bc_strongWallThickness       = 9;

Bc_horizontalSuportThickness = 0.35;
Bc_verticalSupportThickness  = 0.5;

/*------------------------------------screws---------------------------------*/
Bc_hole_diam = m3_diameter;
Bc_nut_diam = m3_nut_diameter;
Bc_nut_heigth = m3_nut_heigth;
Bc_nut_wallDist = m3_nut_wallDist;

/*------------------------------------general---------------------------------*/
Bc_hole_dist = distance1D(20,20);

Bc_elongetatedHole_len = 6;

Bc_clip_thickness = 2;
Bc_heigth = 5;

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
Bc_ydir = Bc_elongetatedHole_len + 2*Bc_genWallThickness + Bc_hole_diam;
module H_BedClamp() {
	difference() {
		union(){
			translate([0, 0, Bc_heigth/2]) 
				cube(size=[Bc_hole_dist + Bc_hole_diam + 2*Bc_genWallThickness, Bc_ydir, Bc_heigth], center=true);	
		}
		union(){
			for (i=[-Bc_hole_dist/2,Bc_hole_dist/2]) 
			translate([i, 0, -OS])
			rotate(a=90,v=Z)  
				elongetatedHole(r=Bc_hole_diam/2,h=Bc_heigth+2*OS,l=Bc_elongetatedHole_len,center=false);

			translate([0, Bc_ydir/2, -OS]) 
				cylinder(r=(Bc_hole_dist - Bc_hole_diam)/2, h=Bc_heigth- Bc_clip_thickness, center=false , $fn=4);
		}
	}
}




if (Bc_mode == "inspect") {
	H_BedClamp();
}
module H_BedClamp_print() {
	translate([0, 0, Bc_heigth]) 
	rotate(a=180,v=X) 
	H_BedClamp();
}
module H_BedClamp_printSet() {
	for (i=[-1:2]) 
	translate([0, i*(Bc_ydir+1)-Bc_ydir/2, 0]) 
		H_BedClamp_print();
}
if (Bc_mode == "printSet") {
	H_BedClamp_printSet();
}
if (Bc_mode == "print") {
		H_BedClamp_print();
}



module elongetatedHole(r=1,h=1,l=2,center=true) {
	for (i=[-l/2,l/2]) 
	translate([i, 0, 0]) 
		cylinder(r=r, h=h, center=center);

	if (center) {
		cube(size=[l, r*2, h], center=true);
	}
	else{
		translate([0, 0, h/2]) 
		cube(size=[l, r*2, h], center=true);
	}

}
//!elongetatedHole(r=1,h=1,l=2,center=false);