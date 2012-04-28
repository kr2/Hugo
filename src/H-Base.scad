/* H-Base [b]
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
//b_mode = "print left"; $fn=24*4;
//b_mode = "print right"; $fn=24*4;
//b_mode = "inspect";
//b_mode = "assembly";

b_thinWallThickness           = 1;
b_genWallThickness            = 2.5;
b_strongWallThickness         = 8;

b_horizontalSuportThickness   = 0.5;
b_verticalSupportThickness    = 0.5;

/*------------------------------------rod-------------------------------------*/
b_smoothRod_diam              = c_z_axis_smoothRod_diam;
b_roughRod_diam               = m8_diameter;

b_m8_nut_heigth               = m8_nut_heigth;
b_m8_nut_tolerance            = [2,1]; // diameter,height

/*------------------------------------xdir Rods-------------------------------*/
b_xdirRods_holes_altitude     = c_xDirSupp_thredRod_altitude;
b_xdirRods_holes_zAxisDist    = c_xDirSupp_thredRod_zAxisDist;

/*------------------------------------zip ties--------------------------------*/
b_zipTies_width               = 5;
b_zipTies_thickness           = 2.5;

/*------------------------------------air outlet------------------------------*/
b_airOut_diam                 = 3;

/*------------------------------------y dir motor-----------------------------*/
b_ydir_motorCoutout_diam      = c_yAxis_motorPilot_diam; // diameter of the coutout around the motoraxis
b_ydir_motorHoles_diameter    = c_yAxis_motorScrewHole_diam  ; // motor hole diameter
b_ydir_motorHoles_centerDist  = c_yAxis_motorScrewHoles_centerDist; // distace of the motor holes from the motor axis center
b_ydirM_motorAxis_zAxisDist   = 25.35+2.5 + cos(45)*b_ydir_motorHoles_centerDist;
b_ydirM_sideLength            = c_yAxis_motor_sideLength;

/*------------------------------------z dir motor-----------------------------*/
b_zdir_motorCoutout_diam      = c_zAxis_motorPilot_diam; // diameter of the coutout around the motoraxis
b_zdir_motorHoles_diameter    = c_zAxis_motorScrewHole_diam; // motor hole diameter
b_zdir_motorHoles_centerDist  = c_zAxis_motorScrewHoles_centerDist; // distace of the motor holes from the motor axis center
b_zdirM_motorAxis_zAxisDist   = c_z_axis_rodsDist;
b_zdirM_sideLength            = c_zAxis_motor_sideLength;

/*------------------------------------zdir wall-------------------------------*/
b_zDirWall_size               = [9.4,77.9,58.986];
b_zDirSupport_r               = b_m8_nut_heigth*2.2 - b_m8_nut_tolerance[1] ;

/*------------------------------------xdir wall-------------------------------*/
b_xDirWall_size               = [30.6,b_zDirWall_size[1],6];
b_xDirWall_roundedEdge_r      = 6.5;

/*------------------------------------zdir Rod--------------------------------*/
b_zdirRod_hole_depth          = b_zDirWall_size[2]-8.5;

/*------------------------------------linear bearings-------------------------*/
b_lber_length                 = c_yAxis_lber_length + 0.2; //+ 0.2 to conteract print errors
b_lber_diam                   = c_yAxis_lber_diam;
b_lber_topOff                 = (b_lber_diam- c_y_axis_smoothRod_diam)/2 - 0.5;
b_lber_zAxisDist              = b_xDirWall_size[1]/2- 1.5- b_lber_length;
b_lber_zAxisXdirDist          = b_xDirWall_size[0]-b_genWallThickness- b_lber_diam/2 - b_zDirWall_size[0]/2 - b_zipTies_thickness;

/*------------------------------------EndstopHolder---------------------------*/
b_elongetatedHole_length      = 14;
b_elongetatedHole_diam        = m2d5_diameter;
b_elongetatedHole_NutDiam     = m2d5_nut_diameter;
b_elongetatedHole_NutHeight   = m2d5_nut_heigth;
b_elongetatedHole_NutWallDist = m2d5_nut_wallDist;

/*------------------------------------motor calibration screws----------------*/
b_mc_hole_diam                = m3_diameter;
b_mc_nut_diam                 = m3_nut_diameter;
b_mc_nut_walldist             = m3_nut_wallDist;
b_mc_nut_height               = m3_nut_heigth * 1.5; // for self fix nuts

/******************************************************************************/
/*                                  INTERNAL                                  */
/******************************************************************************/
b_zdirM_hole_zAxisDist      = b_zdirM_motorAxis_zAxisDist - cos(45)*b_zdir_motorHoles_centerDist;  // dist of the holes not the motor axsis
b_ydirM_hole_zAxisDist      = b_ydirM_motorAxis_zAxisDist - cos(45)*b_ydir_motorHoles_centerDist;  // dist of the holes not the motor axsis


_b_xdir_bb_r = m8_nut_diameter*0.8;
_b_xdirRods_holes_zdist = (b_xdirRods_holes_altitude[1]-b_xdirRods_holes_altitude[0]);

_b_zdirM_supportThickness = b_zdirM_motorAxis_zAxisDist-(b_zdirM_sideLength/2+b_smoothRod_diam/2+ b_genWallThickness);


_b_SaveRange_height = max(b_zDirSupport_r, b_m8_nut_heigth+b_m8_nut_tolerance[1]) +b_verticalSupportThickness;

_b_bigMotorMount_r = b_ydir_motorHoles_centerDist - b_zdir_motorCoutout_diam/2;

module  H_base(hasYMotorMount = true, hasEnstopHolder = false) {
	difference() {
		union(){
			translate([0, 0, b_zDirWall_size[2]-b_zdirRod_hole_depth- b_genWallThickness]) {
				// z axis
				cylinder(r=b_smoothRod_diam/2+b_genWallThickness, h=b_zdirRod_hole_depth+b_genWallThickness, center=false);


				// z axis rounded end
				scale([1, 1, 0.5])
					sphere(r=b_smoothRod_diam/2+b_genWallThickness);

				translate([-b_smoothRod_diam/2- b_genWallThickness, 0, _b_zdirM_supportThickness]){
					cylinder(r=_b_zdirM_supportThickness, h=b_zdirRod_hole_depth+b_genWallThickness-_b_zdirM_supportThickness, center=false);
					scale([1, 1, 0.5])
						sphere(r=_b_zdirM_supportThickness);
				}
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
					roundEdge(_a=0,_r=b_zDirWall_size[0]/2 + b_lber_zAxisXdirDist + b_lber_diam/4,_l=b_smoothRod_diam,_fn=4);
			}

			if (hasEnstopHolder) {
				for (i=[-1,1])
				translate([b_lber_zAxisXdirDist + b_lber_diam/2+b_genWallThickness + b_elongetatedHole_length/2 , i*(b_xDirWall_size[1]/2 - b_genWallThickness- b_elongetatedHole_NutWallDist/2), b_zDirWall_size[2]-b_xDirWall_size[2]/2]) {
					// elongetated hole
					cube(size=[(b_elongetatedHole_length), (b_genWallThickness+ b_elongetatedHole_NutWallDist/2)*2, b_xDirWall_size[2]], center=true);

					translate([ b_elongetatedHole_length/2,0, 0])
						cylinder(r=(b_genWallThickness+ b_elongetatedHole_NutWallDist/2), h=b_xDirWall_size[2], center=true);
				}

				for (i=[[-1,0],[1,-90]])
				translate([b_xDirWall_size[0]-b_zDirWall_size[0]/2,i[0]*(b_xDirWall_size[1]/2 - (b_genWallThickness+ b_elongetatedHole_NutWallDist/2)*2), b_zDirWall_size[2]-b_xDirWall_size[2]])
					roundEdge(_a=0+i[1],_r=b_elongetatedHole_diam,_l=b_xDirWall_size[2]);
			}



			for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist])
			for (z=b_xdirRods_holes_altitude){
				//xdir holes nut suport range
				translate([0, y, z])
				rotate(a=90,v=Y)
					cylinder(r=m8_nut_diameter/2+b_m8_nut_tolerance[0]/2, h=b_zDirWall_size[0]+ b_verticalSupportThickness*2, center=true);
			}
		}
		union(){

			translate([0, 0, b_zDirWall_size[2]-b_zdirRod_hole_depth]) {
				// z axis hole
				cylinder(r=b_smoothRod_diam/2, h=b_zdirRod_hole_depth+OS, center=false);
				//edge coutoff z axis hole
				translate([0, 0, b_zdirRod_hole_depth-b_horizontalSuportThickness*2 + OS])
					cylinder(r2=b_smoothRod_diam/2+tan(30)*b_horizontalSuportThickness*2,r1=b_smoothRod_diam/2-b_horizontalSuportThickness, h=b_horizontalSuportThickness*2, center=false);
			}

			cylinder(r=b_airOut_diam/2, h= b_zDirWall_size[2]-b_zdirRod_hole_depth -b_horizontalSuportThickness, center=false);

			for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist])
			for (z=b_xdirRods_holes_altitude){
				//xdir hole coutput
				translate([-b_zDirWall_size[0], y, z])
				rotate(a=180,v=X)
					teardrop (r=b_roughRod_diam/2,h=b_zDirWall_size[0]*2,top_and_bottom=false);
					//cylinder(r=b_roughRod_diam/2, h=b_zDirWall_size[0]+2*OS, center=true);
				//xdir holes nut save range
				for (x=[-(b_zDirWall_size[0]/2+_b_SaveRange_height/2 +b_verticalSupportThickness),b_zDirWall_size[0]/2+_b_SaveRange_height/2+ b_verticalSupportThickness])
				translate([x, y, z])
				rotate(a=90,v=Y)
					cylinder(r=m8_nut_diameter/2+b_m8_nut_tolerance[0]/2, h=_b_SaveRange_height, center=true);

				// top and bottom coutoff
				for (i=[-b_zDirWall_size[2]*1.5,b_zDirWall_size[2]+ b_zDirWall_size[2]*1.5])
				translate([0, 0, i])
					cube(size=[b_zDirWall_size[0]*25,b_zDirWall_size[1]*3,b_zDirWall_size[2]*3], center=true);
			}

			//linear bearing coutout
			for (i=[b_lber_zAxisDist+b_lber_length/2,-b_lber_zAxisDist- b_lber_length/2])
			translate([b_lber_zAxisXdirDist, i, b_zDirWall_size[2]-b_lber_topOff+ b_lber_diam/2]) {
				rotate(a=90,v=X) {
					cylinder(r=(b_lber_diam/2)/cos(45), h=b_lber_length, center=true,$fn=4);
					*cylinder(r=(b_lber_diam/2), h=b_lber_length, center=true);
				}

				//cutouts for printability
				cube(size=[b_lber_diam/4 , b_lber_length, (b_lber_diam/2)/cos(45) *2 +2*OS], center=true);

				//zip tie holes
				rotate(a=90,v=X)
				difference() {
					cylinder(r=b_lber_diam/2+b_thinWallThickness+b_zipTies_thickness, h=b_zipTies_width, center=true);
					cylinder(r=b_lber_diam/2+b_thinWallThickness, h=b_zipTies_width+2*OS, center=true);
				}
			}

			//motor calibration screws
			for (i=[-1,1])
			translate([0, i* (b_smoothRod_diam/2 + b_mc_nut_walldist/2 + b_genWallThickness), b_xdirRods_holes_altitude[0]]) {
				rotate(a=90,v=Y){
					cylinder(r=b_mc_hole_diam/2, h=b_zDirWall_size[0] + 2*OS, center=true);
					cylinder(r=b_mc_nut_diam/2, h=b_mc_nut_height, center=true, $fn=6);
				}
				translate([0, 0, -b_xdirRods_holes_altitude[0]/2])
					cube(size=[b_mc_nut_height, b_mc_nut_walldist,  b_xdirRods_holes_altitude[0]], center=true);
			}

			*translate([b_lber_zAxisXdirDist + b_zdirM_hole_zAxisDist/5, 0, b_zDirWall_size[2]-0.5+OS]){
				translate([-5*1.5-1, 0, 0])
				intersection() {
					translate([5/2, 0, 0])
					cube(size=[5, 8, 1], center=true);

					union() {
						translate([0.1/2, 0, 0])
						cube(size=[0.1, 8 , 1], center=true);

						translate([0.1,0 , 0])
						rotate(a=atan((8/2)/(5-0.1)),v=[0,0,1])
							cube(size=[8*5, 0.1, 1], center=true);

						translate([0.1,0 , 0])
						rotate(a=-atan((8/2)/(5-0.1)),v=[0,0,1])
							cube(size=[8*5, 0.1, 1], center=true);
					}
				}
				translate([-5/2, 0, 0])
				intersection() {
					translate([5/2, 0, 0])
					cube(size=[5, 8, 1], center=true);

					union() {
						translate([0.1/2, 0, 0])
						cube(size=[0.1, 8 , 1], center=true);


						translate([5 - 8/4, 8/4, 0])
						difference() {
							cylinder(r=8/4, h=1, center=true);
							cylinder(r=8/4 - 0.1, h=1+0.002, center=true);
							translate([-5, 0, 0])
								cube(size=[5*2, 8*2, 1*2], center=true);
						}

						for (i=[0,8/2- 0.1])
						translate([0, i, -1/2])
							cube(size=[5-8/4 + 0.01, 0.1, 1], center=false);


						translate([5-8/4 - 0.1,0 , -1/2])
						rotate(a=-atan((8/2)/(5-(5-8/4 - 0.1/2))),v=[0,0,1])
							cube(size=[8*5, 0.1, 1], center=false);
					}
				}
				translate([(5+1)/2, 0, 0])
				intersection() {
					translate([5/2, 0, 0])
					cube(size=[5, 8, 1], center=true);

					union() {
						translate([5/2, -8/2 + 0.1/2, 0])
							cube(size=[5, 0.1 , 1], center=true);

						translate([0, -8/2, -1/2])
						rotate(a=45,v=[0,0,1])
							cube(size=[8*0.9, 0.1 , 1], center=false);

						translate([5/2, 8/2-5/2, 0])
						difference() {
							cylinder(r=5/2, h=1, center=true);
							cylinder(r=5/2 - 0.1, h=1+0.002, center=true);

							translate([0, -5- 0.1, 0])
							rotate(a=-20,v=[0,0,1])
								cube(size=[10, 10, 10], center=true);
						}
					}
				}
			}

			if (hasEnstopHolder) {

				for (i=[-1,1])
				translate([b_lber_zAxisXdirDist + b_lber_diam/2+b_genWallThickness + b_elongetatedHole_length/2 , i*(b_xDirWall_size[1]/2 - b_genWallThickness- b_elongetatedHole_NutWallDist/2), b_zDirWall_size[2]-b_xDirWall_size[2]/2]) {
					// elongetated hole coutout
					cube(size=[b_elongetatedHole_length, b_elongetatedHole_diam, b_xDirWall_size[2]+2*OS], center=true);
					//elongetated hole end round coutout
					for (x=[-b_elongetatedHole_length/2,b_elongetatedHole_length/2])
					translate([x, 0, 0])
						cylinder(r=b_elongetatedHole_diam/2, h=b_xDirWall_size[2]+2*OS, center=true);

					//nuttrap
					for (x=[-b_elongetatedHole_length/2,b_elongetatedHole_length/2])
					translate([x, 0, -b_xDirWall_size[2]/2-OS])
						cylinder(r=b_elongetatedHole_NutDiam/2, h=b_elongetatedHole_NutHeight, center=false,$fn=6);
					translate([0, 0, -b_xDirWall_size[2]/2 + b_elongetatedHole_NutHeight/2 -OS])
						cube(size=[b_elongetatedHole_length, b_elongetatedHole_NutWallDist, b_elongetatedHole_NutHeight], center=true);
				}

			} else {
				// rounded edge
				for (i=[[b_xDirWall_size[1]/2,180],[-b_xDirWall_size[1]/2,90]])
				translate([b_xDirWall_size[0]-b_zDirWall_size[0]/2, i[0],b_zDirWall_size[2]-b_xDirWall_size[2]])
					roundEdge(_a=i[1],_r=b_xDirWall_roundedEdge_r,_l=b_xDirWall_size[2],_fn=100);
			}
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
	 H_base(hasEnstopHolder = true);
}

/*------------------------------------print-----------------------------------*/

module H_base_print() {
	translate([-b_zdir_motorHoles_centerDist*1, b_zdir_motorHoles_centerDist/3, 0])
	rotate(a=180,v=Y)
	translate([0, 0, -b_zDirWall_size[2]])
		H_base(hasYMotorMount = true,hasEnstopHolder = true);

	translate([b_zdir_motorHoles_centerDist * 1, -b_zdir_motorHoles_centerDist/3, 0])
	rotate(a=180,v=Z)
	rotate(a=180,v=Y)
	translate([0, 0, -b_zDirWall_size[2]])
		H_base(hasYMotorMount = false);
}
if (b_mode == "printSet") {
	H_base_print();
}
if (b_mode == "print left") {
	rotate(a=180,v=Y)
	translate([0, 0, -b_zDirWall_size[2]])
	H_base(hasYMotorMount = true,hasEnstopHolder = true);
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
	H_base(hasYMotorMount = true,hasEnstopHolder = true);

	translate([-b_zdirM_motorAxis_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]])
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);

	translate([b_ydirM_motorAxis_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]])
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
}

module H_baseright_assembly() {
	rotate(a=180,v=Z) {
		H_base(hasYMotorMount = false);

		translate([-b_zdirM_motorAxis_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]])
			stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
	}
}

if (b_mode == "assembly"){
	//H_baseLeft_assembly();
	H_baseright_assembly();
}

