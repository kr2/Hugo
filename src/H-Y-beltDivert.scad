/* H-Y-BeltDivert [Ybd]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
Ybd_mode = "-";  
//Ybd_mode = "print";  $fn=24*4;  // can be print or inspect [overlays the Ybd_model with the original Ybd_model] (uncomment next line)
//Ybd_mode = "inspect";
//Ybd_mode = "assembly";

Ybd_thinWallThickness          = 0.9;
Ybd_genWallThickness           = 2.5;
Ybd_strongWallThickness        = 10;

Ybd_horizontalSuportThickness  = 0.3;
Ybd_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
Ybd_roughRod_diam                   = 8.5;

/*------------------------------------beltDivert------------------------------*/
Ybd_beltDiv_xdirRods_dist = 60.901;
Ybd_beldDiv_bearingDist = 31.134+2;

Ybd_beltDiv_height = Ybd_roughRod_diam+2*Ybd_genWallThickness;


/*------------------------------------bearing---------------------------------*/
Ybd_bear_height = 7;

Ybd_bear_washer_height = 4;
Ybd_bear_washer_diam = 12;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ybd_bear_holder_diam = m8_nut_diameter + 2*Ybd_genWallThickness;
_Ybd_xdir_holder_size = [Ybd_beltDiv_xdirRods_dist+Ybd_roughRod_diam+Ybd_genWallThickness*2,Ybd_strongWallThickness,Ybd_beltDiv_height];

module H_Y_beltDivert() {
	difference() {
		union(){ 
			translate([-Ybd_beldDiv_bearingDist/2, 0, 0]) 
			linear_extrude(height=Ybd_beltDiv_height)
				barbell (r1=_Ybd_bear_holder_diam/2,r2=_Ybd_bear_holder_diam/2,r3=Ybd_beldDiv_bearingDist/2,r4=Ybd_beldDiv_bearingDist/2,separation=Ybd_beldDiv_bearingDist); 

			// bearing washer
			for (i=[-Ybd_beldDiv_bearingDist/2,Ybd_beldDiv_bearingDist/2]) 
			translate([i, 0, Ybd_beltDiv_height])
				cylinder(r=Ybd_bear_washer_diam/2, h=Ybd_bear_washer_height, center=false); 

			// xdir rod holder
			translate([0, 0, _Ybd_xdir_holder_size[2]/2]) 
			cube(size=_Ybd_xdir_holder_size, center=true);
			// ends
			for (i=[-_Ybd_xdir_holder_size[0]/2,_Ybd_xdir_holder_size[0]/2]) 
			translate([i, 0, 0]) 
			scale([0.5, 1, 1]) 
				cylinder(r=_Ybd_xdir_holder_size[1]/2, h=_Ybd_xdir_holder_size[2], center=false);
		}
		union(){
			for (i=[-Ybd_beldDiv_bearingDist/2,Ybd_beldDiv_bearingDist/2]) 
			translate([i, 0, -OS]){
				// bearing washer
				translate([0, 0, m8_nut_heigth+Ybd_horizontalSuportThickness]) 
				cylinder(r=Ybd_roughRod_diam/2, h=Ybd_beltDiv_height +  Ybd_bear_washer_height +2*OS, center=false); 

				//nuttraps
				cylinder(r=m8_nut_diameter/2, h=m8_nut_heigth, center=false,$fn=6);
			}

			
			for (i=[-Ybd_beltDiv_xdirRods_dist/2,Ybd_beltDiv_xdirRods_dist/2]) {
				// x dir rods
				translate([i, 0, Ybd_beltDiv_height/2]) 
				rotate(a=90,v=X) 
					cylinder(r=Ybd_roughRod_diam/2, h=Ybd_strongWallThickness+2*OS, center=true);
				// nut coutout
				for (y=[-_Ybd_xdir_holder_size[1]/2-m8_nut_heigth/2,_Ybd_xdir_holder_size[1]/2+m8_nut_heigth/2]) 
				translate([i, y, Ybd_beltDiv_height/2]) 
				rotate(a=90,v=X) 
					cylinder(r=m8_nut_diameter/2+Ybd_thinWallThickness, h=m8_nut_heigth, center=true);

			}

			
		}
	}

}




if (Ybd_mode == "inspect") {
	H_Y_beltDivert();
}
module H_Y_beltDivert_print() {
	H_Y_beltDivert();
}
if (Ybd_mode == "print") {
	H_Y_beltDivert_print();
}




/*------------------------------------assembly--------------------------------*/
include <BearingGuide.scad>


module H_Y_beltDivert_assembly() {
	translate([-22.2/2-0.5, 0, -Ybd_beltDiv_height/2]) 
	rotate(a=90,v=Z){ 
		H_Y_beltDivert();

		for (i=[-Ybd_beldDiv_bearingDist/2,Ybd_beldDiv_bearingDist/2])
		translate([i, 0, Ybd_beltDiv_height+2])  
			bearGuid_ass();
	}
}

if (Ybd_mode == "assembly"){
	H_Y_beltDivert_assembly();
}