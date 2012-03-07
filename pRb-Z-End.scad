/* pRb-endstop-holder
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
//mode = "inspect";
$fn=48;

genWallThickness           = 2.5;
strongWallThickness        = 5;

horizontalSuportThickness  = 0.3;
verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
smoothRod_diam                   = 8.0;
roughRod_diam                   = 8.5;

/*------------------------------------zEnd------------------------------------*/
zEnd_rodsDist = 28.315;
zEnd_heigt = 40;
zEnd_nuttrap_offset = 13;

/*------------------------------------bearing---------------------------------*/
bear_diam = 22.6;
bear_heigth = 10;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_zDir = zEnd_heigt;
_xDir = _zDir-(genWallThickness+smoothRod_diam/2);

_support_radius = (smoothRod_diam/2+genWallThickness)*0.6;

module pRb_Z_end() {
	_bearSuppCoutout_scale = (zEnd_rodsDist+bear_diam/2+genWallThickness- smoothRod_diam/2 - genWallThickness/2)/(_zDir- bear_heigth -genWallThickness);
	difference() {
		union(){
			cylinder(r=smoothRod_diam/2 + genWallThickness, h=_zDir, center=false);

			// bearing holder
			translate([-zEnd_rodsDist, 0, 0]) 
			cylinder(r=bear_diam/2 +genWallThickness, h=bear_heigth+genWallThickness, center=false);

			//connector
			translate([-zEnd_rodsDist, 0, 0]) 
			linear_extrude(height=_zDir)
				barbell (r1=bear_diam/2+genWallThickness,r2=smoothRod_diam/2+genWallThickness,r3=zEnd_rodsDist/3,r4=zEnd_rodsDist/3,separation=zEnd_rodsDist); 

			// x dir rod
			translate([0, 0, roughRod_diam/2+genWallThickness]) 
			rotate(a=180,v=X) 
				teardrop (r=roughRod_diam/2+genWallThickness,h=_xDir,top_and_bottom=false);

			// x dir support
			translate([0, 0, roughRod_diam/2+genWallThickness]) 
			intersection() {
				rotate(a=90,v=X) 
				rotate_extrude(convexity = 10)
					barbell (r1=_support_radius,r2=_support_radius,r3=_xDir*1,r4=_xDir*1,separation=_xDir-_support_radius); 
				translate([0, -(roughRod_diam+2*genWallThickness)/2, 0]) 
					cube(size=[_xDir, roughRod_diam+2*genWallThickness, _xDir], center=false);
			}
			
			
			

		}
		union(){
			translate([0, 0, genWallThickness]) 
				cylinder(r=smoothRod_diam/2, h=_zDir+2*OS, center=false);
			// bearing holder
			translate([-zEnd_rodsDist, 0, -OS]) {
				cylinder(r=bear_diam/2, h=bear_heigth+OS, center=false);
				// rod coutput
				translate([0, 0, bear_heigth+horizontalSuportThickness])
				cylinder(r=roughRod_diam/2, h=_zDir, center=false); 
			}

			//barebel holder support coutout
			translate([-(zEnd_rodsDist+bear_diam/2+genWallThickness), 0, _zDir])
			scale([_bearSuppCoutout_scale, 1, 1]) 
			rotate(a=90,v=X) 
				cylinder(r=_zDir- bear_heigth -genWallThickness, h=bear_diam+2*genWallThickness+2*OS, center=true); 

			// x dir rod
			difference() {
				translate([0, OS, roughRod_diam/2+genWallThickness]) 
				teardrop (r=roughRod_diam/2,h=_xDir+2*OS,top_and_bottom=false);

				cylinder(r=smoothRod_diam/2 + genWallThickness, h=_zDir, center=false);
			}
			

			//nuttrap
			translate([_xDir-zEnd_nuttrap_offset, 0, roughRod_diam/2+genWallThickness]) {
				rotate(a=90,v=Y) 
				rotate(a=30,v=Z) 
					cylinder(r=max(m8_nut_diameter/2 +1,roughRod_diam/2+genWallThickness)+OS, h=m8_nut_heigth, center=true);
			}
		}	
	}
}




if (mode == "inspect") {
	pRb_Z_end();
}
module pRb_endstop_print() {
	pRb_Z_end();
}
if (mode == "print") {
	pRb_Z_end();
}
