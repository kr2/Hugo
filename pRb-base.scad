/* pRb-base
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
mode = "inspect";
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

/*------------------------------------xdir wall-------------------------------*/
xDirWall_size             = [30.6,zDirWall_size[1],5.486];

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

/*------------------------------------linear bearings-------------------------*/
lber_length               = 24;
lber_diam                 = 15.3;
lber_zAxisDist            = xDirWall_size[1]/2- strongWallThickness- lber_length;

/*------------------------------------zip ties--------------------------------*/
zipTies_width             = 4;
zipTies_thickness         = 2;

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_xdir_bb_r = m8_nut_diameter*0.75;
_xdirRods_holes_zdist = (xdirRods_holes_altitude[1]-xdirRods_holes_altitude[0]);

module  pRb_base(hasYMotorMount = false) {
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
		}
		union(){
			// z axis
			translate([0, 0, zDirWall_size[2]-zdirRod_hole_depth]) 
				cylinder(r=smoothRod_diam/2, h=zdirRod_hole_depth+OS, center=false);

			for (y=[-xdirRods_holes_zAxisDist,xdirRods_holes_zAxisDist])
			for (z=xdirRods_holes_altitude){
				//xdir hole coutput
				#translate([0, y, z]) 
				rotate(a=90,v=Y) 
					cylinder(r=roughRod_diam/2, h=zDirWall_size[0]+2*OS, center=true); 
				//xdir holes nut save range
				#for (x=[-(zDirWall_size[0]/2+m8_nut_heigth/2),zDirWall_size[0]/2+m8_nut_heigth/2]) 
				translate([x, y, z])
				rotate(a=90,v=Y) 
				cylinder(r=m8_nut_diameter/2+m8_nut_tolerance[0]/2, h=m8_nut_heigth+m8_nut_tolerance[1], center=true); 

				// top bottom coutoff
				for (i=[-zDirWall_size[2]*1.5,zDirWall_size[2]+ zDirWall_size[2]*1.5]) 
				translate([0, 0, i]) 
					cube(size=[zDirWall_size[0]*25,zDirWall_size[1]*3,zDirWall_size[2]*3], center=true);
			} 
		}
	}
}


if (mode == "inspect") {
	 pRb_base();
}
module pRb_base_print() {
	pRb_base();
}
if (mode == "print") {
	pRb_base_print();
}


