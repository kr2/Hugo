/* H-Fanduct [f]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <config.scad>
include <units.scad>
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
f_mode = "-";  
//f_mode = "print";  $fn=24*4;  // can be print or inspect [overlays the Ybd_model with the original Ybd_model] (uncomment next line)
//f_mode = "printSet";  $fn=24*4;  // can be print or inspect [overlays the Ybd_model with the original Ybd_model] (uncomment next line)
//f_mode = "inspect";
//f_mode = "assembly";

f_thinWallThickness          = 1;
f_genWallThickness           = 1.5;
f_strongWallThickness        = 4;

f_supportDist = 5;

f_horizontalSuportThickness  = 0.3;
f_verticalSupportThickness   = 1.35;


f_airChannal_segments = 12;

f_airChannal_outerR = 32;
f_airChannal_width = 45;

f_fanSize = 40;

f_fanCenterOffset = 50;

f_fanHoles_centerDist = 45/2;
f_fanHoles_diam = 3.2;
f_fanHoles_nutDiam = 6.45;
f_fanHoles_nutHeight = 2.3;

f_fanHoles_nuttAddFree = 2.0;

f_screwFreeSpace = 6;


/*------------------------------------connector-------------------------------*/
f_conn_size = [3*2+m3_diameter,f_strongWallThickness,70];  // relative to z=0
f_connSlot_width = m3_diameter;

/*------------------------------------clamp-----------------------------------*/
f_clamp_thickness = 0.5;
f_clamp_widht = m3_diameter + 2*f_strongWallThickness;
f_clampThin_widht = 28;
f_clamp_slotWidth = m3_diameter;
f_clamp_length = 50;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/

_f_nutFree_r = f_fanHoles_nutDiam/2+f_fanHoles_nuttAddFree;

module H_Fan_airChannal() {
	// ari Channal
	difference() {
		union(){
			rotate_extrude(file = "fanOutlet.dxf", layer = "airCannal",origin =  [0,0], convexity = 10,$fn=f_airChannal_segments);

			//support walls
			intersection() {
				rotate_extrude(file = "fanOutlet.dxf", layer = "supportOutline",origin =  [0,0], convexity = 10,$fn=f_airChannal_segments);
				for (i=[0:360/f_airChannal_segments:180]) 
				rotate(a=i,v=Z) 
					cube(size=[100, f_thinWallThickness, 100], center=true);
			}

			//seperater wall
			intersection() {
				rotate_extrude(file = "fanOutlet.dxf", layer = "airCannal_outline",origin =  [0,0], convexity = 10,$fn=f_airChannal_segments);
				cube(size=[f_thinWallThickness,100, 100], center=true);
			}

			//cutoff
			intersection() {
				rotate_extrude(file = "fanOutlet.dxf", layer = "airCannal_outline",origin =  [0,0], convexity = 10,$fn=f_airChannal_segments);
				for (i=[-1,1]) 
				translate([0, i*(f_airChannal_width/2+f_airChannal_outerR/2), 0]) 
					cube(size=[f_airChannal_outerR*2, f_airChannal_outerR, f_airChannal_outerR], center=true);
			}
			
		}
		union(){
			for (i=[0,180])
			rotate(a=i,v=Z) 
			{
				translate([0, 0, -OS]) 
				rotate(a=90,v=X)
					linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_fanSize, center = true, convexity = 10, twist = 0);
			}

			//cutoff
			for (i=[-1,1]) 
			translate([0, i*(f_airChannal_width/2+f_airChannal_outerR/2+f_thinWallThickness), 0]) 
				cube(size=[f_airChannal_outerR*2, f_airChannal_outerR, f_airChannal_outerR], center=true);


		}
	}
}
/*
conType:
elongeteated
bar
*/
module H_FanConnector(conType = "bar") {
	color([100/255, 0/255, 0/255])
	for (x=[-f_fanCenterOffset+15,f_fanCenterOffset-15]) 
	for (y=[-5,5]) 
	translate([x,y, 1.5-OS]) 
		linear_extrude(file = "fanOutlet.dxf", layer = "arrow",height = f_horizontalSuportThickness, center = false, convexity = 10, twist = 0,$fn=24);

	difference() {
		union(){
			//fan connetor outline
			for (i=[0,180]) 
			rotate(a=i,v=Z) 
			{
				//hull
				rotate(a=90,v=X)
					linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_hull",height = f_fanSize, center = true, convexity = 10, twist = 0);

				//walls
				for (i=[-f_fanSize/2+f_thinWallThickness/2,f_fanSize/2-f_thinWallThickness/2])
				translate([0, i, 0])  
				rotate(a=90,v=X)
					linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_thinWallThickness, center = true, convexity = 10, twist = 0);

				intersection() {
					rotate(a=90,v=X)
						linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_fanSize, center = true, convexity = 10, twist = 0);

					// sollid spots for screws
					translate([f_fanCenterOffset+OS, 0, f_fanSize/2]) 
					for (_a=[45:90:350]) 
					rotate(a=_a,v=X) 
					translate([0, f_fanHoles_centerDist+_f_nutFree_r,0]) 
					rotate(a=-90,v=Y) 
						cylinder(r1=_f_nutFree_r*2,r2=f_genWallThickness/2, h=27, center=false);	
				}

				if (conType == "elongeteated") {
					difference() {
						union(){
							translate([f_fanCenterOffset- f_conn_size[0]/2, 0, f_conn_size[2]/2-f_conn_size[0]/4]) 
								cube(size=f_conn_size-[0,0,f_conn_size[0]/2], center=true);

							translate([f_fanCenterOffset- f_conn_size[0]/2, 0, f_conn_size[2]-f_conn_size[0]/2]) 
							rotate(a=90,v=X) 
								cylinder(r=f_conn_size[0]/2, h=f_conn_size[1], center=true);
						}
						union(){
							rotate(a=90,v=X)
								linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_fanSize, center = true, convexity = 10, twist = 0);

							translate([f_fanCenterOffset- f_conn_size[0]/2, 0, f_conn_size[2]/2-f_conn_size[0]/4]) 
								cube(size=[f_connSlot_width,f_conn_size[1]+2*OS,f_conn_size[2]-f_conn_size[0]/2], center=true);

							translate([f_fanCenterOffset- f_conn_size[0]/2, 0, f_conn_size[2]-f_conn_size[0]/2]) 
							rotate(a=90,v=X) 
								cylinder(r=f_connSlot_width/2, h=f_conn_size[1]+2*OS, center=true,$fn=4);
						}
					}
				}
				if (conType == "bar") {
					difference() {
						union(){
							translate([f_fanCenterOffset- f_conn_size[1]/2, 0, f_conn_size[2]/2-f_conn_size[1]/4]) 
								cube(size=[f_conn_size[1],f_conn_size[1],f_conn_size[2]-f_conn_size[1]/2], center=true);

							translate([f_fanCenterOffset- f_conn_size[1]/2, 0, f_conn_size[2]-f_conn_size[1]/2]) 
							rotate(a=90,v=X) 
								cylinder(r=f_conn_size[1]/2, h=f_conn_size[1], center=true);
						}
						union(){
							rotate(a=90,v=X)
								linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_fanSize, center = true, convexity = 10, twist = 0);
						}
					}
				}
			}
		}
		union(){
			for (i=[0,180])
			rotate(a=i,v=Z) {
				
				
				//fan round coutout
				
				translate([f_fanCenterOffset+OS, 0, f_fanSize/2]) 
				rotate(a=180,v=Z) 
					teardrop (r=f_fanSize/2- f_genWallThickness*1.25,h=3+2*OS,top_and_bottom=false);
					//cylinder(r=f_fanSize/2- f_genWallThickness, h=3+2*OS, center=false);

				// screw holes
				translate([f_fanCenterOffset+OS, 0, f_fanSize/2]) 
				for (_a=[45:90:350]) 
				rotate(a=_a,v=X) 
				translate([0, f_fanHoles_centerDist,0]) 
				rotate(a=-90,v=Y) 
					cylinder(r=f_fanHoles_diam/2, h=f_screwFreeSpace, center=false);	


				// sollid spots for screws
				difference() {
					union(){
						translate([f_fanCenterOffset , 0, f_fanSize/2]) 
						for (_a=[45:90:350]) 
						rotate(a=_a,v=X) 
						translate([0, f_fanHoles_centerDist+_f_nutFree_r + f_thinWallThickness,0]) 
						rotate(a=-90,v=Y) 
							cylinder(r1=_f_nutFree_r*2,r2=f_genWallThickness/2, h=27, center=false);
					}
					union(){
						translate([f_fanCenterOffset , 0, f_fanSize/2+OS]) 
							cube(size=[f_strongWallThickness, f_fanSize+2*OS,f_fanSize+2*OS], center=true);
					}
				}
			}
		}
	}
}

module H_fanDuct() {
	H_Fan_airChannal();
	H_FanConnector() ;	
}

module H_fan_clamp() {
	difference() {
		union(){
			translate([0, -f_clamp_length/4, f_clamp_thickness/2]) 
				cube(size=[f_clampThin_widht, f_clamp_length/2, f_clamp_thickness], center=true);

			for (x=[-1,1]) 
			translate([x*(f_clamp_widht/2-(f_clamp_widht- f_conn_size[1])/4), f_clamp_length/4,  f_conn_size[0]/2]) 
				cube(size=[(f_clamp_widht- f_conn_size[1])/2, f_clamp_length/2, f_conn_size[0]], center=true);
			
			scale([1, 0.1, 1]) 
			rotate(a=90,v=Y) 
				cylinder(r=f_conn_size[0], h=f_clamp_widht, center=true);
		}
		union(){
			translate([0, 0, -50]) 
				cube(size=[100, 100, 100], center=true);

			for (i=[[f_clampThin_widht/2,180],[-f_clampThin_widht/2,-90]]) 
			translate([i[0], 0, -OS]) 
				roundEdge(_a=i[1],_r=(f_clampThin_widht- f_clamp_widht)/4,_l=f_clamp_thickness+2*OS,_fn=100);

			translate([0, -f_clamp_length/4-f_conn_size[0]*0.5, f_clamp_thickness/2]) 
				cube(size=[f_clamp_slotWidth, f_clamp_length/2, f_clamp_thickness+OS], center=true);

			difference() {
				for (x=[-1,1]) 
				translate([x*(f_clamp_widht/2-(f_clamp_widht- f_conn_size[1])/4), f_clamp_length/4 + f_clamp_widht/2,  f_conn_size[0]/2]) 
					cube(size=[(f_clamp_widht- f_conn_size[1])/2 +2*OS, f_clamp_length/2, f_connSlot_width], center=true);
				
				for (i=[0:f_supportDist: f_clamp_length/2]) 
				translate([0, f_clamp_length/2-f_verticalSupportThickness/2 - i, f_clamp_widht/2+OS]) 
					cube(size=[f_clamp_widht+2*OS, f_verticalSupportThickness, f_conn_size[0]], center=true);
			}
			
		}
	}
}



if (f_mode == "inspect") {
	H_fanDuct();

	translate([-30, 0, 50]) 
	rotate(a=90,v=Z) 
	H_fan_clamp();
}
module H_Fan_print() {
	H_fanDuct();
}
if (f_mode == "print") {
	H_Fan_print();
}

if (f_mode == "printSet") {
	H_Fan_print();

	for (i=[-42,42]) 
	translate([0, i, 0]) 
	rotate(a=90,v=[0,0,1]) 
	H_fan_clamp();
}



/*------------------------------------assembly--------------------------------*/
module H_Fan_assembly(zDirOffset = -60) {
	translate([0, 0, zDirOffset]) 
		H_fanDuct();



	for (i=[-1,1]) 
	translate([-i*f_fanCenterOffset*0.75, 0, 0]) 
	rotate(a=i*90,v=Z) 
	//rotate(a=180,v=Y) 
	H_fan_clamp();
}

if (f_mode == "assembly"){
	H_Fan_assembly();
}