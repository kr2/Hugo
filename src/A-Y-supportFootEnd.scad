/* A-Y-supportFootEnd [Ysf]
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
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
mode = "inspect";
$fn=48;

thinWallThickness          = 1;
genWallThickness           = 2.5;
strongWallThickness        = 8;

horizontalSuportThickness  = 0.3;
verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
roughRod_diam                   = 8.5;

/*------------------------------------supportFootEnd--------------------------*/
sFooEnd_size = [(8.267+9.25)*2,(8.267+9.25)*2,strongWallThickness];

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_acrossStrive_angle = atan(sFooEnd_size[0]/sFooEnd_size[1]);
_acrossStrive_diam = min(sFooEnd_size[0],sFooEnd_size[1])/4;
_acrossStrive_length = distance1D(sFooEnd_size[0],sFooEnd_size[1])-_acrossStrive_diam*2.4;

module  A_Y_supportFootEnd() {
	difference() {
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=roughRod_diam/2+genWallThickness, h=sFooEnd_size[2], center=false);

			intersection() {
			translate([0, 0, sFooEnd_size[2]/2]) 
				cube(size=sFooEnd_size, center=true);

			for (i=[0,1])
			rotate(a=90*i-_acrossStrive_angle,v=Z) 
			translate([-_acrossStrive_length/2, 0, 0]) 
			linear_extrude(height=sFooEnd_size[2])
				barbell (r1=_acrossStrive_diam,r2=_acrossStrive_diam,r3=_acrossStrive_length,r4=_acrossStrive_length,separation=_acrossStrive_length);
			}
		}
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=roughRod_diam/2, h=sFooEnd_size[2]+2*OS, center=false);
		}
	}
	

}


if (mode == "inspect") {
	 A_Y_supportFootEnd();
}
module A_Y_supportFootEnd_print() {
	A_Y_supportFootEnd();
}
if (mode == "print") {
	A_Y_supportFootEnd_print();
}


