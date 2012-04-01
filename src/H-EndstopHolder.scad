/* H-EndstopHolder [eh]
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
include <config.scad>


/*------------------------------------general---------------------------------*/
eh_mode = "-";
//eh_mode = "printSet1";  $fn=24*4;
//eh_mode = "printSet2";  $fn=24*4;
eh_mode = "inspect";
//eh_mode = "assembly";

eh_genWallThickness           = 2.5;
eh_strongWallThickness        = 5;

eh_horizontalSuportThickness  = 0.3;
eh_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
//rod_diam                   = 8.5;

/*------------------------------------enstop----------------------------------*/
eh_end_height                 = 9;
eh_end_wallWidth              = 4;

eh_end_slotDepth              = 20.5;
eh_end_clampHole_offset       = 15;
eh_end_elongetatedHole_length = 10;
eh_end_addLengthHole          = 5.5 + eh_end_elongetatedHole_length;
eh_end_edgeRadius             = 10; // availiable ony if perpendicular
eh_end_holeSeperator_width    = 1.35; 

/*------------------------------------K----------------------------*/

eh_holeOffsets = [
					[-34,14,5], // z bottom  nuttraps = [-1,1]
					[-15,14,5], // z top  nuttraps = [-1,1]

					[-7,14,5], // y front/back  nuttraps = [-1,0]

					[-9,19,5] // x left/reight nuttraps = [-1,1]
				];


// holeOffset is the distance form the center of the axis in the clamp to the center the hole
// nuttraps [clamp, switch connector]  0: off, -1 one side 1 other side
module H_endstop_holder(rod_diam=8,isPerpendicular= 1, holeOffset = [-7,14,5], nuttraps = [-1,1]) {
	_end_edgeRadius = min(eh_end_edgeRadius,(holeOffset[1]-3*eh_genWallThickness));
	difference() {
		union(){	
			rotate(a=180,v=Z) 
				_clamp(holeOffset=holeOffset, nuttrap = nuttraps[0],rod_diam=rod_diam);

			if (isPerpendicular == 0) {
				translate([-eh_end_wallWidth/2, rod_diam/2, 0]) 
					cube(size=[eh_end_wallWidth, holeOffset[1]-rod_diam/2+eh_end_addLengthHole, eh_end_height], center=false);
			}else{
				// normal side
				translate([-eh_end_wallWidth/2, rod_diam/2, 0]) 
					cube(size=[eh_end_wallWidth, holeOffset[1]-rod_diam/2+eh_end_wallWidth/2, eh_end_height], center=false);
				// Perpendicular sied
				if (holeOffset[0]>0) {
					translate([0, holeOffset[1]-eh_end_wallWidth/2, ])
						cube(size=[holeOffset[0]+eh_end_addLengthHole, eh_end_wallWidth, eh_end_height], center=false); 
				}else{
					translate([holeOffset[0]-eh_end_addLengthHole, holeOffset[1]-eh_end_wallWidth/2, ])
						cube(size=[abs(holeOffset[0])+eh_end_addLengthHole, eh_end_wallWidth, eh_end_height], center=false); 
				}
				
			}

			// nuttrap outline
			if (nuttraps[1]!= 0) {
				for (i=[0:m3_nut_diameter/2:eh_end_elongetatedHole_length]) 
				translate([holeOffset[0]+i*holeOffset[0]/abs(holeOffset[0]), holeOffset[1], eh_end_height/2]) 
				rotate(a=90*isPerpendicular,v=Z)
				rotate(a=-90,v=Y)
				translate([0, 0, eh_end_wallWidth/2*nuttraps[1]]) 
				rotate(a=30,v=Z) 
					cylinder(r=(eh_end_height/2)/cos(30), h=m2_nut_heigth+OS, center=true,$fn=6);
			}

			//rounded edge
			if (isPerpendicular != 0) {
				if (holeOffset[0]>0) {
					translate([eh_end_wallWidth/2, holeOffset[1]-eh_end_wallWidth/2, 0]) 
						roundEdge(_a=-90,_r=_end_edgeRadius- eh_end_wallWidth/2,_l=eh_end_height,_fn=48);
				}else{
					translate([-eh_end_wallWidth/2, holeOffset[1]-eh_end_wallWidth/2, 0]) 
						roundEdge(_a=180,_r=_end_edgeRadius- eh_end_wallWidth/2,_l=eh_end_height,_fn=48);
				}
			}
			
		}
		union(){
			// switch screw hole and nuttrap
			translate([holeOffset[0], holeOffset[1], eh_end_height/2]) 
			rotate(a=90*isPerpendicular,v=Z)
			rotate(a=-90,v=Y){
				difference() {
					union() {
						for (i=[0,eh_end_elongetatedHole_length]) 
						translate([0, -i*holeOffset[0]/abs(holeOffset[0]), 0 ]) 
							cylinder(r=m2_diameter/2, h=eh_end_wallWidth+2*OS, center=true,$fn=24);
						translate([0, eh_end_elongetatedHole_length/2 * holeOffset[0]/abs(holeOffset[0])*-1 -OS,0]) 
							cube(size=[  m2_diameter, eh_end_elongetatedHole_length, eh_end_wallWidth+2*OS], center=true);
					}
					union(){
						translate([0, eh_end_elongetatedHole_length/2 * holeOffset[0]/abs(holeOffset[0])*-1, -OS]) 
						for (i=[m2_diameter:m2_diameter*2:eh_end_elongetatedHole_length/2]) {
							translate([0, i * holeOffset[0]/abs(holeOffset[0])*-1, 0]) 
								cube(size=[  m2_diameter, eh_end_holeSeperator_width, eh_end_wallWidth+2*OS], center=true);
							
							translate([0, -i * holeOffset[0]/abs(holeOffset[0])*-1, 0]) 
								cube(size=[  m2_diameter, eh_end_holeSeperator_width, eh_end_wallWidth+2*OS], center=true);
						}
					}
				}
				
				if (nuttraps[1]!= 0) {
					for (i=[0:m2_nut_diameter/2:eh_end_elongetatedHole_length]) 
					translate([0, -i*holeOffset[0]/abs(holeOffset[0]), (eh_end_wallWidth/2+OS)*nuttraps[1] ]) 
					rotate(a=30,v=Z) 
						cylinder(r=m2_nut_diameter/2, h=m2_nut_heigth+OS, center=true,$fn=6);
				}	
			}

			if (isPerpendicular != 0) {
				if (holeOffset[0]>0) {
					translate([-eh_end_wallWidth/2, holeOffset[1]+eh_end_wallWidth/2, 0]) 
						roundEdge(_a=-90,_r=_end_edgeRadius+eh_end_wallWidth/2,_l=eh_end_height,_fn=48);
				}else{
					difference() {
						translate([eh_end_wallWidth/2, holeOffset[1]+eh_end_wallWidth/2, 0]) 
							roundEdge(_a=180,_r=_end_edgeRadius+ eh_end_wallWidth/2,_l=eh_end_height,_fn=48);
						rotate(a=180,v=Z) 
							_clamp(holeOffset=holeOffset, nuttrap = nuttraps[0],rod_diam=rod_diam);
					}
				}
			}
		}
	}

}

module _clamp(holeOffset,nuttrap,rod_diam) {
	end_slotWidth = rod_diam*0.7;

	difference() {
		union(){
			cylinder(r=rod_diam/2+eh_end_wallWidth, h=eh_end_height, center=false);
			// slot outline
			translate([-(end_slotWidth+2*eh_end_wallWidth)/2, 0, 0]) 
			cube(size=[end_slotWidth+2*eh_end_wallWidth, eh_end_slotDepth, eh_end_height], center=false);

			//nuttrap
			if (nuttrap != 0) {
				translate([0, eh_end_clampHole_offset, eh_end_height/2]) { // center screw hole
					translate([nuttrap * ((end_slotWidth)/2+eh_end_wallWidth), 0, 0]) 
					rotate(a=90,v=Y) 
					rotate(a=30,v=Z) 
						cylinder(r=(eh_end_height/2)/cos(30), h=m3_nut_heigth, center=true,$fn=6);
				}
			}
			

			// connector

			*linear_extrude(height=eh_end_height)
			rotate(a=-90,v=Z) 
				barbell(r1=(rod_diam+2*eh_end_wallWidth)/2,r2=eh_end_wallWidth/2,r3=eh_end_wallWidth*4,r4=eh_end_wallWidth*4,separation=min(eh_end_edgeRadius,holeOffset[1]-3*eh_genWallThickness));
		}
		union(){
			// rod coutout
			translate([0, 0, -OS]) 
			cylinder(r=rod_diam/2, h=eh_end_height+2*OS, center=false);
			// slot coutout
			translate([-end_slotWidth/2, 0, -OS]) 
			cube(size=[end_slotWidth, eh_end_slotDepth+OS, eh_end_height+2*OS], center=false);

			
			translate([0, eh_end_clampHole_offset, eh_end_height/2]) { // center screw hole
				// clamp hole
				rotate(a=90,v=Y) 
					cylinder(r=m3_diameter/2, h=end_slotWidth+2*eh_end_wallWidth+2*OS, center=true,$fn=24);
				if (nuttrap != 0) {
					// nuttrap
					translate([nuttrap * ((end_slotWidth)/2+eh_end_wallWidth), 0, 0]) 
					rotate(a=90,v=Y) 
					rotate(a=30,v=Z) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth+2*OS, center=true,$fn=6);
				}
			}
		}
	}
}
//_clamp();




if (eh_mode == "inspect") {
	H_endstop_holder();
}
if (eh_mode == "print") {
	H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]);
}
module H_endstop_printSet1() {

	translate([40, 20, 0]) 
	H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]); // z bottom

	translate([20, 10, 0]) 
	H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[1], nuttraps = [-1,1]); // z top

	H_endstop_holder(rod_diam=c_y_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[2], nuttraps = [-1,0]); // y front/back
	
	translate([-40, 25, 0]) 
	rotate(a=90,v=[0,0,1]) 
	H_endstop_holder(rod_diam=c_y_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[2], nuttraps = [-1,0]); // y front/back
	
	translate([-20, -10, 0]) 
	H_endstop_holder(rod_diam=c_x_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[3], nuttraps = [-1,1]); // x left/reight

	translate([-40, -20, 0]) 
	H_endstop_holder(rod_diam=c_x_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[3], nuttraps = [-1,1]); // x left/reight

}
if (eh_mode == "printSet1") {
	H_endstop_printSet1();
}

module H_endstop_printSet2() {

	translate([20, 10, 0]) 
	H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]); // z bottom

	H_endstop_holder(rod_diam=c_y_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[2], nuttraps = [-1,0]); // y front/back
		
	translate([-20, -10, 0]) 
	H_endstop_holder(rod_diam=c_x_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[3], nuttraps = [-1,1]); // x left/reight

}
if (eh_mode == "printSet2") {
	H_endstop_printSet2();
}


/*------------------------------------assembly--------------------------------*/
include <RapSwitch.scad>

//switchSize[2]
module H_endstop_zb_assembly() {
	translate([eh_holeOffsets[0][0] - eh_end_elongetatedHole_length/2,-eh_holeOffsets[0][1] -switchSize[2]- eh_end_wallWidth/2, eh_end_height/2]) 
	rotate(a=90,v=X) 
	rotate(a=180,v=Y) 
		rapSwitch_ass();

	mirror([0, 1, 0])  
		H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[0], nuttraps = [-1,1]);
}
//!H_endstop_zb_assembly();

module H_endstop_zt_assembly() {
	translate([eh_holeOffsets[1][0] - eh_end_elongetatedHole_length/2,-eh_holeOffsets[1][1] -switchSize[2]- eh_end_wallWidth/2, eh_end_height/2]) 
	mirror([0, 0, 1])  
	rotate(a=90,v=X) 
	rotate(a=180,v=Y) 
		rapSwitch_ass();

	mirror([0, 1, 0])  
	H_endstop_holder(rod_diam=c_z_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[1], nuttraps = [-1,1]);
}
//! H_endstop_zt_assembly();

module H_endstop_yf_assembly() {
	translate([eh_end_height/2, eh_holeOffsets[2][0] -eh_end_elongetatedHole_length/2, eh_holeOffsets[2][1] +eh_end_wallWidth/2]) 
	rotate(a=180,v=Z) 
		rapSwitch_ass();

	rotate(a=90,v=X) 
	rotate(a=90,v=Y) 
		H_endstop_holder(rod_diam=c_y_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[2], nuttraps = [-1,0]);
}
//!H_endstop_yf_assembly();

module H_endstop_yb_assembly() {
	mirror([0, 1, 0])  {
	 	H_endstop_yf_assembly();
	}
}
//!H_endstop_yb_assembly();

module H_endstop_xl_assembly() {
	translate([eh_end_height/2,  switchSize[2] + eh_holeOffsets[3][1] +eh_end_wallWidth/2,  abs(eh_holeOffsets[3][0]) +eh_end_elongetatedHole_length/2 ]) 
	mirror([0, 0, 1])  
	rotate(a=90,v=Y) 
	rotate(a=90,v=X) 
	rapSwitch_ass();

	rotate(a=90,v=Y) 
		H_endstop_holder(rod_diam=c_x_axis_smoothRod_diam,isPerpendicular= 1, holeOffset = eh_holeOffsets[3], nuttraps = [-1,1]);
}
//!H_endstop_xl_assembly();

module H_endstop_xr_assembly() {
	mirror([1, 0, 0]) 
	H_endstop_xl_assembly(); 
}
//!H_endstop_xr_assembly();

if (eh_mode == "assembly"){
	//H_baseLeft_assembly();
	H_endstop_xl_assembly();
}
