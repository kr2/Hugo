/* H-Calibration [cal]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * derivative of the original desing by abdrumm for the PrintrBot
 */
include <config.scad>

include <units.scad>
include <metric.scad>
include <teardrop.scad>
include <roundEdges.scad>

/*------------------------------------general---------------------------------*/
cal_mode = "-";
cal_mode = "print";  $fn=24*4; // can be print or inspect [overlays the b_model with the original b_model] (uncomment next line)

cal_thinWallThickness         = 1.5;
cal_genWallThickness          = 2.5;
cal_strongWallThickness       = 5;

cal_supportDistance           = 0.2; // suport distance for coutout

cal_horizontalSuportThickness = 0.35;
cal_verticalSupportThickness  = 1.35;

cal_outline = [c_z_axis_smoothRod_diam+2*cal_genWallThickness,
               cal_thinWallThickness*6 + m3_nut_diameter*2 + c_z_axis_smoothRod_diam + c_x_axis_smoothRod_diam+ m8_diameter,
               c_z_axis_smoothRod_diam + 2* cal_genWallThickness];

module  H_calibration() {
      translate([0,0, cal_outline[2]/2]) 
	intersection() {
		cube(size=[cal_outline[0] + 0.5, cal_outline[1]*2, cal_outline[2]], center=true);

		difference() {
			union(){
				cube(size=cal_outline, center=true);

				translate([0, -c_z_axis_smoothRod_diam/2-  cal_thinWallThickness - m8_diameter/2, 0]) 
				rotate(a=90,v=Y) 
					cylinder(r=m8_diameter/2 + cal_thinWallThickness, h=cal_outline[0]+ 0.5, center=true);

				translate([- cal_outline[0]/2, cal_outline[1]/2, cal_outline[2]/2]) 
				rotate(a=90,v=Y) 
					roundEdge(_a=0,_r=cal_outline[2],_l=cal_outline[0]);

				difference() {
					union(){
						translate([0, cal_outline[1]/2+ cal_outline[2]/2 + cal_supportDistance, 0 - cal_supportDistance]) 
							cube(size=[cal_outline[0], cal_outline[2], cal_outline[2]], center=true);
						
					}
					union(){
						translate([- cal_outline[0]/2, cal_outline[1]/2+cal_supportDistance, cal_outline[2]/2-cal_supportDistance]) 
						rotate(a=90,v=Y) 
							roundEdge(_a=0,_r=cal_outline[2]+ cal_supportDistance,_l=cal_outline[0]+ 2*OS);

						difference() {
							translate([0, cal_outline[1]/2+cal_supportDistance - (-cal_outline[2]- cal_supportDistance - cal_horizontalSuportThickness) , (-cal_outline[2]- cal_supportDistance - cal_horizontalSuportThickness)/2]) 
							rotate(a=90,v=Y) 
								cylinder(r=cal_outline[2]- cal_supportDistance - cal_horizontalSuportThickness, h=cal_outline[0] + 2*OS, center=true);

							for (i=[-1:1]) 
							translate([i*(cal_outline[0]/2- cal_verticalSupportThickness/2), cal_outline[1]/2, 0]) 
								cube(size=[cal_verticalSupportThickness, cal_outline[1], cal_outline[2]], center=true);
						}

					}
				}
			}
			union(){
				cylinder(r=c_z_axis_smoothRod_diam/2, h=cal_outline[2]+2*OS, center=true);

				translate([0, c_z_axis_smoothRod_diam/2 + cal_thinWallThickness + c_x_axis_smoothRod_diam/2, 0]) 
				rotate(a=90,v=Y) 
					cylinder(r=c_z_axis_smoothRod_diam/2, h=cal_outline[0]+2*OS, center=true);

				translate([0, c_z_axis_smoothRod_diam/2 + cal_thinWallThickness + c_x_axis_smoothRod_diam + cal_thinWallThickness + m3_nut_diameter/2, 0]) 
				rotate(a=90,v=Y) {
						cylinder(r=m3_diameter/2, h=cal_outline[0]+2*OS, center=true);

					translate([0, 0, -cal_outline[2]/2-OS]) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
				}

				translate([-cal_outline[0]/2 - OS - 0.25, -c_z_axis_smoothRod_diam/2-  cal_thinWallThickness - m8_diameter/2, 0]) 
						teardrop (r=m8_diameter/2,h=cal_outline[0]+2*OS+ 0.5,top_and_bottom=false);

				translate([0, -c_z_axis_smoothRod_diam/2-  cal_thinWallThickness - m8_diameter - cal_thinWallThickness - m3_nut_diameter/2, 0]){ 
					translate([0, 0, m3_nut_heigth + cal_horizontalSuportThickness]) 
					cylinder(r=m3_diameter/2, h=cal_outline[2]+2*OS, center=true);

					translate([0, 0, -cal_outline[2]/2-OS]) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth, center=false,$fn=6);
				}
			}
		}
	}
	

	
}

if (cal_mode == "print") {
	H_calibration();
}