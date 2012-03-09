/* H-Y-BarEnd [Ybe]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original design by abdrumm for the PrintrBot
 */

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
mode = "-"; 
//mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";
//mode = "assembly";
$fn=48;

Ybe_thinWallThickness          = 1;
Ybe_genWallThickness           = 2.5;
Ybe_strongWallThickness        = 5;

Ybe_horizontalSuportThickness  = 0.3;
Ybe_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
Ybe_smoothRod_diam                   = 8.0;

/*------------------------------------BarEnd----------------------------------*/
Ybe_barEnd_yAxis_offset = 14.321;
Ybe_barEnd_slot_width = 1.674;
Ybe_barEnd_heigth = 8;





/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ybe_screwHole_offset = Ybe_smoothRod_diam/2+Ybe_thinWallThickness+m3_diameter/2;

_Ybe_con_size = [Ybe_smoothRod_diam/2+Ybe_genWallThickness+m3_diameter/2+Ybe_genWallThickness,Ybe_barEnd_yAxis_offset+Ybe_smoothRod_diam/2+Ybe_genWallThickness,Ybe_barEnd_heigth];
_Ybe_bb_rotAngle = atan(Ybe_barEnd_yAxis_offset/(_Ybe_con_size[0]/2));
_Ybe_bb_length = distance1D(Ybe_barEnd_yAxis_offset,_Ybe_con_size[0]/2);

module H_Y_BarEnd() {
	difference() {
		union(){
			cylinder(r=Ybe_smoothRod_diam/2+Ybe_genWallThickness, h=Ybe_barEnd_heigth, center=false);

			//conector bloc
			translate([0, -Ybe_smoothRod_diam/2- Ybe_genWallThickness, 0]) 
			cube(size=_Ybe_con_size, center=false);

			rotate(a=_Ybe_bb_rotAngle,v=Z) 
			linear_extrude(height=Ybe_barEnd_heigth)
				barbell (r1=Ybe_smoothRod_diam/2+Ybe_genWallThickness,r2=_Ybe_con_size[0]/2,r3=_Ybe_bb_length/2,r4=_Ybe_bb_length/2,separation=_Ybe_bb_length); 
		}
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=Ybe_smoothRod_diam/2, h=Ybe_barEnd_heigth+2*OS, center=false);

			//screw holde
			translate([_Ybe_screwHole_offset, 0, Ybe_barEnd_heigth/2]) 
			rotate(a=90,v=X) 
				cylinder(r=m3_diameter/2, h=Ybe_barEnd_yAxis_offset*3, center=true);

			// nuttrap
			translate([_Ybe_screwHole_offset, -Ybe_smoothRod_diam/2- Ybe_genWallThickness-OS, Ybe_barEnd_heigth/2]) 
			rotate(a=-90,v=X) 
				cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);

			//slot
			translate([-OS, -Ybe_barEnd_slot_width/2, -OS]) 
			cube(size=[_Ybe_con_size[0]+2*OS, Ybe_barEnd_slot_width, Ybe_barEnd_heigth+2*OS], center=false);

			// top coutoff
			translate([-OS, Ybe_barEnd_yAxis_offset, -OS]) 
				cube(size=_Ybe_con_size*2, center=false);

			// material coutout
			translate([_Ybe_con_size[0]/2, -Ybe_smoothRod_diam/2- Ybe_genWallThickness, -OS]) 
			difference() {
				cube(size=_Ybe_con_size+[0,0,2*OS], center=false);
				rotate(a=90,v=Z) 
				linear_extrude(height=Ybe_barEnd_heigth+2*OS)
					barbell (r1=_Ybe_con_size[0]/2,r2=_Ybe_con_size[0]/2,r3=_Ybe_con_size[1],r4=_Ybe_con_size[1]*1.5,separation=_Ybe_con_size[1]); 
			}
		}
	}

}




if (mode == "inspect") {
	H_Y_BarEnd();
}
module H_Y_BarEnd_print() {
	for (i=[[-_Ybe_con_size[1]/2-1,-Ybe_smoothRod_diam/4],[_Ybe_con_size[1]/2+1,Ybe_smoothRod_diam/4]]) 
	translate([i[1], i[0], 0]) {
		translate([Ybe_smoothRod_diam/2, -Ybe_barEnd_yAxis_offset/2, 0]) 
		H_Y_BarEnd();
		translate([-Ybe_smoothRod_diam/2, Ybe_barEnd_yAxis_offset/2, 0]) 
		rotate(a=180,v=Z) 
		H_Y_BarEnd();
	}
}
if (mode == "print") {
	H_Y_BarEnd_print();
}


/*------------------------------------assembly--------------------------------*/

module H_Y_BarEnd_left_assembly() {
	translate([0, Ybe_barEnd_heigth, 0]) 
	rotate(a=90,v=X) 
	H_Y_BarEnd();
}
module H_Y_BarEnd_reight_assembly() {
	translate([0, Ybe_barEnd_heigth, 0]) 
	mirror([1, 0, 0])  
	rotate(a=90,v=X) 
	H_Y_BarEnd();
}

if (mode == "assembly"){
	//H_Y_BarEnd_reight_assembly();
	H_Y_BarEnd_left_assembly();
}



