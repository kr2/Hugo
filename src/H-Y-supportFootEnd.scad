/* H-Y-supportFootEnd [Ysf]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
Ysf_mode = "-";  
//sf_mode = "print";  // can be print or inspect [overlays the Ysf_model with the original Ysf_model] (uncomment next line)
//Ysf_mode = "inspect";
//Ysf_mode = "assembly";
$fn=48;

Ysf_thinWallThickness          = 1;
Ysf_genWallThickness           = 2.5;
Ysf_strongWallThickness        = 8;

Ysf_horizontalSuportThickness  = 0.3;
Ysf_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
Ysf_roughRod_diam                   = 8.5;

/*------------------------------------supportFootEnd--------------------------*/
Ysf_sFooEnd_size = [(8.267+9.25)*2,(8.267+9.25)*2,Ysf_strongWallThickness];

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ysf_acrossStrive_angle = atan(Ysf_sFooEnd_size[0]/Ysf_sFooEnd_size[1]);
_Ysf_acrossStrive_diam = min(Ysf_sFooEnd_size[0],Ysf_sFooEnd_size[1])/4;
_Ysf_acrossStrive_length = distance1D(Ysf_sFooEnd_size[0],Ysf_sFooEnd_size[1])-_Ysf_acrossStrive_diam*2.4;

module  H_Y_supportFootEnd() {
	difference() {
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=Ysf_roughRod_diam/2+Ysf_genWallThickness, h=Ysf_sFooEnd_size[2], center=false);

			intersection() {
			translate([0, 0, Ysf_sFooEnd_size[2]/2]) 
				cube(size=Ysf_sFooEnd_size, center=true);

			for (i=[0,1])
			rotate(a=90*i-_Ysf_acrossStrive_angle,v=Z) 
			translate([-_Ysf_acrossStrive_length/2, 0, 0]) 
			linear_extrude(height=Ysf_sFooEnd_size[2])
				barbell (r1=_Ysf_acrossStrive_diam,r2=_Ysf_acrossStrive_diam,r3=_Ysf_acrossStrive_length,r4=_Ysf_acrossStrive_length,separation=_Ysf_acrossStrive_length);
			}
		}
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=Ysf_roughRod_diam/2, h=Ysf_sFooEnd_size[2]+2*OS, center=false);
		}
	}
	

}


if (Ysf_mode == "inspect") {
	H_Y_supportFootEnd();
}
module H_Y_supportFootEnd_print() {
	H_Y_supportFootEnd();
}
if (Ysf_mode == "print") {
	H_Y_supportFootEnd_print();
}



/*------------------------------------assembly--------------------------------*/

module H_Y_supportFootEnd_assembly() {
	translate([0, Ysf_sFooEnd_size[2]/2, 0]) 
	rotate(a=90,v=X) 
	H_Y_supportFootEnd();
}

if (Ysf_mode == "assembly"){
	H_Y_supportFootEnd_assembly();
}
