/* H-Y-BeltClamp_Alternativ [Ybdaa]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <units.scad>
include <utilities.scad>
include <metric.scad>

include <roundEdges.scad>



/*------------------------------------general---------------------------------*/
Ybda_mode = "-";
//Ybda_mode = "print";  $fn=24*4;   // can be print or inspect [overlays the Ybda_model with the original Ybda_model] (uncomment next line)
//Ybda_mode = "printSet";  $fn=24*4; 
//Ybda_mode = "inspect";
//Ybda_mode = "assembly";


Ybda_thinWallThickness   = 1;
Ybda_genWallThickness    = 2.5;
Ybda_strongWallThickness = 10;

Ybda_reinforcement_r = 4;

/*------------------------------------belt------------------------------------*/
Ybda_belt_thickness      = 2.5;
Ybda_belt_width          = 6;
Ybda_belt_teethDist      = 5;
Ybda_belt_teethDepth     = 1.5;
Ybda_belt_topOffset      = 14.6;  // from top plate to the top edge of the belt
Ybda_belt_tolerance      = [2,1]; //w,t

/*------------------------------------zip ties--------------------------------*/
Ybda_zipTies_width       = 4;
Ybda_zipTies_thickness   = 2;


/*------------------------------------internal--------------------------------*/
_Ybda_base_size = [Ybda_genWallThickness*2+ Ybda_belt_thickness*2 + Ybda_belt_tolerance[1]*2 + m3_nut_diameter*2 + 2* Ybda_thinWallThickness,
				   Ybda_strongWallThickness,
				   Ybda_genWallThickness+m3_nut_heigth];

_Ybda_clamp_heigt = Ybda_belt_topOffset + Ybda_belt_width + Ybda_belt_tolerance[1] + Ybda_zipTies_width + 2*Ybda_genWallThickness;

module H_yBeltClam_alt() {
	difference() {
		union(){	
			for (i=[-(_Ybda_base_size[0]-Ybda_strongWallThickness)/2, (_Ybda_base_size[0]-Ybda_strongWallThickness)/2]){
				translate([i, 0, 0]) 
				cylinder(r=_Ybda_base_size[1]/2, h=_Ybda_base_size[2], center=false);
			}

			translate([0, 0, _Ybda_base_size[2]/2]) 
			cube(size=_Ybda_base_size- [_Ybda_base_size[1],0,0], center=true);

			for (i=[-1,+1]) {
				// outer clamp
				translate([(Ybda_belt_thickness+Ybda_genWallThickness/2) * i, 0, _Ybda_clamp_heigt/2]) 
					cube(size=[Ybda_genWallThickness, Ybda_strongWallThickness, _Ybda_clamp_heigt], center=true);

				// belt teeth conector
				for (y=[-Ybda_strongWallThickness/2+ Ybda_belt_teethDist/2:Ybda_belt_teethDist:Ybda_strongWallThickness/2- Ybda_belt_teethDepth/2]) 
				translate([(Ybda_belt_thickness- Ybda_belt_teethDepth/2) * i, y, _Ybda_clamp_heigt/2])
					cube(size=[Ybda_belt_teethDepth, Ybda_belt_teethDist/2, _Ybda_clamp_heigt], center=true); 
			}

			for (i=[[-1,90],[1,0]]) 
			translate([(Ybda_belt_thickness+Ybda_genWallThickness)*i[0],_Ybda_base_size[1]/2, _Ybda_base_size[2]]) 
			rotate(a=90,v=X) 
			 roundEdge(_a=i[1],_r=Ybda_reinforcement_r,_l=_Ybda_base_size[1],_fn=48*2);
		}
		union(){	
			for (i=[-(_Ybda_base_size[0]-Ybda_strongWallThickness)/2, (_Ybda_base_size[0]-Ybda_strongWallThickness)/2])
			translate([i, 0, 0]) {
				translate([0, 0, -OS]) 
					cylinder(r=m3_diameter/2, h=_Ybda_base_size[2]+2*OS, center=false);

				translate([0, 0, _Ybda_base_size[2]-m3_nut_heigth+OS]) 
					cylinder(r=m3_nut_diameter/2, h=_Ybda_clamp_heigt, center=false,$fn=6);
			}

			//zip tie coutout
			translate([0, 0, _Ybda_clamp_heigt- Ybda_thinWallThickness - Ybda_zipTies_width/2]) {
				difference() {
				
					cylinder(r=Ybda_strongWallThickness, h=Ybda_zipTies_thickness+2*OS, center=true);
					cylinder(r=distance1D(Ybda_strongWallThickness/2,Ybda_belt_thickness+Ybda_genWallThickness)- Ybda_zipTies_thickness/2, h=Ybda_zipTies_width, center=true);
				}
			}
		}
	}

}


if (Ybda_mode == "inspect") {
	H_yBeltClam_alt();
}


module H_yBeltClam_alt_print() {
	for (i=[-Ybda_strongWallThickness/2-0.5,+Ybda_strongWallThickness/2+0.5]) 
	translate([0, i, 0]) 
	H_yBeltClam_alt();
}
if (Ybda_mode == "printSet") {
	H_yBeltClam_alt_print();
}