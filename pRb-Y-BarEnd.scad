/* pRb-Y-BarEnd
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

thinWallThickness          = 1;
genWallThickness           = 2.5;
strongWallThickness        = 5;

horizontalSuportThickness  = 0.3;
verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
smoothRod_diam                   = 8.0;

/*------------------------------------BarEnd----------------------------------*/
barEnd_yAxis_offset = 14.321;
barEnd_slot_width = 1.674;
barEnd_heigth = 8;





/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_screwHole_offset = smoothRod_diam/2+thinWallThickness+m3_diameter/2;

_con_size = [smoothRod_diam/2+genWallThickness+m3_diameter/2+genWallThickness,barEnd_yAxis_offset+smoothRod_diam/2+genWallThickness,barEnd_heigth];
_bb_rotAngle = atan(barEnd_yAxis_offset/(_con_size[0]/2));
_bb_length = distance1D(barEnd_yAxis_offset,_con_size[0]/2);
module pRb_Y_BarEnd() {
	difference() {
		union(){
			cylinder(r=smoothRod_diam/2+genWallThickness, h=barEnd_heigth, center=false);

			//conector bloc
			translate([0, -smoothRod_diam/2- genWallThickness, 0]) 
			cube(size=_con_size, center=false);

			rotate(a=_bb_rotAngle,v=Z) 
			linear_extrude(height=barEnd_heigth)
				barbell (r1=smoothRod_diam/2+genWallThickness,r2=_con_size[0]/2,r3=_bb_length/2,r4=_bb_length/2,separation=_bb_length); 
		}
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=smoothRod_diam/2, h=barEnd_heigth+2*OS, center=false);

			//screw holde
			translate([_screwHole_offset, 0, barEnd_heigth/2]) 
			rotate(a=90,v=X) 
				cylinder(r=m3_diameter/2, h=barEnd_yAxis_offset*3, center=true);

			// nuttrap
			translate([_screwHole_offset, -smoothRod_diam/2- genWallThickness-OS, barEnd_heigth/2]) 
			rotate(a=-90,v=X) 
				cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);

			//slot
			translate([-OS, -barEnd_slot_width/2, -OS]) 
			cube(size=[_con_size[0]+2*OS, barEnd_slot_width, barEnd_heigth+2*OS], center=false);

			// top coutoff
			translate([-OS, barEnd_yAxis_offset, -OS]) 
				cube(size=_con_size*2, center=false);

			// material coutout
			translate([_con_size[0]/2, -smoothRod_diam/2- genWallThickness, -OS]) 
			difference() {
				cube(size=_con_size+[0,0,2*OS], center=false);
				rotate(a=90,v=Z) 
				linear_extrude(height=barEnd_heigth+2*OS)
					barbell (r1=_con_size[0]/2,r2=_con_size[0]/2,r3=_con_size[1],r4=_con_size[1]*1.5,separation=_con_size[1]); 
			}
		}
	}

}




if (mode == "inspect") {
	pRb_Y_BarEnd();
}
module pRb_Y_BarEnd_print() {
	for (i=[[-_con_size[1]/2-1,-smoothRod_diam/4],[_con_size[1]/2+1,smoothRod_diam/4]]) 
	translate([i[1], i[0], 0]) {
		translate([smoothRod_diam/2, -barEnd_yAxis_offset/2, 0]) 
		pRb_Y_BarEnd();
		translate([-smoothRod_diam/2, barEnd_yAxis_offset/2, 0]) 
		rotate(a=180,v=Z) 
		pRb_Y_BarEnd();
	}
}
if (mode == "print") {
	pRb_Y_BarEnd_print();
}


