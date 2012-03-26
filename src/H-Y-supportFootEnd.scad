/* H-Y-SupportFootEnd [Ysf]
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
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
Ysf_mode = "-";  
//Ysf_mode = "print";  $fn=24*4;   // can be print or inspect [overlays the Ysf_model with the original Ysf_model] (uncomment next line)
//Ysf_mode = "printSet";  $fn=24*4;   
//Ysf_mode = "inspect";
//Ysf_mode = "assembly";

Ysf_thinWallThickness          = 1;
Ysf_genWallThickness           = 2.5;
Ysf_strongWallThickness        = 8;

Ysf_horizontalSuportThickness  = 0.3;
Ysf_verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
Ysf_roughRod_diam                   = 8.5;

/*------------------------------------supportFootEnd--------------------------*/
Ysf_sFooEnd_size = [(8.267+9.25)*2+3,(8.267+9.25)*2+3,Ysf_strongWallThickness];

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Ysf_acrossStrive_angle = atan(Ysf_sFooEnd_size[0]/Ysf_sFooEnd_size[1]);
_Ysf_acrossStrive_diam = min(Ysf_sFooEnd_size[0],Ysf_sFooEnd_size[1])/4;
_Ysf_acrossStrive_length = distance1D(Ysf_sFooEnd_size[0],Ysf_sFooEnd_size[1])-_Ysf_acrossStrive_diam*2.4;


_Ysf_sideLength = Ysf_sFooEnd_size[0];
module  H_Y_supportFootEnd() {
	
	intersection() {
		intersection() {
				translate([0, 0, Ysf_sFooEnd_size[2]/2]) 
				cube(size=Ysf_sFooEnd_size, center=true);
				cylinder(r=Ysf_sFooEnd_size[0]*0.6, h=Ysf_sFooEnd_size[2], center=false);
			}
		difference() {
			union(){
				translate([0, 0, Ysf_sFooEnd_size[2]/2]) 
				difference() {
					intersection() {
						cube(size=Ysf_sFooEnd_size, center=true);
						cylinder(r=Ysf_sFooEnd_size[0]*0.6, h=Ysf_sFooEnd_size[2], center=true);
					}
					intersection() {
						cube(size=Ysf_sFooEnd_size-[Ysf_genWallThickness*2,Ysf_genWallThickness*2,-OS*2], center=true);
						cylinder(r=Ysf_sFooEnd_size[0]*0.54, h=Ysf_sFooEnd_size[2]+2*OS, center=true);
					}
				}
				
				for (i=[[0,_Ysf_sideLength/2],[0,-_Ysf_sideLength/2],[_Ysf_sideLength/2,0],[-_Ysf_sideLength/2,0]]) {
					translate([i[0], i[1], 0]) 
					difference() {
						cylinder(r=_Ysf_sideLength/2-Ysf_genWallThickness, h=Ysf_sFooEnd_size[2], center=false);
						translate([0, 0, -OS]) 
						cylinder(r=_Ysf_sideLength/2-4*Ysf_genWallThickness, h=Ysf_sFooEnd_size[2] + 2*OS, center=false);
					}
				}

				cylinder(r=Ysf_roughRod_diam/2 + Ysf_genWallThickness, h=Ysf_sFooEnd_size[2], center=false);
				
			}
			union(){
				translate([0, 0, -OS]) 
					cylinder(r=Ysf_roughRod_diam/2, h=Ysf_sFooEnd_size[2] + 2*OS, center=false);

			}
		}
	}
}


if (Ysf_mode == "inspect") {
	H_Y_supportFootEnd();
}
module H_Y_supportFootEnd_print() {
	H_Y_supportFootEnd();
}
if (Ysf_mode == "print") {
	H_Y_supportFootEnd_print();
}
module H_Y_supportFootEnd_printSet() {
	translate([-_Ysf_sideLength/2-1, 0, 0]) 
	H_Y_supportFootEnd_print();
	translate([_Ysf_sideLength/2+1, 0, 0]) 
	H_Y_supportFootEnd_print();
}
if (Ysf_mode == "printSet") {
	 H_Y_supportFootEnd_printSet();
}




/*------------------------------------assembly--------------------------------*/

module H_Y_supportFootEnd_assembly() {
	translate([0, Ysf_sFooEnd_size[2]/2, 0]) 
	rotate(a=90,v=X) 
	H_Y_supportFootEnd();
}

if (Ysf_mode == "assembly"){
	H_Y_supportFootEnd_assembly();
}
