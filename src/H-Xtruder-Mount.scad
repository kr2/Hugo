/* H-Xtruder-Mount [Xm]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>
include <teardrop.scad>
include <roundEdges.scad>


/*------------------------------------general---------------------------------*/
Xm_mode = "-"; 
//Xm_mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//Xm_mode = "inspect";
//Xm_mode = "assembly";

Xm_outline           = [68, 33.1, 27.9];   // absolute Xm_outline [x,y,z]


Xm_extM_tabelThickness = 5.9;

Xm_extM_genWallThickness = 4;

Xm_ext_hole_diam = 4.4;
Xm_ext_hole_xoff = 50/2;
Xm_ext_hole_yoff = 20.55;

Xm_Zdir_edge_r = 15;

Xm_carr_hole_zoff = Xm_outline[2]/2;
Xm_carr_hole_xoff = 18/2;
Xm_carr_hole_dia = 4;

Xm_tchOuterWidth     = 7.3;
Xm_notchInnerWidth   = 5.4;
Xm_notchDepth        = 1.2;
Xm_notchLength       = 24 + 2.5;



module H_Xtruder_mount() {
	ext_cutout_r = Xm_ext_hole_yoff- Xm_extM_genWallThickness;
	ext_cutout_scal = (Xm_ext_hole_xoff-Xm_extM_genWallThickness*1.5)/ext_cutout_r;
	extM_remainingPeeksXdir = (Xm_outline[0]-ext_cutout_r*ext_cutout_scal*2)/2;

	// notch
	difference() {
		union(){		
			translate([Xm_outline[0]/2, -Xm_notchDepth/2 + OS, Xm_carr_hole_zoff])
				cube(size=[Xm_notchLength, Xm_notchDepth, Xm_notchInnerWidth], center=true);
			
			for (i=[1,-1]) 
			translate([Xm_outline[0]/2,  + OS, Xm_carr_hole_zoff+i*Xm_notchInnerWidth/2+Xm_notchDepth/2])
			rotate(a=-30,v=X) rotate(a=90,v=Y) 
				triangle(l=Xm_notchDepth,h=Xm_notchLength);
		}
		union(){
			// carr holes
			for (i=[-1,1]) 
			translate([Xm_outline[0]/2+i*Xm_carr_hole_xoff, -OS- Xm_notchDepth, Xm_carr_hole_zoff])
			rotate(a=-90,v=X) 
				cylinder(r=Xm_carr_hole_dia/2, h=Xm_extM_genWallThickness+2*OS, center=false,$fn=24); 
		}
	}
	

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	intersection() {
		cube(size=Xm_outline, center=false);
		
		difference() {
			union(){
				// z dir edges
				difference() {
					for (i=[Xm_Zdir_edge_r,Xm_outline[0]-Xm_Zdir_edge_r]) 
					translate([i, Xm_Zdir_edge_r, 0]) 
						cylinder(r=Xm_Zdir_edge_r, h=Xm_outline[2], center=false, $fn = 48);
					translate([Xm_Zdir_edge_r, 0, 0]) 
						cube(size=[Xm_outline[0]-2*Xm_Zdir_edge_r, Xm_outline[1], Xm_outline[2]], center=false);
					translate([0, Xm_Zdir_edge_r, 0]) 
						cube(size=[Xm_outline[0], Xm_outline[1]- Xm_Zdir_edge_r, Xm_outline[2]], center=false);
				}
				
				// conact plate carriage
				translate([Xm_Zdir_edge_r, 0, 0]) 
					cube(size=[Xm_outline[0]-2*Xm_Zdir_edge_r, Xm_extM_genWallThickness, Xm_outline[2]], center=false);

				// contact plate extruder
				translate([Xm_Zdir_edge_r, 0, 0]) 
					cube(size=[Xm_outline[0]-2*Xm_Zdir_edge_r, Xm_outline[1], Xm_extM_tabelThickness], center=false);
				translate([0, Xm_Zdir_edge_r, 0]) 
					cube(size=[Xm_outline[0], Xm_outline[1]- Xm_Zdir_edge_r, Xm_extM_tabelThickness], center=false);

				// y dir support
				for (i=[0,1])
				translate([i*(Xm_outline[0]-Xm_extM_genWallThickness), Xm_Zdir_edge_r, 0]) 
					cube(size=[Xm_extM_genWallThickness, Xm_outline[1]-Xm_Zdir_edge_r, Xm_outline[2]], center=false);

				_xdirSupport();
				
			}
			union(){
				// z dir edges
				difference() {
					for (i=[Xm_Zdir_edge_r,Xm_outline[0]-Xm_Zdir_edge_r]) 
					translate([i, Xm_Zdir_edge_r, Xm_extM_tabelThickness]) 
						cylinder(r=Xm_Zdir_edge_r - Xm_extM_genWallThickness, h=Xm_outline[2], center=false);
					_xdirSupport();
				}

				// ext cutout
				translate([Xm_outline[0]/2, Xm_ext_hole_yoff, -OS]) 
				scale([ext_cutout_scal, 1, 1])
					cylinder(r=ext_cutout_r, h=Xm_outline[2]+2*OS, center=false,,$fn=48);
				translate([Xm_outline[0]/2, Xm_ext_hole_yoff+(Xm_outline[1]-Xm_ext_hole_yoff)/2 +OS, Xm_extM_tabelThickness/2-OS]) scale([ext_cutout_scal, 1, 1]) 
					cube(size=[ext_cutout_r*2, abs((Xm_outline[1]-Xm_ext_hole_yoff))+OS, Xm_extM_tabelThickness+2*OS], center=true);

				// ext holder holes
				for (i=[-Xm_ext_hole_xoff,Xm_ext_hole_xoff]) {
					translate([Xm_outline[0]/2, Xm_ext_hole_yoff, -OS]) 
					translate([i, 0, 0]) 
						cylinder(r=Xm_ext_hole_diam/2, h=Xm_extM_tabelThickness+2*OS, center=false,$fn=24);
				}

				// support cutout
				translate([-OS, Xm_outline[1], Xm_outline[2]]) 
				rotate(a=90,v=Y)
				scale([1, 1.3, 1]) 
					cylinder(r=Xm_outline[2]-Xm_extM_tabelThickness, h=Xm_outline[0]+2*OS, center=false,$fn=48);

				// support rounded edges
				translate([0, 0, Xm_outline[2]]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=Xm_Zdir_edge_r*2,_l=Xm_outline[1],_fn=100);

				translate([Xm_outline[0], 0, Xm_outline[2]]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=90,_r=Xm_Zdir_edge_r*2,_l=Xm_outline[1],_fn=100);

				// hole peeks rounded edges
				translate([Xm_outline[0]/2 - (ext_cutout_r*ext_cutout_scal), Xm_outline[1], 0]) 
					roundEdge(_a=180,_r=extM_remainingPeeksXdir*0.9,_l=Xm_outline[1],_fn=100);
				translate([Xm_outline[0]/2 + (ext_cutout_r*ext_cutout_scal), Xm_outline[1], 0]) 
					roundEdge(_a=-90,_r=extM_remainingPeeksXdir*0.9,_l=Xm_outline[1],_fn=100);

				// carr holes
				for (i=[-1,1]) 
				translate([Xm_outline[0]/2+i*Xm_carr_hole_xoff, -OS, Xm_carr_hole_zoff])
				rotate(a=-90,v=X) 
					cylinder(r=Xm_carr_hole_dia/2, h=Xm_extM_genWallThickness+2*OS, center=false,$fn=24); 
				
			}
		}
		
	}	
}
module _xdirSupport() {
	zdirScale = (Xm_carr_hole_zoff- Xm_extM_tabelThickness)/(Xm_carr_hole_xoff+ Xm_carr_hole_dia*1.5);
	// reinfocment
	difference() {
		union(){
			translate([0, Xm_extM_genWallThickness, Xm_extM_tabelThickness]) 
			rotate(a=90,v=Y) 
				roundEdge(_a=90,_r=Xm_carr_hole_zoff- Xm_extM_tabelThickness,_l=Xm_outline[0]-Xm_extM_genWallThickness,_fn=4);
		}
		union(){
			roundEdge(_a=0,_r=Xm_Zdir_edge_r,_l=Xm_outline[2],_fn=100);
			translate([Xm_outline[0], 0, 0]) 
			roundEdge(_a=90,_r=Xm_Zdir_edge_r,_l=Xm_outline[2],_fn=100);
			
			translate([Xm_outline[0]/2, 0, Xm_carr_hole_zoff])
			scale([1, 1, zdirScale]) 
			rotate(a=-90,v=X) 
				cylinder(r=Xm_carr_hole_xoff+ Xm_carr_hole_dia*1.5, h=Xm_outline[1], center=false);
		}
	}
}

if (Xm_mode == "inspect") {
	H_Xtruder_mount();
}
module H_Xtruder_mount_print() {
	translate([-Xm_outline[1]/2, 0, 0]) 
	H_Xtruder_mount(isMotor=true);
}
if (Xm_mode == "print") 
	H_Xtruder_mount_print();


/*------------------------------------assembly--------------------------------*/

module H_Xtruder_mount_assembly() {
	rotate(a=180,v=Z) 
	rotate(a=180,v=Y) 
	translate([-Xm_outline[1], 0, -Xm_outline[2]/2]) 
	H_Xtruder_mount();
}

if (Xm_mode == "assembly"){
	H_Xtruder_mount_assembly();
}



module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}