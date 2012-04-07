/* H-TestObject [cal]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */
include <config.scad>

include <units.scad>
include <metric.scad>
include <teardrop.scad>
include <roundEdges.scad>

include <H-X-End.scad>
include <H-X-Carriager.scad>
include <H-Z-End.scad>
include <BearingGuide.scad>


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

				// brig and support test
				for (i=[-cal_outline[0]/2, cal_outline[2]/2 - cal_verticalSupportThickness]) 
				translate([ i,cal_outline[1]/2-OS, -cal_outline[2]/2]) 
					cube(size=[cal_verticalSupportThickness, cal_outline[2]/2, cal_outline[2]], center=false);
				translate([-cal_outline[0]/2, cal_outline[1]/2, cal_outline[2]/2- cal_horizontalSuportThickness])
					cube(size=[cal_outline[0],cal_outline[2]/2 , cal_horizontalSuportThickness], center=false); 

				//support test
				*translate([- cal_outline[0]/2, cal_outline[1]/2, cal_outline[2]/2]) 
				rotate(a=90,v=Y) 
					roundEdge(_a=0,_r=cal_outline[2],_l=cal_outline[0]);
				*difference() {

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

				translate([0, -cal_outline[1]/2, 0]) 
				rotate(a=180,v=Y) 
				rotate(a=-90,v=Z) 
					teardropFlat (r=m8_diameter/2 + cal_genWallThickness,h= cal_outline[2],top_and_bottom=false);

			}
			union(){
				cylinder(r=c_z_axis_smoothRod_diam/2, h=cal_outline[2]+2*OS, center=true);

				translate([0, c_z_axis_smoothRod_diam/2 + cal_thinWallThickness + c_x_axis_smoothRod_diam/2, 0]) 
				rotate(a=90,v=Y) 
					cylinder(r=c_x_axis_smoothRod_diam/2, h=cal_outline[0]+2*OS, center=true);

				translate([0, c_z_axis_smoothRod_diam/2 + cal_thinWallThickness + c_x_axis_smoothRod_diam + cal_thinWallThickness + m3_nut_diameter/2, 0]) 
				rotate(a=90,v=Y) {
						cylinder(r=m3_diameter/2, h=cal_outline[0]+2*OS, center=true);

					translate([0, 0, -cal_outline[2]/2-OS]) 

					rotate(a=30,v=Z) 
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

				translate([0, -cal_outline[1]/2, 0]) 
				rotate(a=-90,v=Z) 
					teardrop (r=m8_diameter/2,h= cal_outline[2]+OS,top_and_bottom=false);
			}
		}
	}

	//xend tests
	translate([cal_outline[0]/2 + 1 + max((m8_nut_wallDist/2+Xe_gen_wall)/cos(30),Xe_Z_bearingHole_dia/2+Xe_gen_wall), 0, 0]) 
	difference() {
		union(){
			translate([0, (m8_nut_wallDist/2+Xe_gen_wall)/cos(30) + 1, 0]) 
				cylinder(h=m8_nut_heigth+cal_horizontalSuportThickness,r= (m8_nut_wallDist/2+Xe_gen_wall)/cos(30) ,$fn=6);

			translate([0, -Xe_Z_bearingHole_dia/2-Xe_gen_wall-1, 0]) 
				cylinder(r=Xe_Z_bearingHole_dia/2+Xe_gen_wall,h=m8_nut_heigth,center=false,$fn=48);
		}
		union(){
			translate([0, (m8_nut_wallDist/2+Xe_gen_wall)/cos(30) + 1, -OS]) 
				cylinder(h=m8_nut_heigth+2*OS,r=Xe_m8_nut_diameter/2,$fn=6,center=false);

			translate([0, -Xe_Z_bearingHole_dia/2-Xe_gen_wall-1, -OS]) 
				cylinder(r=Xe_Z_bearingHole_dia/2,h=m8_nut_heigth+2*OS,center=false,$fn=48);
		}
	}

	// carriager test
	translate([-(cal_outline[0]/2 + 1 + cal_outline[0]), Xc_lber_diam/2 + Xc_genWallThickness+1, Xc_lber_diam/2 + Xc_genWallThickness]) 
	difference() {
		union(){
			teardropFlat (r=Xc_lber_diam/2 + Xc_genWallThickness,h=cal_outline[0],top_and_bottom=true);
		}
		union(){
			translate([-OS, 0, 0]) 
				teardrop (r=Xc_lber_diam/2,h=cal_outline[0]+2*OS,top_and_bottom=false);
		}
	}
	

	// zend & bearing Clamp test
	*translate([-(cal_outline[0]/2+Ze_bear_diam/2 + Xe_gen_wall+1), -(+Ze_bear_diam/2 + Xe_gen_wall+1), 0]) 
	difference() {
		union(){
			cylinder(r=Ze_bear_diam/2 + single_layer_width, h=Ze_bear_heigth + cal_horizontalSuportThickness, center=false);
		}
		union(){
			translate([0, 0, -OS]) 
			cylinder(r=Ze_bear_diam/2, h=Ze_bear_heigth, center=false);
		}
	}
	*translate([0, +cal_outline[1]/2 + cal_outline[2]/2 + 1 +Ze_bear_diam/2 + single_layer_width + conn_tolerance + single_layer_width, 0]) 
	difference() {
		union(){
			cylinder(r=Ze_bear_diam/2 + single_layer_width + conn_tolerance + single_layer_width, h=Ze_bear_heigth, center=false);
		}
		union(){
			translate([0, 0, -OS]) 
			cylinder(r=Ze_bear_diam/2 + single_layer_width + conn_tolerance , h=Ze_bear_heigth + 2*OS, center=false);
		}
	}
}

if (cal_mode == "print") {
	H_calibration();
}