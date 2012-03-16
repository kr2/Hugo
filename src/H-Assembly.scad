/* H-Assembly [a]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * contains derivative parts originally designed by abdrumm for the PrintrBot
 */

include <config.scad>
include <metric.scad>

include <H-Xtruder-Mount.scad>
include <H-X-End.scad>
include <H-X-Carriage.scad>
include <H-Y-BarEnd.scad>
include <H-Z-End.scad>
include <H-BarClampCross.scad>
include <H-Y-BeltDivert.scad>
include <H-Y-BeltClamp.scad>
include <H-EndstopHolder.scad>
include <H-Y-SupportFootEnd.scad>
include <H-BarClamp.scad>
include <H-Z-Coupling.scad>
include <H-Base.scad>

include <gregs-wade-v4.scad>

include <basicMetalParts.scad>


/*------------------------------------general---------------------------------*/
a_act_pos = [0,0,50]; // relative to the center of the axis exept z is relative to the top of the print plate


/*------------------------------------heated bed------------------------------*/
a_heatedBed_size = [215,215,1.6];
a_heatedBed_tabelOffset = 5;

/*------------------------------------tabel-----------------------------------*/
a_tabel_thickness = 5;

/******************************************************************************/ 
/*                                  internal                                  */
/******************************************************************************/


/*------------------------------------x axis----------------------------------*/
_a_xAxis_real_length = c_x_axis_length + 2*Xe_X_Rod_depth + Xm_outline[0];
_a_xEnd_xdirBearHole_offset = [_a_xAxis_real_length/2+Xe_Z_bearingHole_pos[1]-Xe_X_Rod_depth ,+Xe_Z_bearingHole_pos[0] -Xe_X_RodHoles_pos[0][0]]; //[x,y]
module _xAxis_assembly() {
	// axis
	for (i=[Xe_X_RodHoles_pos[0][1],Xe_X_RodHoles_pos[1][1]]) 
	translate([0, 0, i]) 
	rotate(a=90,v=Y) 
		rod(r=c_x_axis_smoothRod_diam/2, h=_a_xAxis_real_length, center=true,info="x axis rod");

	// xends
	*translate([_a_xEnd_xdirBearHole_offset[0], _a_xEnd_xdirBearHole_offset[1], 0]) 
		H_x_End_idle_assembly();
	*translate([-_a_xEnd_xdirBearHole_offset[0], _a_xEnd_xdirBearHole_offset[1], 0]) 
		H_x_End_motor_assembly();

	// x carriage
	translate([a_act_pos[0], 0, Xe_X_RodHoles_pos[1][1]]) 
		H_x_Carriage_assembly();

	// x extruder holder
	translate([a_act_pos[0], 0, Xe_X_RodHoles_pos[1][1]]) 
	translate([a_act_pos[0], -Xc_ydir/2-1, -Xc_axis_dist/2]) 
		H_Xtruder_mount_assembly();

	// extruder
	translate([0, -Xm_ext_hole_yoff, Xm_outline[2]/2]) 
	translate([a_act_pos[0], 0, Xe_X_RodHoles_pos[1][1]]) 
	translate([a_act_pos[0], -Xc_ydir/2-1, -Xc_axis_dist/2]) 
	rotate(a=180,v=Z) 
	gegsWade_assembly();

	// endstops
	translate([-c_x_axis_length/2, 0, Xe_X_RodHoles_pos[0][1]]) 
		H_endstop_xl_assembly();

	translate([c_x_axis_length/2, 0, Xe_X_RodHoles_pos[0][1]]) 
		H_endstop_xr_assembly();


	//belt
	color("white")
	translate([0, Xc_belt_axisXc_ydir_dist + c_xAxis_belt_width/2, Xe_X_RodHoles_pos[1][1]+ c_xAxis_beltTop_topxAxisDist + c_xAxis_belt_thickness/2]) 
		cube(size=[_a_xAxis_real_length, c_xAxis_belt_width, c_xAxis_belt_thickness], center=true);
}

/*------------------------------------y axis----------------------------------*/
_a_yAxis_real_length = c_y_axis_length + b_xDirWall_size[1] + Xc_ydir + Xm_ext_hole_yoff;
_a_yAxis_rod_topOffset = a_heatedBed_size[2] + a_heatedBed_tabelOffset + a_tabel_thickness + Ybe_barEnd_yAxis_offset;
_a_yAxis_dist = (_a_xEnd_xdirBearHole_offset[0]-b_lber_zAxisXdirDist)*2; // todo
module _yAxis_assembly() {
	//heated bed
	color("Crimson")
	translate([0, 0, -a_heatedBed_size[2]/2]) 
		cube(size=a_heatedBed_size, center=true);

	// table
	translate([0, 0, -(a_heatedBed_size[2] + a_heatedBed_tabelOffset + a_tabel_thickness/2)]) 
		table(size = [_a_yAxis_dist ,_a_yAxis_real_length ,a_tabel_thickness],center = true,info="main y table");

	// y axis
	for (i=[_a_yAxis_dist/2,-_a_yAxis_dist/2]) 
	translate([i, a_act_pos[1], -_a_yAxis_rod_topOffset]) 
	rotate(a=90,v=X) 
		rod(r=c_y_axis_smoothRod_diam/2, h=_a_yAxis_real_length, center=true, info="y Axis rod");

	// bar conector
	for (i=[_a_yAxis_real_length/2- Ybe_barEnd_heigth,-_a_yAxis_real_length/2]) {
		translate([_a_yAxis_dist/2, i, -_a_yAxis_rod_topOffset]) 
			H_Y_BarEnd_right_assembly();
		translate([-_a_yAxis_dist/2, i, -_a_yAxis_rod_topOffset]) 
			H_Y_BarEnd_left_assembly();
	}


	//beltclamps
	translate([0, 0, -(a_heatedBed_size[2]+a_heatedBed_tabelOffset+ a_tabel_thickness)]){
		translate([0, -_a_yAxis_real_length/2, 0]) 
			H_yBeltClampFront_assembly();
		translate([0, _a_yAxis_real_length/2, 0]) 
			H_yBeltClampBack_assembly();
	}


	// y belt
	color("white")
	translate([0, 0, -( a_heatedBed_size[2] + a_heatedBed_tabelOffset + a_tabel_thickness +  Ybc_belt_topOffset +3 +1)]) 
		cube(size=[c_yAxis_belt_thickness,  _a_yAxis_real_length, c_yAxis_belt_width], center=true);
}


/*------------------------------------z axis----------------------------------*/
_a_basement_tabelOffset = _a_yAxis_rod_topOffset +  b_zDirWall_size[2]-b_lber_topOff+ b_lber_diam/2;
_a_zAxis_smoothReal_length = c_z_axis_length+ b_zdirRod_hole_depth+ (_a_basement_tabelOffset-b_zDirWall_size[2]) + Ze_zEnd_heigt;
_a_zAxis_roughReal_length = c_z_axis_length+ (_a_basement_tabelOffset-b_zDirWall_size[2]) + Ze_zEnd_heigt - c_motorShaft_length;

_a_zAxis_xdir_crossBrace_overcut = 150; // todo 100 == cross brace
_a_zAxis_xdirRods_length = _a_xEnd_xdirBearHole_offset[0]*2 + b_zDirWall_size[0] + m8_nut_heigth*2 ; 

// crose brace
_a_xdir_roughRods_zdirDist = (_a_zAxis_smoothReal_length  +  b_zDirWall_size[2]-b_zdirRod_hole_depth);
_a_xdir_roughRod_delta = [_a_zAxis_xdir_crossBrace_overcut-(Ze_zEnd_rodsDist + _Ze_crosBr_bearing_dist),b_xdirRods_holes_zAxisDist*2+30]; //[x,y]
_a_zAxis_crossBrace_length = distance3D([0,0,0],[_a_xdir_roughRod_delta[0],_a_xdir_roughRod_delta[1], _a_xdir_roughRods_zdirDist ]);
_a_zAxis_crossBrace_angle = [atan(_a_xdir_roughRods_zdirDist/_a_xdir_roughRod_delta[0]),atan(_a_xdir_roughRods_zdirDist/_a_xdir_roughRod_delta[1])]; // [xdir,ydir]
//echo(str("cross brace angle [xdir,ydir] = ", _a_zAxis_crossBrace_angle));
module _zAxis_assembly() {
	translate([0, _a_xEnd_xdirBearHole_offset[1], -_a_basement_tabelOffset]){ 
		translate([-_a_xEnd_xdirBearHole_offset[0], 0, 0]) 
			H_baseLeft_assembly();
		translate([_a_xEnd_xdirBearHole_offset[0], 0, 0]) 
			H_baseright_assembly();

		// z Rods
		for (i=[-1,1]) {
			translate([i*_a_xEnd_xdirBearHole_offset[0], 0, b_zDirWall_size[2]-b_zdirRod_hole_depth]) 
				rod(r=c_z_axis_smoothRod_diam/2, h=_a_zAxis_smoothReal_length, center=false, info="Z direction rod");
			translate([i*(_a_xEnd_xdirBearHole_offset[0]+(Xe_Z_nutTrap_pos[1]-Xe_Z_bearingHole_pos[1])), 0, b_zDirWall_size[2] - b_xDirWall_size[2] + c_motorShaft_length]){ 
					threadedRod(r=4, h=_a_zAxis_roughReal_length, center=false,info="Z direction driver threaded rod ");
					H_Z_Coupling_assembly();
				}
		}

		// z ends
		translate([0, 0, _a_zAxis_smoothReal_length + (b_zDirWall_size[2]-b_zdirRod_hole_depth)]) {
			translate([-_a_xEnd_xdirBearHole_offset[0], 0, 0]) 
				H_Z_endLeft_assembly();
			translate([_a_xEnd_xdirBearHole_offset[0], 0, 0]) 
				H_Z_endright_assembly();

			rotate(a=90,v=Y) 
				threadedRod(r=4, h=_a_xEnd_xdirBearHole_offset[0]*2-(Ze_smoothRod_diam/2 + Ze_genWallThickness)*2-5, center=true,info="Top horizontal reinforcement in x direction");
		}

		// x dir rods
		for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist]){
			//translate([_a_zAxis_xdir_crossBrace_overcut/2+5, y, b_xdirRods_holes_altitude[0]]) 
			translate([0, y, b_xdirRods_holes_altitude[0]]) 
			rotate(a=90,v=Y) 
				threadedRod(r=4, h=_a_zAxis_xdirRods_length /*+ _a_zAxis_xdir_crossBrace_overcut+10*/ , center=true,info = "bottom rods in x direction ");
			translate([0, y, b_xdirRods_holes_altitude[1]]) 
			rotate(a=90,v=Y) 
				threadedRod(r=4, h=_a_zAxis_xdirRods_length, center=true, info = "bottom rods in x direction ");
		}

		// diverter
		translate([0, 0, b_xdirRods_holes_altitude[1]]) 
			H_Y_beltDivert_assembly();

		// z dir enstops
		translate([-_a_xEnd_xdirBearHole_offset[0], 0, b_zDirWall_size[2] + 10]) 
			H_endstop_zb_assembly();

		translate([-_a_xEnd_xdirBearHole_offset[0], 0, b_zDirWall_size[2]+ c_z_axis_length + 10]) 
			H_endstop_zt_assembly();

		// x dir enstops
		translate([-_a_yAxis_dist/2 + 15, -b_xdirRods_holes_zAxisDist, b_xdirRods_holes_altitude[1]]) 
			H_endstop_yf_assembly();
		translate([-_a_yAxis_dist/2 + 15, +b_xdirRods_holes_zAxisDist, b_xdirRods_holes_altitude[1]]) 
			H_endstop_yb_assembly();

		// y dir stabaliser
		for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist])
		translate([7.3, y, b_xdirRods_holes_altitude[0]]) 
		rotate(a=-90,v=Y) 
			barclamp();

		translate([0, 0, b_xdirRods_holes_altitude[0]+9]){ 
			rotate(a=90,v=X) 
				threadedRod(r=4, h=_a_yAxis_real_length/3*2, center=true, info = "bottom y dir support foot");

			for (i=[_a_yAxis_real_length/3-10,-_a_yAxis_real_length/3+10])
			translate([0, i, 0])  
			H_Y_supportFootEnd_assembly();
		}
	}

	// TODO
	*translate([_a_zAxis_xdirRods_length/2+_a_zAxis_xdir_crossBrace_overcut -10, _a_xEnd_xdirBearHole_offset[1], -_a_basement_tabelOffset]){
		// cross brace 
		translate([-9, -b_xdirRods_holes_zAxisDist-15, 0]) //todo
		rotate(a=-(90-_a_zAxis_crossBrace_angle[1]),v=X) 
		rotate(a=-(90-_a_zAxis_crossBrace_angle[0]),v=Y) 
			threadedRod(r=4, h=_a_zAxis_crossBrace_length+40, center=false, info = "right cross brace rod");

		translate([15, b_xdirRods_holes_zAxisDist+15, 0]) //todo
		rotate(a=(90-_a_zAxis_crossBrace_angle[1]),v=X) 
		rotate(a=-(90-_a_zAxis_crossBrace_angle[0]),v=Y) 
			threadedRod(r=4, h=_a_zAxis_crossBrace_length+40, center=false, info = "right cross brace rod");

		translate([0, -b_xdirRods_holes_zAxisDist, b_xdirRods_holes_altitude[0]]) 
		rotate(a=90,v=X) 
		rotate(a=-90,v=Y) 
		barclampCross(a=-(90-_a_zAxis_crossBrace_angle[0]));

		translate([0, b_xdirRods_holes_zAxisDist, b_xdirRods_holes_altitude[0]]) 
		rotate(a=90,v=X) 
		rotate(a=90,v=Y) 
		barclampCross(a=90-_a_zAxis_crossBrace_angle[0]);

		translate([0, 0,  _a_zAxis_smoothReal_length + (b_zDirWall_size[2]-b_zdirRod_hole_depth)]) {
			translate([-_a_xdir_roughRod_delta[1]-4, -b_xdirRods_holes_zAxisDist-4, 0]) 
			rotate(a=0,v=Y) 
			rotate(a=90,v=X) 
			barclampCross(a=-(90-_a_zAxis_crossBrace_angle[0]));

			translate([-_a_xdir_roughRod_delta[1]-4, b_xdirRods_holes_zAxisDist+  24+4, 0]) 
			rotate(a=180,v=Y) 
			rotate(a=90,v=X) 
			barclampCross(a=-(90-_a_zAxis_crossBrace_angle[0]));
		}
	}
}


module H_assembly() {
	translate([0, 0, a_act_pos[2]]) 
		_xAxis_assembly();

	*translate([0, a_act_pos[1], 0]) 
		_yAxis_assembly();
	
	*_zAxis_assembly();

	// basement
	color("Lavender")
	translate([0, 0, -_a_basement_tabelOffset-2.5]) 
		cube(size=[c_x_axis_length*2, c_y_axis_length*2, 5], center=true);

}

H_assembly();


