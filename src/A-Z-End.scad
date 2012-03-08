/* pRb-Z-end
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
//$fn=48;

thinWallThickness         = 1;
genWallThickness           = 2.5;
strongWallThickness        = 9;

horizontalSuportThickness  = 0.3;
verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
smoothRod_diam                   = 8.0;
roughRod_diam                   = 8.5;

/*------------------------------------zEnd------------------------------------*/
zEnd_rodsDist = 28.315;
zEnd_heigt = 35;
zEnd_nuttrap_offset = 12;

/*------------------------------------bearing---------------------------------*/
bear_diam = 22.6;
bear_heigth = 7;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_zDir = zEnd_heigt;
_xDir = _zDir-(genWallThickness+smoothRod_diam/2);

_support_radius = (smoothRod_diam/2+genWallThickness)*0.6;
_support_coutout_r = circel_radius3Points([thinWallThickness,0],[_support_radius+thinWallThickness,_xDir],[_support_radius+thinWallThickness,-_xDir]);

_crosBr_bearing_dist = bear_diam/2+strongWallThickness+ m8_nut_diameter/2;
_crosBr_bearing_noseLength = _crosBr_bearing_dist + m8_nut_diameter/2+genWallThickness- strongWallThickness/2;

module pRb_Z_end(hasCrossBrace = true) {
	_bearSuppCoutout_scale = (zEnd_rodsDist+bear_diam/2+genWallThickness- smoothRod_diam/2 - genWallThickness/2)/(_zDir- bear_heigth -genWallThickness);
	_bearSuppCoutout_crosBrace_scale = (zEnd_rodsDist+bear_diam/2+genWallThickness- smoothRod_diam/2 - genWallThickness/2+_crosBr_bearing_noseLength)/(_zDir- m8_nut_diameter);
	
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
				difference() {
					rotate(a=90,v=X) 
						cylinder(r=_xDir, h=_support_radius*2, center=true);
					for (i=[1,-1]) 
					translate([0, i*(-_support_coutout_r- thinWallThickness), 0]) 
						sphere(r=_support_coutout_r,$fn=150); 
				}
				translate([0, -(roughRod_diam+2*genWallThickness)/2, 0]) 
					cube(size=[_xDir, roughRod_diam+2*genWallThickness, _xDir], center=false);
			}
			
			if (hasCrossBrace) {
				//connector
				translate([-zEnd_rodsDist, 0, 0]) 
				rotate(a=180,v=Z) 
				linear_extrude(height=_zDir)
					barbell (r1=bear_diam/2+genWallThickness,r2=strongWallThickness/2,r3=_crosBr_bearing_noseLength*.8,r4=_crosBr_bearing_noseLength*0.8,separation=_crosBr_bearing_noseLength); 

				//screw holde
				translate([-zEnd_rodsDist- _crosBr_bearing_dist, 0, m8_nut_diameter/2])
				rotate(a=90,v=X) 
					cylinder(r=m8_nut_diameter/2, h=strongWallThickness, center=true); 
			}

		}
		union(){
			translate([0, 0, genWallThickness]) 
				cylinder(r=smoothRod_diam/2, h=_zDir+2*OS, center=false);
			// bearing holder
			translate([-zEnd_rodsDist, 0, -OS]) {
				if (hasCrossBrace) {					
					cylinder(r=bear_diam/2, h=m8_nut_diameter, center=false);
				} else {
					cylinder(r=bear_diam/2, h=bear_heigth+OS, center=false);
				}
			// rod coutput
			translate([0, 0, bear_heigth+horizontalSuportThickness])
				cylinder(r=roughRod_diam/2, h=_zDir, center=false); 
			}

			//barebel holder support coutout
			if (hasCrossBrace) {
				translate([-(zEnd_rodsDist+bear_diam/2+genWallThickness+_crosBr_bearing_noseLength), 0, _zDir])
				scale([_bearSuppCoutout_crosBrace_scale, 1, 1]) 
				rotate(a=90,v=X) 
					cylinder(r=_zDir- m8_nut_diameter  , h=bear_diam+2*genWallThickness+2*OS, center=true); 
			} else {
				translate([-(zEnd_rodsDist+bear_diam/2+genWallThickness), 0, _zDir])
				scale([_bearSuppCoutout_scale, 1, 1]) 
				rotate(a=90,v=X) 
					cylinder(r=_zDir- bear_heigth -genWallThickness, h=bear_diam+2*genWallThickness+2*OS, center=true); 
			}

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

			if (hasCrossBrace) {
				//screw holde
				translate([-zEnd_rodsDist- _crosBr_bearing_dist, -strongWallThickness, m8_nut_diameter/2])
				rotate(a=90,v=Z)
				rotate(a=180,v=X) 
					teardrop (r=roughRod_diam/2,h=strongWallThickness*2+2*OS,top_and_bottom=false); 
					//cylinder(r=roughRod_diam/2, h=strongWallThickness*2+2*OS, center=true); 
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


module _triangle2hg(height,ground)
{
    polygon(points=[[-ground/2,0],[ground/2,0],[0,height]], paths=[[0,1,2]]);
}