/* pRb-X-Carriage
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <nuts_and_bolts.scad>;
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
use <pRb-Y-beltClamp.scad>


/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
mode = "inspect";

axis_dist = 25.38;
genWallThickness = 2.5;
strongWallThickness = 5;

horizontalSuportThickness = 0.4;
verticalSupportThickness = 0.5;

/*------------------------------------linear bearings-------------------------*/
lber_length = 24;
lber_diam = 15;

/*------------------------------------notch-----------------------------------*/
// connecot notch to the xtruder holder
notch_width = 5.4;
notch_depth = 1.2;
notch_lengt = 24 + 2.5 + 0.5;

/*------------------------------------xtruder carriag holes-------------------*/
holes_diam = m4_diameter;
holes_dist = 18;

/*------------------------------------rod-------------------------------------*/
rod_diam = 8.5;

/*------------------------------------belt------------------------------------*/

translate([0, -35, 20]) 
mirror([1, 0, 0])  
rotate(a=-90,v=X) 
pRb_yBeltClam() ;

module pRb_x_Carriage(hasSupport = true) {
	xdir = axis_dist+lber_diam+2*genWallThickness;
	ydir = lber_diam+2*genWallThickness;
	zdir = lber_length*2+genWallThickness;

	matCoutout_scale = (lber_length/2)/(axis_dist/2+lber_diam/2+genWallThickness); // material coutout scale
	matCoutout_rounded_r = xdir/2;

	
	difference() {
		union(){
			for (i=[-axis_dist/2,axis_dist/2]) 
			translate([i, 0, 0]) 
				cylinder(r=lber_diam/2+genWallThickness, h=lber_length*2+genWallThickness, center=false);
			translate([0, 0, lber_length+genWallThickness/2]) 
				cube(size=[axis_dist, lber_diam+2*genWallThickness, lber_length*2+genWallThickness], center=true);
		}
		union(){
			//bearin coutout
			translate([-axis_dist/2, 0, -OS])
				difference() {
					cylinder(r=lber_diam/2, h=lber_length*2+genWallThickness+2*OS, center=false);
				 	translate([0, 0, lber_length])
				 		_bearingStop(); 
				} 
			translate([axis_dist/2, 0, -OS])
				difference() {
					cylinder(r=lber_diam/2, h=lber_length*2+genWallThickness+2*OS, center=false);
				 	translate([0, 0, lber_length/2])
				 		_bearingStop(); 
				} 

			//material coutout
			for (i=[0,lber_length*2+genWallThickness]){
				translate([axis_dist/2+lber_diam/2+genWallThickness, 0, i])
				scale([1, 1, matCoutout_scale])
				rotate(a=90,v=X) 
					cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*OS, center=true,$fn=48); 			
			}

			//notch coutout
			translate([0, ydir/2- notch_depth/2+OS, zdir/2]){ 
				cube(size=[notch_width, notch_depth, notch_lengt], center=true);
				for (i=[-notch_width/2,notch_width/2])
				translate([i-notch_depth/2-0.1, notch_depth/2, 0]) 
				rotate(a=-30,v=[0,0,1]) 
					triangle(l=notch_depth,h=notch_lengt+OS);
			}

			// screw holes
			for (i=[zdir/2- holes_dist/2,zdir/2+ holes_dist/2]) 
			translate([0, 0, i]) {
				rotate(a=90,v=X) 
					cylinder(r=holes_diam/2, h=ydir+2*OS, center=true,$fn=24);
				translate([0, -ydir/2-OS, 0]) 
				rotate(a=-90,v=X) 
				rotate(a=30,v=Z) 
					cylinder(r=m4_nut_diameter/2, h=m4_nut_heigth, center=false,$fn=6);

			}
		}
	}

	if (hasSupport) {
		// lower coutout suport
		intersection() {
			union() {
				for (i=[-lber_diam/2- genWallThickness,lber_diam/2+genWallThickness]) 
				translate([xdir/4, i, matCoutout_rounded_r*matCoutout_scale/2]) 
					cube(size=[matCoutout_rounded_r, verticalSupportThickness, matCoutout_rounded_r*matCoutout_scale], center=true);
			}
			translate([axis_dist/2+lber_diam/2+genWallThickness, 0, 0])
					scale([1, 1, matCoutout_scale])
					rotate(a=90,v=X) 
						cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*verticalSupportThickness+2*OS, center=true,$fn=48); 			
		}
		intersection() {
			translate([xdir/4, 0, matCoutout_rounded_r*matCoutout_scale/2]) 
				cube(size=[matCoutout_rounded_r, ydir+2*OS, matCoutout_rounded_r*matCoutout_scale], center=true);
			translate([axis_dist/2+lber_diam/2+genWallThickness, 0, 0])
			scale([1, 1, matCoutout_scale])
			rotate(a=90,v=X) 
			difference() {
				cylinder(r=matCoutout_rounded_r, h=lber_diam+2*genWallThickness +2*verticalSupportThickness, center=true,$fn=48);
				cylinder(r=matCoutout_rounded_r- horizontalSuportThickness, h=lber_diam+2*genWallThickness +2*verticalSupportThickness+2*OS, center=true,$fn=48);
			}
		}
	}
}

module _bearingStop() {
	difference() {
		cylinder(r=lber_diam/2+2*OS, h=genWallThickness, center=false);
		translate([0, 0, horizontalSuportThickness]) 
		cylinder(r=rod_diam/2, h=genWallThickness- horizontalSuportThickness+OS, center=false);
	}
}
//!union(){_bearingStop();}


if (mode == "inspect") {
	pRb_x_Carriage(hasSupport = false);
}
module pRb_x_Carriage_print() {
	pRb_x_Carriage();
}
if (mode == "print") 
	pRb_x_Carriage_print();



module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}