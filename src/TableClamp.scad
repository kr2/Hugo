/* TabelClamp [tc]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>
include <metric.scad>
include <H-Y-beltClamp_alternativ.scad>
include <teardrop.scad>
include <roundEdges.scad>

/*------------------------------------general---------------------------------*/
tc_mode = "-";
// tc_mode = "print"; $fn=24*4;
// tc_mode = "printSet"; $fn=24*4;
// tc_mode = "inspect";

tc_thinWallThickness         = 1;
tc_genWallThickness          = 3;
tc_strongWallThickness       = 9;

tc_horizontalSuportThickness = 0.35;
tc_verticalSupportThickness  = 0.5;


/*------------------------------------screw-------------------------------------*/
tc_s_diameter                = 3.6;
tc_s_nut_diameter            = 6.53;
tc_s_nut_heigth              = 2.3;
tc_s_nut_wallDist            = _wallDistFromDia(m3_nut_diameter);
tc_s_nut_diameter_horizontal = 6.1;

/*------------------------------------general---------------------------------*/
tc_length                    = 12;
tc_tabelHocke_thickness      = 1;
tc_tabelHock_depth           = 1.5;
tc_overall_height            = tc_tabelHocke_thickness + 2.66;


/*--------------------------------------+-------------------------------------*/
tc_edge_radius               = tc_s_diameter;

/******************************************************************************/
/*                                  INTERNAL                                  */
/******************************************************************************/

module TabelClamp() {
	difference() {
		union(){
			translate([-tc_length/2, 0, 0])
				cube(size=[tc_length, tc_s_nut_wallDist+tc_thinWallThickness, tc_overall_height], center=false);

			translate([-tc_length/2, -tc_tabelHock_depth, tc_overall_height- tc_tabelHocke_thickness])
				cube(size=[tc_length, tc_tabelHock_depth, tc_tabelHocke_thickness], center=false);
		}
		union(){
			translate([0,  tc_s_nut_wallDist/2, 0]){
				//nut
				translate([0, 0, tc_overall_height - tc_s_nut_heigth + OS])
					cylinder(r=m3_nut_diameter/2, h=tc_s_nut_heigth, center=false, $fn = 6);
				//screw
				translate([0, 0, -OS])
					cylinder(r=tc_s_diameter/2, h=tc_overall_height- tc_s_nut_heigth - tc_horizontalSuportThickness +OS, center=false);
			}
			for (i=[[-90,-1],[180,1]])
			translate([i[1]*tc_length/2, tc_s_nut_wallDist+tc_thinWallThickness, -OS])
				roundEdge(_a=i[0],_r=tc_edge_radius,_l=tc_overall_height+2*OS,_fn=24*4);
		}
	}
}



if (tc_mode == "inspect") {
	TabelClamp();
}


module tc_print() {
	translate([0, 0, tc_overall_height])
	mirror([0, 0, 1])
		TabelClamp();
}
if (tc_mode == "print") {
	tc_print();
}


module tc_printSet() {
	for (x=[-1,1])
	translate([x*(tc_length/2+0.4), 0, 0])
		for (y=[[0,1],[180,-1]])
		translate([0, y[1]*(tc_tabelHock_depth + 0.4), 0])
		rotate(a=y[0],v=Z)
			tc_print();
}
if (tc_mode == "printSet") {
	tc_printSet();
}