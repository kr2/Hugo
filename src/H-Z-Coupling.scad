/* H-Z-Coupling [Zc]
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


/*------------------------------------general---------------------------------*/
Zc_mode = "-";
//Zc_mode = "printSet";  $fn=24*4;    // can be print or inspect [overlays the Zc_model with the original Zc_model] (uncomment next line)
//Zc_mode = "print";  $fn=24*4;
//Zc_mode = "inspect";
//Zc_mode = "assembly";

Zc_thinWallThickness         = 1;
Zc_genWallThickness          = 3;
Zc_strongWallThickness       = 9;

Zc_horizontalSuportThickness = 0.3;
Zc_verticalSupportThickness  = 0.5;


Zc_shaftNut_dist          = 5; // distance between end of motor shaft and the lower edge of the first nut
Zc_slot_width             = 2; 

/*------------------------------------rod-------------------------------------*/
Zc_rod_diam               = m8_diameter;
Zc_nut_diam               = m8_nut_diameter;
Zc_nut_height             = m8_nut_heigth;

/*------------------------------------motor-----------------------------------*/
Zc_motorShaft_diam        = 5;
Zc_motorShaftCover_length = 14;

/*------------------------------------screw-----------------------------------*/
Zc_screwHolde_diam        = m3_diameter;
Zc_screwNut_diam          = m3_nut_diameter;
ZC_screwNut_height        = m3_nut_heigth;
Zc_screwNut_clearency     = 1;

/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/
_Zc_overalHeight         = Zc_nut_height + Zc_shaftNut_dist + Zc_motorShaftCover_length;
_Zc_outer_r              = Zc_nut_diam/2+Zc_genWallThickness;

_Zc_slotYdirWall_offset  = Zc_slot_width/2 + Zc_motorShaft_diam/2 + Zc_genWallThickness;

_Zc_coutout_r            = _Zc_outer_r - _Zc_slotYdirWall_offset;
_Zc_zdirCutout_scale     = (Zc_motorShaftCover_length+Zc_shaftNut_dist/2)/_Zc_coutout_r;

_Zc_zdirTopCloseOf_scale = (Zc_genWallThickness)/_Zc_outer_r;

module H_Z_Coupling() {

	intersection() {
		difference() {
			union(){
				// upper oultine
				translate([0, 0, Zc_shaftNut_dist/2]) 
					cylinder(r=_Zc_outer_r, h=Zc_nut_height + Zc_shaftNut_dist/2 - Zc_genWallThickness, center=false);

				// upper close off
				translate([0, 0, Zc_shaftNut_dist+Zc_nut_height - Zc_genWallThickness]) 
				scale([1, 1, _Zc_zdirTopCloseOf_scale]) 
					sphere(r=_Zc_outer_r);

				// lower outline
				translate([0, 0, -Zc_motorShaftCover_length]) 
					cylinder(r1=Zc_motorShaft_diam/2 + Zc_thinWallThickness+Zc_screwHolde_diam+Zc_thinWallThickness, r2=_Zc_outer_r, h=Zc_motorShaftCover_length+Zc_shaftNut_dist/2, center=false);
			}
			union(){
				// material coutout
				translate([0, 0, -Zc_motorShaftCover_length]) 
				for (y=[-_Zc_outer_r,_Zc_outer_r]) 
				translate([0, y, 0]) 
				scale([1, 1, _Zc_zdirCutout_scale]) 
				rotate(a=90,v=Y) 
					cylinder(r=_Zc_coutout_r, h=5*Zc_nut_diam, center=true);

				// motorshaft
				translate([0, 0, -Zc_motorShaftCover_length-OS]) 
					cylinder(r=Zc_motorShaft_diam/2, h=Zc_motorShaftCover_length+2*OS, center=false);

				//zaxis
				cylinder(r=Zc_rod_diam/2, h=Zc_nut_height + Zc_shaftNut_dist +OS, center=false);

				// nut coutout
				translate([0, 0, Zc_shaftNut_dist]) 
					cylinder(r=m8_nut_diameter/2, h=Zc_nut_height+OS, center=false,$fn=6);

				// slot
				translate([0, 0, -Zc_motorShaftCover_length/2-OS]) 
				cube(size=[5*Zc_nut_diam, Zc_slot_width, Zc_motorShaftCover_length+OS], center=true);

				// screw holse
				translate([0, 0, -Zc_motorShaftCover_length+Zc_genWallThickness+Zc_screwNut_diam/2]) 
				for (x=[-Zc_motorShaft_diam/2-Zc_thinWallThickness- Zc_screwHolde_diam/2,Zc_motorShaft_diam/2 + Zc_thinWallThickness+Zc_screwHolde_diam/2]) {
					//screw holes
					translate([x, 0, 0]) 
					rotate(a=90,v=X)
						cylinder(r=Zc_screwHolde_diam/2, h=5*Zc_nut_diam, center=true); 

					// nuttrap
					translate([x, -Zc_nut_diam*2.5- _Zc_slotYdirWall_offset + ZC_screwNut_height , 0]) 
					rotate(a=90,v=X)
						cylinder(r=Zc_screwNut_diam/2, h=5*Zc_nut_diam, center=true,$fn=6); 

					// nut clearany
					translate([x, Zc_nut_diam*2.5+ _Zc_slotYdirWall_offset -ZC_screwNut_height/2, 0]) 
					rotate(a=90,v=X)
						cylinder(r=Zc_screwNut_diam/2 + Zc_screwNut_clearency, h=5*Zc_nut_diam, center=true); 
				}
			}
		}
		translate([-Zc_nut_diam*2.5, -Zc_nut_diam*2.5, -Zc_motorShaftCover_length]) 
			cube(size=[Zc_nut_diam*5, Zc_nut_diam*5, _Zc_overalHeight], center=false);
	}
	
	
}




if (Zc_mode == "inspect") {
	H_Z_Coupling();
}
module H_Z_Coupling_print() {
	H_Z_Coupling();
}
module H_Z_Coupling_printSet() {
	translate([0, 0, Zc_motorShaftCover_length]) {
		translate([-_Zc_outer_r - 1, 0, 0]) 
			H_Z_Coupling();
		translate([_Zc_outer_r + 1, 0, 0]) 
			H_Z_Coupling();
	}
}
if (Zc_mode == "printSet") {
	H_Z_Coupling_printSet();
}
if (Zc_mode == "print") {
	translate([0, 0, Zc_motorShaftCover_length]) 
		H_Z_Coupling();
}



/*------------------------------------assembly--------------------------------*/
module H_Z_Coupling_assembly() {
	H_Z_Coupling();
}


if (Zc_mode == "assembly"){
	H_Z_Coupling_assembly();
}
