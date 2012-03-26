/* H-Y-BarEnd [Ybe]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original design by abdrumm for the PrintrBot
 */

include <config.scad>
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
Ybe_mode = "-"; 
//Ybe_mode = "printSet";  $fn=24*4;  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//Ybe_mode = "print";  $fn=24*4;  
//Ybe_mode = "inspect";
//Ybe_mode = "assembly";

Ybe_thinWallThickness          = 1;
Ybe_genWallThickness           = 2.5;
Ybe_strongWallThickness        = 7;

Ybe_horizontalSuportThickness  = 0.3;
Ybe_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
Ybe_smoothRod_diam                   = c_y_axis_smoothRod_diam;

/*------------------------------------BarEnd----------------------------------*/
Ybe_barEnd_yAxis_offset = c_y_axis_tabel_zDirOffset;
Ybe_barEnd_slot_width = 1.674;
Ybe_barEnd_heigth = 16;

Yeb_screwHolde_diam = m3_diameter;
Yeb_nut_diam = m3_nut_diameter;



/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ybe_screwHole_offset = Ybe_smoothRod_diam/2+Ybe_thinWallThickness+Yeb_screwHolde_diam/2;

_Ybe_con_size = [Ybe_smoothRod_diam/2+Ybe_genWallThickness+Yeb_screwHolde_diam+Ybe_strongWallThickness,Ybe_barEnd_yAxis_offset+Ybe_smoothRod_diam/2+Ybe_genWallThickness,Ybe_barEnd_heigth];
_Ybe_bb_rotAngle = atan(Ybe_barEnd_yAxis_offset/(_Ybe_con_size[0]/2));
_Ybe_bb_length = distance1D(Ybe_barEnd_yAxis_offset,_Ybe_con_size[0]/2);

_Ybe_angle = 10;

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
				cylinder(r=Yeb_screwHolde_diam/2, h=Ybe_barEnd_yAxis_offset*3, center=true);

			// nuttrap
			translate([_Ybe_screwHole_offset, -Ybe_smoothRod_diam/2- Ybe_genWallThickness-OS, Ybe_barEnd_heigth/2]) 
			rotate(a=-90,v=X) 
				cylinder(r=Yeb_nut_diam/2, h=m3_nut_heigth, center=false,$fn=6);

			//slot
			translate([-OS, -Ybe_barEnd_slot_width/2, -OS]) 
			cube(size=[_Ybe_con_size[0]+2*OS, Ybe_barEnd_slot_width, Ybe_barEnd_heigth+2*OS], center=false);

			// top coutoff
			translate([-OS, Ybe_barEnd_yAxis_offset, -OS]) 
				cube(size=_Ybe_con_size*2, center=false);

			// material coutout
			translate([_Ybe_con_size[0]/2, -Ybe_smoothRod_diam/2- Ybe_genWallThickness, -OS]) 
			difference() {
				translate([0, -OS, 0]) 
					cube(size=_Ybe_con_size+[0,2*OS,2*OS], center=false);
				translate([-(tan(10) * _Ybe_con_size[1]) , 0, 0]) 
				rotate(a=90-_Ybe_angle,v=Z) 
				linear_extrude(height=Ybe_barEnd_heigth+2*OS)
					barbell (r1=(Ybe_smoothRod_diam/2+Ybe_genWallThickness+Yeb_screwHolde_diam+Ybe_genWallThickness)/2,r2=_Ybe_con_size[0]/2,r3=_Ybe_con_size[1],r4=_Ybe_con_size[1]*1.5,separation=_Ybe_con_size[1]); 
			}
		}
	}

}




if (Ybe_mode == "inspect") {
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
if (Ybe_mode == "printSet") {
	H_Y_BarEnd_print();
}

if (Ybe_mode == "print") {
	H_Y_BarEnd();
}


/*------------------------------------assembly--------------------------------*/

module H_Y_BarEnd_left_assembly() {
	translate([0, Ybe_barEnd_heigth, 0]) 
	rotate(a=90,v=X) 
	H_Y_BarEnd();
}
module H_Y_BarEnd_right_assembly() {
	translate([0, Ybe_barEnd_heigth, 0]) 
	mirror([1, 0, 0])  
	rotate(a=90,v=X) 
	H_Y_BarEnd();
}

if (Ybe_mode == "assembly"){
	//H_Y_BarEnd_right_assembly();
	H_Y_BarEnd_left_assembly();
}



