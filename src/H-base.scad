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
//b_mode = "print Reight"; $fn=24*4; 
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



/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_b_xdir_bb_r = m8_nut_diameter*0.75;
_b_xdirRods_holes_zdist = (b_xdirRods_holes_altitude[1]-b_xdirRods_holes_altitude[0]);

module  H_base(hasYMotorMount = true, hasSupport = false) {
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
				_motorHolder(holeDist = b_zdirM_hole_dist);

			if (hasYMotorMount ) {
				//yMotor holder
				rotate(a=180,v=Z) 
				translate([-b_ydirM_hole_zAxisDist, 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
					_motorHolder(holeDist = b_zdirM_hole_dist);
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

			for (y=[-b_xdirRods_holes_zAxisDist,b_xdirRods_holes_zAxisDist])
			for (z=b_xdirRods_holes_altitude){
				//xdir hole coutput
				translate([0, y, z]) 
				rotate(a=90,v=Y) 
					cylinder(r=b_roughRod_diam/2, h=b_zDirWall_size[0]+2*OS, center=true); 
				//xdir holes nut save range
				for (x=[-(b_zDirWall_size[0]/2+m8_nut_heigth/2),b_zDirWall_size[0]/2+m8_nut_heigth/2]) 
				translate([x, y, z])
				rotate(a=90,v=Y) 
				cylinder(r=m8_nut_diameter/2+b_m8_nut_tolerance[0]/2, h=m8_nut_heigth+b_m8_nut_tolerance[1], center=true); 

				// top bottom coutoff
				for (i=[-b_zDirWall_size[2]*1.5,b_zDirWall_size[2]+ b_zDirWall_size[2]*1.5]) 
				translate([0, 0, i]) 
					cube(size=[b_zDirWall_size[0]*25,b_zDirWall_size[1]*3,b_zDirWall_size[2]*3], center=true);
			} 

			//linear bearing coutout
			for (i=[b_lber_zAxisDist+b_lber_length/2,-b_lber_zAxisDist- b_lber_length/2])  
			translate([b_lber_zAxisXdirDist, i, b_zDirWall_size[2]-b_lber_topOff+ b_lber_diam/2]) {
				rotate(a=90,v=X) 
					difference() {
						cylinder(r=b_lber_diam/2, h=b_lber_length, center=true);
						if (hasSupport) {
							for (z=[b_lber_length/2+b_lber_length/6:b_lber_length/3:-b_lber_length/2-b_lber_length/6]) 
							translate([0, 0, z]) 
								cylinder(r=b_lber_diam/2, h=b_verticalSupportThickness, center=true);
						}
					}

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


module _motorHolder(holeDist = 31.2) {
	_circelDepth = (holeDist/2)/3*2;

	_inner_r = circel_radius3Points([0,-holeDist/2],[0,holeDist/2],[_circelDepth,0]) -m3_diameter/2- b_genWallThickness;
	_outer_r = _inner_r + 2*b_genWallThickness + m3_diameter;

	_coutoff_angle = 90-atan((holeDist/2)/((holeDist/2 - _circelDepth)));


	_support_outer_r = _outer_r+ _outer_r- _inner_r+10;
	_support_inner_r = _outer_r;
	_support_y = holeDist/2- m3_diameter/2 - b_genWallThickness  + _support_outer_r;
	
	intersection() {
		
		translate([0, 0, b_xDirWall_size[2]/2]) 
			cube(size=[(_circelDepth+b_genWallThickness*1.5)*2, _outer_r*5, b_xDirWall_size[2]], center=true);	

		difference() {
			union(){
				//motor holes
				for (i=[-holeDist/2,holeDist/2]) 
				translate([0, i, 0]) 
					cylinder(r=m3_diameter/2+b_genWallThickness*2, h=b_xDirWall_size[2], center=false);

				translate([-(holeDist/2 - _circelDepth+b_genWallThickness/2), 0, 0]) 
					cylinder(r=_outer_r, h=b_xDirWall_size[2], center=false);

				for (i=[_support_y,-_support_y])
				translate([0, i, 0]) 
					cylinder(r=_support_outer_r, h=b_xDirWall_size[2], center=false); 

			}
			union(){
				//motor holes
				for (i=[-holeDist/2,holeDist/2]) 
				translate([0, i, -OS]) 
					cylinder(r=m3_diameter/2, h=b_xDirWall_size[2]+2*OS, center=false);

				translate([-(holeDist/2 - _circelDepth+b_genWallThickness/2), 0, -OS]) 
					cylinder(r=_inner_r, h=b_xDirWall_size[2]+2*OS, center=false);

				difference() {
					for (i=[[-holeDist/2,_coutoff_angle],[holeDist/2,-_coutoff_angle]]) 
					translate([0, i[0], 0]) 
					rotate(a=i[1],v=Z) 
					translate([-_outer_r*1.5, 0, b_xDirWall_size[2]/2]) 
						cube(size=[_outer_r*3, _outer_r*30,b_xDirWall_size[2]+2*OS], center=true);
					
					//motor holes
					for (i=[-holeDist/2,holeDist/2]) 
					translate([0, i, 0]) 
						cylinder(r=m3_diameter/2+b_genWallThickness*2, h=b_xDirWall_size[2], center=false);

				}


				for (i=[_support_y,-_support_y])
				translate([0, i, -OS]) 
					cylinder(r=_support_inner_r, h=b_xDirWall_size[2]+2*OS, center=false); 

				// coutofs
				*translate([_circelDepth+b_genWallThickness*1.5, -_outer_r*15, -OS]) 
					cube(size=[_outer_r*3, _outer_r*30,b_xDirWall_size[2]+2*OS], center=false);
			}
		}
	}
}
//_motorHolder();

if (b_mode == "inspect") {
	 H_base();
}

/*------------------------------------print-----------------------------------*/

module H_base_print() {
	translate([-b_zdirM_hole_zAxisDist-b_genWallThickness, b_zdirM_hole_dist/4, 0]) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
		H_base(hasYMotorMount = true, hasSupport = false);

	translate([b_zdirM_hole_zAxisDist+b_genWallThickness, -b_zdirM_hole_dist/4, 0]) 
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
		H_base(hasYMotorMount = false, hasSupport = false);
}
if (b_mode == "printSet") {
	H_base_print();
}
if (b_mode == "print Left") {
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
	H_base(hasYMotorMount = true, hasSupport = false);
}
if (b_mode == "print Reight") {
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([0, 0, -b_zDirWall_size[2]])  
	H_base(hasYMotorMount = false, hasSupport = false);
}



/*------------------------------------assembly--------------------------------*/
include <motors.scad>

module H_baseLeft_assembly() {
	H_base(hasYMotorMount = true, hasSupport = false);

	translate([-(b_zdirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);

	translate([(b_ydirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
		stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
}

module H_baseReight_assembly() {
	rotate(a=180,v=Z) {
		H_base(hasYMotorMount = false, hasSupport = false);

		translate([-(b_zdirM_hole_zAxisDist+ b_zdirM_hole_dist/2), 0, b_zDirWall_size[2]-b_xDirWall_size[2]]) 
			stepper_motor_mount(nema_standard=17,slide_distance=0, mochup=true, tolerance=0);
	}
}

if (b_mode == "assembly"){
	//H_baseLeft_assembly();
	H_baseReight_assembly();
}

