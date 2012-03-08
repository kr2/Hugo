/* A-base [b]
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

thinWallThickness         = 1;
genWallThickness          = 2.5;
strongWallThickness       = 8;

horizontalSuportThickness = 0.3;
verticalSupportThickness  = 0.5;

/*------------------------------------rod-------------------------------------*/
smoothRod_diam            = 8.0;
roughRod_diam             = 8.5;

m8_nut_tolerance          = [2,1]; // diameter,height

/*------------------------------------zdir wall-------------------------------*/
zDirWall_size             = [9.4,77.9,58.986];

zDirSupport_r             = 6;

/*------------------------------------xdir wall-------------------------------*/
xDirWall_size             = [30.6,zDirWall_size[1],5.486];
xDirWall_roundedEdge_r    = 8;

/*------------------------------------motorHoles------------------------------*/
//z Motor
zdirM_hole_dist           = 31.2;
zdirM_hole_zAxisDist      = 5.35+7.95;

//y Motor
ydirM_hole_dist           = zdirM_hole_dist;
ydirM_hole_zAxisDist      = 25.35+7.951;

/*------------------------------------zdir Rod--------------------------------*/
zdirRod_hole_depth        = zDirWall_size[2]-10;

/*------------------------------------xdir Rods-------------------------------*/
xdirRods_holes_altitude   = [8.266,45.497];
xdirRods_holes_zAxisDist  = 38.95-8.5;

/*------------------------------------zip ties--------------------------------*/
zipTies_width             = 4;
zipTies_thickness         = 2;

/*------------------------------------linear bearings-------------------------*/
lber_length               = 24;
lber_diam                 = 15.3;
lber_topOff               = (lber_diam- smoothRod_diam)/2+0.5;
lber_zAxisDist            = xDirWall_size[1]/2- strongWallThickness- lber_length;
lber_zAxisXdirDist        = xDirWall_size[0]-genWallThickness- lber_diam/2 - zDirWall_size[0]/2 - zipTies_thickness;



/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_xdir_bb_r = m8_nut_diameter*0.75;
_xdirRods_holes_zdist = (xdirRods_holes_altitude[1]-xdirRods_holes_altitude[0]);

module  A_base(hasYMotorMount = true, hasSupport = true) {
	difference() {
		union(){
			translate([0, 0, zDirWall_size[2]-zdirRod_hole_depth- genWallThickness]) {
				// z axis
				cylinder(r=smoothRod_diam/2+genWallThickness, h=zdirRod_hole_depth+genWallThickness, center=false);
				// z axis rounded end 
				scale([1, 1, 0.5]) 
				sphere(r=smoothRod_diam/2+genWallThickness);
			}


			// xdir wall
			translate([-zDirWall_size[0]/2,-xDirWall_size[1]/2, zDirWall_size[2]-xDirWall_size[2]]) 
			cube(size=xDirWall_size, center=false);

			//y dir bb
			for (z=xdirRods_holes_altitude) 
			translate([-zDirWall_size[0]/2,-xdirRods_holes_zAxisDist, z]) {
				rotate(a=90,v=Y) 
				linear_extrude(height=zDirWall_size[0])
				rotate(a=90,v=Z) 
					barbell (r1=_xdir_bb_r,r2=_xdir_bb_r,r3=(xdirRods_holes_zAxisDist*2)*1,r4=(xdirRods_holes_zAxisDist*2)*1,separation=(xdirRods_holes_zAxisDist*2));

				cube(size=[zDirWall_size[0], xdirRods_holes_zAxisDist*2, _xdir_bb_r*0.75], center=false);
			}

			//z dir bb
			for (y=[-xdirRods_holes_zAxisDist,xdirRods_holes_zAxisDist]) 
			translate([-zDirWall_size[0]/2,y, xdirRods_holes_altitude[0]]) 
			rotate(a=90,v=X) 
			rotate(a=90,v=Y) 
			linear_extrude(height=zDirWall_size[0])
			rotate(a=90,v=Z) 
				barbell (r1=_xdir_bb_r,r2=_xdir_bb_r,r3=(_xdirRods_holes_zdist*2)*0.3,r4=(_xdirRods_holes_zdist*2)*0.3,separation=_xdirRods_holes_zdist);

			//zMotor holder
			translate([-zdirM_hole_zAxisDist, 0, zDirWall_size[2]-xDirWall_size[2]]) 
				_motorHolder(holeDist = zdirM_hole_dist);

			if (hasYMotorMount ) {
				//yMotor holder
				rotate(a=180,v=Z) 
				translate([-ydirM_hole_zAxisDist, 0, zDirWall_size[2]-xDirWall_size[2]]) 
					_motorHolder(holeDist = zdirM_hole_dist);
			}

			// zdir support
			translate([0,0, zDirWall_size[2]-xDirWall_size[2]]) {
				translate([zDirWall_size[0]/2,  -xdirRods_holes_zAxisDist, 0]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=zDirSupport_r,_l=xdirRods_holes_zAxisDist*2,_fn=4);

				translate([0, -smoothRod_diam/2, 0]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=xDirWall_size[0]-zDirWall_size[0]/2,_l=smoothRod_diam,_fn=4);
			}
		}
		union(){
			// z axis
			translate([0, 0, zDirWall_size[2]-zdirRod_hole_depth]) 
				cylinder(r=smoothRod_diam/2, h=zdirRod_hole_depth+OS, center=false);

			for (y=[-xdirRods_holes_zAxisDist,xdirRods_holes_zAxisDist])
			for (z=xdirRods_holes_altitude){
				//xdir hole coutput
				translate([0, y, z]) 
				rotate(a=90,v=Y) 
					cylinder(r=roughRod_diam/2, h=zDirWall_size[0]+2*OS, center=true); 
				//xdir holes nut save range
				for (x=[-(zDirWall_size[0]/2+m8_nut_heigth/2),zDirWall_size[0]/2+m8_nut_heigth/2]) 
				translate([x, y, z])
				rotate(a=90,v=Y) 
				cylinder(r=m8_nut_diameter/2+m8_nut_tolerance[0]/2, h=m8_nut_heigth+m8_nut_tolerance[1], center=true); 

				// top bottom coutoff
				for (i=[-zDirWall_size[2]*1.5,zDirWall_size[2]+ zDirWall_size[2]*1.5]) 
				translate([0, 0, i]) 
					cube(size=[zDirWall_size[0]*25,zDirWall_size[1]*3,zDirWall_size[2]*3], center=true);
			} 

			//linear bearing coutout
			for (i=[lber_zAxisDist+lber_length/2,-lber_zAxisDist- lber_length/2])  
			translate([lber_zAxisXdirDist, i, zDirWall_size[2]-lber_topOff+ lber_diam/2]) {
				rotate(a=90,v=X) 
					difference() {
						cylinder(r=lber_diam/2, h=lber_length, center=true);
						if (hasSupport) {
							for (z=[lber_length/2+lber_length/6:lber_length/3:-lber_length/2-lber_length/6]) 
							translate([0, 0, z]) 
								cylinder(r=lber_diam/2, h=verticalSupportThickness, center=true);
						}
					}

				//zip tie holes
				rotate(a=90,v=X) 
				difference() {
					cylinder(r=lber_diam/2+thinWallThickness+zipTies_thickness, h=zipTies_width, center=true);
					cylinder(r=lber_diam/2+thinWallThickness, h=zipTies_width+2*OS, center=true);
				}
			}

			// rounded edge
			for (i=[[xDirWall_size[1]/2,180],[-xDirWall_size[1]/2,90]]) 
			translate([xDirWall_size[0]-zDirWall_size[0]/2, i[0],zDirWall_size[2]-xDirWall_size[2]]) 
				roundEdge(_a=i[1],_r=xDirWall_roundedEdge_r,_l=xDirWall_size[2],_fn=100);
		}
	}
}


module _motorHolder(holeDist = 31.2) {
	_circelDepth = (holeDist/2)/3*2;

	_inner_r = circel_radius3Points([0,-holeDist/2],[0,holeDist/2],[_circelDepth,0]) -m3_diameter/2- genWallThickness;
	_outer_r = _inner_r + 2*genWallThickness + m3_diameter;

	_coutoff_angle = 90-atan((holeDist/2)/((holeDist/2 - _circelDepth)));


	_support_outer_r = _outer_r+ _outer_r- _inner_r;
	_support_inner_r = _outer_r;
	_support_y = holeDist/2- m3_diameter/2 - genWallThickness  + _support_outer_r;
	
	intersection() {
		
		translate([0, 0, xDirWall_size[2]/2]) 
		cube(size=[(_circelDepth+genWallThickness*1.5)*2, _outer_r*2.5, xDirWall_size[2]], center=true);	

		difference() {
			union(){
				//motor holes
				for (i=[-holeDist/2,holeDist/2]) 
				translate([0, i, 0]) 
					cylinder(r=m3_diameter/2+genWallThickness, h=xDirWall_size[2], center=false);

				translate([-(holeDist/2 - _circelDepth+genWallThickness/2), 0, 0]) 
					cylinder(r=_outer_r, h=xDirWall_size[2], center=false);

				for (i=[_support_y,-_support_y])
				translate([0, i, 0]) 
					cylinder(r=_support_outer_r, h=xDirWall_size[2], center=false); 

			}
			union(){
				//motor holes
				for (i=[-holeDist/2,holeDist/2]) 
				translate([0, i, -OS]) 
					cylinder(r=m3_diameter/2, h=xDirWall_size[2]+2*OS, center=false);

				translate([-(holeDist/2 - _circelDepth+genWallThickness/2), 0, -OS]) 
					cylinder(r=_inner_r, h=xDirWall_size[2]+2*OS, center=false);

				difference() {
					for (i=[[-holeDist/2,_coutoff_angle],[holeDist/2,-_coutoff_angle]]) 
					translate([0, i[0], 0]) 
					rotate(a=i[1],v=Z) 
					translate([-_outer_r*1.5, 0, xDirWall_size[2]/2]) 
						cube(size=[_outer_r*3, _outer_r*30,xDirWall_size[2]+2*OS], center=true);
					
					//motor holes
					for (i=[-holeDist/2,holeDist/2]) 
					translate([0, i, 0]) 
						cylinder(r=m3_diameter/2+genWallThickness, h=xDirWall_size[2], center=false);

				}


				for (i=[_support_y,-_support_y])
				translate([0, i, -OS]) 
					cylinder(r=_support_inner_r, h=xDirWall_size[2]+2*OS, center=false); 

				// coutofs
				*translate([_circelDepth+genWallThickness*1.5, -_outer_r*15, -OS]) 
					cube(size=[_outer_r*3, _outer_r*30,xDirWall_size[2]+2*OS], center=false);
			}
		}
	}
}
//!_motorHolder();

if (mode == "inspect") {
	 A_base();
}
module A_base_print() {
	translate([-zdirM_hole_zAxisDist-2*genWallThickness, 0, 0]) 
	rotate(a=180,v=Y) 
	translate([0, 0, -zDirWall_size[2]])  
		A_base(hasYMotorMount = true, hasSupport = true);
	translate([zdirM_hole_zAxisDist+2*genWallThickness, 0, 0]) 
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([0, 0, -zDirWall_size[2]])  
		A_base(hasYMotorMount = false, hasSupport = true);
}
if (mode == "print") {
	A_base_print();
}


