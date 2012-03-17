/* H-Fan [f]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <config.scad>
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
f_mode = "-";  
//f_mode = "print";  $fn=24*4;  // can be print or inspect [overlays the Ybd_model with the original Ybd_model] (uncomment next line)
f_mode = "inspect";
//f_mode = "assembly";

f_thinWallThickness          = 1;
f_genWallThickness           = 1.5;
f_strongWallThickness        = 4;

f_horizontalSuportThickness  = 0.3;
f_verticalSupportThickness   = 0.5;


f_airChannal_segments = 12;

f_airChannal_outerR = 32;

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


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/

_f_nutFree_r = f_fanHoles_nutDiam/2+f_fanHoles_nuttAddFree;

module H_Fan() {
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
			
		}
		union(){
			for (i=[0,180])
			rotate(a=i,v=Z) 
			{
				translate([0, 0, -OS]) 
				rotate(a=90,v=X)
					linear_extrude(file = "fanOutlet.dxf", layer = "fanConnector_outline",height = f_fanSize, center = true, convexity = 10, twist = 0);
			}

		}
	}
}

module H_FanConnector() {
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
		}
		union(){
			for (i=[0,180])
			rotate(a=i,v=Z) {
				
				
				//fan round coutout
				rotate(a=90,v=X)
				translate([f_fanCenterOffset+OS, f_fanSize/2, 0]) 
				rotate(a=-90,v=Y) 
					cylinder(r=f_fanSize/2- f_genWallThickness, h=3+2*OS, center=false);

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



if (f_mode == "inspect") {
	H_Fan();
	H_FanConnector() ;
}
module H_Fan_print() {
	H_Fan();
}
if (f_mode == "print") {
	H_Fan_print();
}




/*------------------------------------assembly--------------------------------*/
module H_Fan_assembly() {
	H_Fan();
}

if (f_mode == "assembly"){
	H_Fan_assembly();
}