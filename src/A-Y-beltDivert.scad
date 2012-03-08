/* A-Y-beltDivert [Ybd]
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

/*------------------------------------beltDivert------------------------------*/
beltDiv_xdirRods_dist = 60.901;
beldDiv_bearingDist = 31.134;

beltDiv_height = roughRod_diam+2*genWallThickness;


/*------------------------------------bearing---------------------------------*/
bear_height = 7;

bear_washer_height = 4;
bear_washer_diam = 12;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_bear_holder_diam = m8_nut_diameter + 2*genWallThickness;
_xdir_holder_size = [beltDiv_xdirRods_dist+roughRod_diam+genWallThickness*2,strongWallThickness,beltDiv_height];

module A_Y_beltDivert() {
	difference() {
		union(){ 
			translate([-beldDiv_bearingDist/2, 0, 0]) 
			linear_extrude(height=beltDiv_height)
				barbell (r1=_bear_holder_diam/2,r2=_bear_holder_diam/2,r3=beldDiv_bearingDist/2,r4=beldDiv_bearingDist/2,separation=beldDiv_bearingDist); 

			// bearing washer
			for (i=[-beldDiv_bearingDist/2,beldDiv_bearingDist/2]) 
			translate([i, 0, beltDiv_height])
				cylinder(r=bear_washer_diam/2, h=bear_washer_height, center=false); 

			// xdir rod holder
			translate([0, 0, _xdir_holder_size[2]/2]) 
			cube(size=_xdir_holder_size, center=true);
			// ends
			for (i=[-_xdir_holder_size[0]/2,_xdir_holder_size[0]/2]) 
			translate([i, 0, 0]) 
			scale([0.5, 1, 1]) 
				cylinder(r=_xdir_holder_size[1]/2, h=_xdir_holder_size[2], center=false);
		}
		union(){
			for (i=[-beldDiv_bearingDist/2,beldDiv_bearingDist/2]) 
			translate([i, 0, -OS]){
				// bearing washer
				translate([0, 0, m8_nut_heigth+horizontalSuportThickness]) 
				cylinder(r=roughRod_diam/2, h=beltDiv_height +  bear_washer_height +2*OS, center=false); 

				//nuttraps
				cylinder(r=m8_nut_diameter/2, h=m8_nut_heigth, center=false,$fn=6);
			}

			
			for (i=[-beltDiv_xdirRods_dist/2,beltDiv_xdirRods_dist/2]) {
				// x dir rods
				translate([i, 0, beltDiv_height/2]) 
				rotate(a=90,v=X) 
					cylinder(r=roughRod_diam/2, h=strongWallThickness+2*OS, center=true);
				// nut coutout
				for (y=[-_xdir_holder_size[1]/2-m8_nut_heigth/2,_xdir_holder_size[1]/2+m8_nut_heigth/2]) 
				translate([i, y, beltDiv_height/2]) 
				rotate(a=90,v=X) 
					cylinder(r=m8_nut_diameter/2+thinWallThickness, h=m8_nut_heigth, center=true);

			}

			
		}
	}

}




if (mode == "inspect") {
	A_Y_beltDivert();
}
module A_Y_beltDivert_print() {
	
}
if (mode == "print") {
	A_Y_beltDivert_print();
}


