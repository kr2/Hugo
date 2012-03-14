/* H-base [b]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original desing by abdrumm for the PrintrBot
 */
include <config.scad>

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
b_mode = "-";
//b_mode = "printSet";  $fn=24*4; // can be print or inspect [overlays the b_model with the original b_model] (uncomment next line)
//b_mode = "print Left"; $fn=24*4; 
//b_mode = "print right"; $fn=24*4; 
b_mode = "inspect";
//b_mode = "assembly";

b_thinWallThickness         = 1;
b_genWallThickness          = 2.5;
b_strongWallThickness       = 8;

b_horizontalSuportThickness = 0.3;
b_verticalSupportThickness  = 0.5;

/*------------------------------------rod-------------------------------------*/
b_smoothRod_diam            = 8.2;
b_roughRod_diam             = 8.5;

b_m8_nut_tolerance          = [2,1]; // diameter,height

/*------------------------------------zdir wall-------------------------------*/
b_zDirWall_size             = [9.4,77.9,58.986];

b_zDirSupport_r             = 6;

/*------------------------------------xdir wall-------------------------------*/
b_xDirWall_size             = [30.6,b_zDirWall_size[1],5.486];
b_xDirWall_roundedEdge_r    = 8;

/*------------------------------------motorHoles------------------------------*/
//z Motor
b_zdirM_hole_dist           = 31.2;
b_zdirM_hole_zAxisDist      = 5.35+7.95;

//y Motor
b_ydirM_hole_dist           = b_zdirM_hole_dist;
b_ydirM_hole_zAxisDist      = 25.35+7.951;

/*------------------------------------zdir Rod--------------------------------*/
b_zdirRod_hole_depth        = b_zDirWall_size[2]-10;

/*------------------------------------xdir Rods-------------------------------*/
b_xdirRods_holes_altitude   = [8.266,45.497];
b_xdirRods_holes_zAxisDist  = 38.95-8.5;

/*------------------------------------zip ties--------------------------------*/
b_zipTies_width             = 4;
b_zipTies_thickness         = 2;

/*------------------------------------linear bearings-------------------------*/
b_lber_length               = 24.2;
b_lber_diam                 = 15.3;
b_lber_topOff               = (b_lber_diam- b_smoothRod_diam)/2-0.5;
b_lber_zAxisDist            = b_xDirWall_size[1]/2- b_strongWallThickness- b_lber_length;
b_lber_zAxisXdirDist        = b_xDirWall_size[0]-b_genWallThickness- b_lber_diam/2 - b_zDirWall_size[0]/2 - b_zipTies_thickness;

/*------------------------------------air outlet------------------------------*/
b_airOut_diam = 3;

/*------------------------------------y dir motor-----------------------------*/
b_ydir_motorCoutout_diam     = 27.5; // diameter of the coutout around the motoraxis
b_ydir_motorHoles_diameter   = 3.2; // motor hole diameter
b_ydir_motorHoles_centerDist = 43.841/2; // distace of the motor holes from the motor axis center

/*------------------------------------z dir motor-----------------------------*/
b_zdir_motorCoutout_diam     = 27.5; // diameter of the coutout around the motoraxis
b_zdir_motorHoles_diameter   = 3.2; // motor hole diameter
b_zdir_motorHoles_centerDist = 43.841/2; // distace of the motor holes from the motor axis center


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_b_xdir_bb_r = m8_nut_diameter*0.75;
_b_xdirRods_holes_zdist = (b_xdirRods_holes_altitude[1]-b_xdirRods_holes_altitude[0]);

module  H_base(hasYMotorMount = true) {
	difference() {
		union(){
			translate([0, 0, b_zDirWall_size[2]-b_zdirRod_hole_depth- b_genWallThickness]) {
				// z axis
				cylinder(r=b_smoothRod_diam/2+b_genWallThickness, h=b_zdirRod_hole_depth+b_genWallThickness, center=false);
				// z axis rounded end 
				scale([1, 1, 0.5]) 
				sphere(r=b_smoothRod_diam/2+b_genWallThickness);
			}


			// xdir wall
			translate([-b_zDirWall_size[0]/2,-b_xDirWall_size[1]/2, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
			cube(size=b_xDirWall_size, center=false);

			//y dir bb
			for (z=b_xdirRods_holes_altitude) 
			translate([-b_zDirWall_size[0]/2,-b_xdirRods_holes_zAxisDist, z]) {
				rotate(a=90,v=Y) 
				linear_extrude(height=b_zDirWall_size[0])
				rotate(a=90,v=Z) 
					barbell (r1=_b_xdir_bb_r,r2=_b_xdir_bb_r,r3=(b_xdirRods_holes_zAxisDist*2)*1,r4=(b_xdirRods_holes_zAxisDist*2)*1,separation=(b_xdirRods_holes_zAxisDist*2));

				cube(size=[b_zDirWall_size[0], b_xdirRods_holes_zAxisDist*2, _b_xdir_bb_r*0.75], center=false);
			}

			//z dir bb
			for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist]) 
			translate([-b_zDirWall_size[0]/2,y, b_xdirRods_holes_altitude[0]]) 
			rotate(a=90,v=X) 
			rotate(a=90,v=Y) 
			linear_extrude(height=b_zDirWall_size[0])
			rotate(a=90,v=Z) 
				barbell (r1=_b_xdir_bb_r,r2=_b_xdir_bb_r,r3=(_b_xdirRods_holes_zdist*2)*0.35,r4=(_b_xdirRods_holes_zdist*2)*0.35,separation=_b_xdirRods_holes_zdist);

			//zMotor holder
			translate([-b_zdirM_hole_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
				_motorHolder(holeCenterDist = b_zdir_motorHoles_centerDist, holeDiam = b_zdir_motorHoles_diameter, coutoutDiam= b_zdir_motorCoutout_diam, connectorWidth2Holes = b_zdirM_hole_zAxisDist- b_zDirWall_size[0]/2);

			if (hasYMotorMount ) {
				//yMotor holder
				rotate(a=180,v=Z) 
				translate([-b_ydirM_hole_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
					_motorHolder(holeCenterDist = b_ydir_motorHoles_centerDist, holeDiam = b_ydir_motorHoles_diameter, coutoutDiam= b_ydir_motorCoutout_diam, connectorWidth2Holes = b_ydirM_hole_zAxisDist+ b_zDirWall_size[0]/2 -b_xDirWall_size[0]);
			}

			// zdir support
			translate([0,0, b_zDirWall_size[2]-b_xDirWall_size[2]]) {
				translate([b_zDirWall_size[0]/2,  -b_xdirRods_holes_zAxisDist, 0]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=b_zDirSupport_r,_l=b_xdirRods_holes_zAxisDist*2,_fn=4);

				translate([0, -b_smoothRod_diam/2, 0]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=b_xDirWall_size[0]-b_zDirWall_size[0]/2,_l=b_smoothRod_diam,_fn=4);
			}
		}
		union(){
			// z axis
			translate([0, 0, b_zDirWall_size[2]-b_zdirRod_hole_depth]) 
				cylinder(r=b_smoothRod_diam/2, h=b_zdirRod_hole_depth+OS, center=false);
			cylinder(r=b_airOut_diam/2, h= b_zDirWall_size[2]-b_zdirRod_hole_depth + OS, center=false);

			for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist])
			for (z=b_xdirRods_holes_altitude){
				//xdir hole coutput
				translate([-b_zDirWall_size[0]/2+OS, y, z]) 
				rotate(a=180,v=X) 
					teardrop (r=b_roughRod_diam/2,h=b_zDirWall_size[0]+2*OS,top_and_bottom=false);
					//cylinder(r=b_roughRod_diam/2, h=b_zDirWall_size[0]+2*OS, center=true); 
				//xdir holes nut save range
				for (x=[-(b_zDirWall_size[0]/2+m8_nut_heigth/2),b_zDirWall_size[0]/2+m8_nut_heigth/2]) 
				translate([x, y, z])
				rotate(a=90,v=Y) 
					cylinder(r=m8_nut_diameter/2+b_m8_nut_tolerance[0]/2, h=m8_nut_heigth+b_m8_nut_tolerance[1], center=true); 

				// top and bottom coutoff
				for (i=[-b_zDirWall_size[2]*1.5,b_zDirWall_size[2]+ b_zDirWall_size[2]*1.5]) 
				translate([0, 0, i]) 
					cube(size=[b_zDirWall_size[0]*25,b_zDirWall_size[1]*3,b_zDirWall_size[2]*3], center=true);
			} 

			//linear bearing coutout
			for (i=[b_lber_zAxisDist+b_lber_length/2,-b_lber_zAxisDist- b_lber_length/2])  
			translate([b_lber_zAxisXdirDist, i, b_zDirWall_size[2]-b_lber_topOff+ b_lber_diam/2]) {
				rotate(a=90,v=Z)
				rotate(a=180,v=X)	
				translate([-b_lber_length/2, 0, 0]) 		  
					teardrop (r=b_lber_diam/2,h=b_lber_length,top_and_bottom=false);
						//#cylinder(r=b_lber_diam/2, h=b_lber_length, center=true);


				//zip tie holes
				rotate(a=90,v=X) 
				difference() {
					cylinder(r=b_lber_diam/2+b_thinWallThickness+b_zipTies_thickness, h=b_zipTies_width, center=true);
					cylinder(r=b_lber_diam/2+b_thinWallThickness, h=b_zipTies_width+2*OS, center=true);
				}
			}

			// rounded edge
			for (i=[[b_xDirWall_size[1]/2,180],[-b_xDirWall_size[1]/2,90]]) 
			translate([b_xDirWall_size[0]-b_zDirWall_size[0]/2, i[0],b_zDirWall_size[2]-b_xDirWall_size[2]]) 
				roundEdge(_a=i[1],_r=b_xDirWall_roundedEdge_r,_l=b_xDirWall_size[2],_fn=100);
		}
	}
}


module _motorHolder(holeCenterDist = 43.841/2, holeDiam = 3.2, coutoutDiam= 26, connectorWidth2Holes = 10) {
	_motorCenter_off = cos(45)*holeCenterDist;
	_heigth = b_xDirWall_size[2];

	_centerBlock_ydir = cos(45) * coutoutDiam/2 * 2;

	_motorHoleSupport_r = holeCenterDist- coutoutDiam/2;

	_holeYOffset = sin(45) * holeCenterDist;
	difference() {
		union(){
			translate([-_motorCenter_off, 0,0]) { // motor center
				// motor holes support
				for (i=[-45,45]) 
				rotate(a=i,v=Z) 
				translate([holeCenterDist, 0,0])
					cylinder(r=_motorHoleSupport_r, h=_heigth, center=false);
			}

			// center block
			translate([0, 0, _heigth/2]) 
			cube(size=[(holeCenterDist- coutoutDiam/2)*2, _centerBlock_ydir, _heigth], center=true);
		
			// connector block
			translate([connectorWidth2Holes/2, 0, _heigth/2]) 
				cube(size=[ connectorWidth2Holes, _holeYOffset*2 + _motorHoleSupport_r*2,_heigth], center=true);

			// rounded Connectors
			for (i=[[-_holeYOffset-_motorHoleSupport_r,180],[_holeYOffset+_motorHoleSupport_r,90]]) 
			translate([connectorWidth2Holes, i[0], 0]) 
				roundEdge(_a=i[1],_r=connectorWidth2Holes,_l=_heigth,_fn=48*2);

		}
		union(){
			translate([-_motorCenter_off, 0, -OS]) { // motor center
				//center coutout
				cylinder(r=coutoutDiam/2, h=_heigth+2*OS, center=false);
				
				// motor holes
				for (i=[-45,45]) 
				rotate(a=i,v=Z) 
				translate([holeCenterDist, 0, 0])
					cylinder(r=holeDiam/2, h=_heigth+2*OS, center=false);
			}

			  
		}
	}
}
//!_motorHolder();

if (b_mode == "inspect") {
	 H_base();
}

/*------------------------------------print-----------------------------------*/

module H_base_print() {
	translate([-b_zdir_motorHoles_centerDist*0.875, b_zdirM_hole_dist/4, 0]) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
		H_base(hasYMotorMount = true);

	translate([b_zdir_motorHoles_centerDist*0.875, -b_zdirM_hole_dist/4, 0]) 
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
		H_base(hasYMotorMount = false);
}
if (b_mode == "printSet") {
	H_base_print();
}
if (b_mode == "print Left") {
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
	H_base(hasYMotorMount = true);
}
if (b_mode == "print right") {
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
	H_base(hasYMotorMount = false);
}



/*------------------------------------assembly--------------------------------*/
include <motors.scad>

module H_baseLeft_assembly() {
	H_base(hasYMotorMount = true);

	translate([-(b_zdirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);

	translate([(b_ydirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
}

module H_baseright_assembly() {
	rotate(a=180,v=Z) {
		H_base(hasYMotorMount = false);

		translate([-(b_zdirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
			stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
	}
}

if (b_mode == "assembly"){
	//H_baseLeft_assembly();
	H_baseright_assembly();
}

