/* H-BearingGuid [Hbg]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>;
include <metric.scad>


/*------------------------------------general---------------------------------*/
Hbg_mode = "-";
//Hbg_mode = "printSet";  $fn=24*4;    // can be print or inspect [overlays the Hbg_model with the original Hbg_model] (uncomment next line)
//Hbg_mode = "print";  $fn=24*4;
//Hbg_mode = "inspect";
//Hbg_mode = "assembly";

Hbg_thinWallThickness         = 1;
Hbg_genWallThickness          = 3;
Hbg_strongWallThickness       = 9;

Hbg_horizontalSuportThickness = 0.35;
Hbg_verticalSupportThickness = 0.5;


/*------------------------------------rod-------------------------------------*/
Hbg_rod_diam                 = m8_diameter;

/*------------------------------------bearing---------------------------------*/
Hbg_bear_diam                = bear_608ZZ_diam;

/*------------------------------------general---------------------------------*/

Hbg_diam                     = Hbg_bear_diam + 5;
Hbg_outer_height             = 0.5;
Hbg_inner_height             = 2;

Hbg_washer_height            = Hbg_horizontalSuportThickness;
Hbg_washer_diam              = Hbg_rod_diam + 4;

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
module H_BearingGuid() {
	difference() {
		union(){
			cylinder(r=Hbg_diam/2, h=Hbg_outer_height, center=false);

			translate([0, 0, Hbg_outer_height]) 
			cylinder(r1=Hbg_diam/2,r2 = Hbg_bear_diam/2, h=Hbg_inner_height- Hbg_outer_height, center=false);

			translate([0, 0, Hbg_inner_height]) 
				cylinder(r=Hbg_washer_diam/2, h=Hbg_washer_height, center=false);
		}
		union(){
			translate([0, 0, -OS]) 
				cylinder(r=Hbg_rod_diam/2, h=Hbg_inner_height+Hbg_washer_height + 2*OS, center=false);
		}
	}
}




if (Hbg_mode == "inspect") {
	H_BearingGuid();
}
module H_BearingGuid_print() {
	for (i=[-1,1]) 
	translate([i*(Hbg_diam/2 +0.5), 0, 0]) 
		H_BearingGuid();
}
module H_BearingGuid_printSet() {
	for (i=[-1:1]) 
	translate([(Hbg_diam/2+0.5)*i , i*(Hbg_diam*0.85+1), 0]) 
	H_BearingGuid_print();
}
if (Hbg_mode == "printSet") {
	H_BearingGuid_printSet();
}
if (Hbg_mode == "print") {
		H_BearingGuid_print();
}



/*------------------------------------assembly--------------------------------*/
include <basicMetalParts.scad>

module H_BearingGuid_ass() {
	translate([0, 0, -Hbg_washer_height- Hbg_outer_height]) 
		H_BearingGuid();
	translate([0, 0, bear_608ZZ_height + Hbg_outer_height + Hbg_washer_height ]) 
	rotate(a=180,v=X) 
		H_BearingGuid();
	
	bear608ZZ(info="bearing guid");

}
if (Hbg_mode == "assembly") {
	H_BearingGuid_ass();
}