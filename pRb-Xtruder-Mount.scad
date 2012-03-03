/* pRb-Xtruder-Mount
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>
use <teardrop.scad>
use <pRb-X-End.scad>


/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";

outline           = [68, 33.1, 27.9];   // absolute outline [x,y,z]


extM_tabelThickness = 5.9;

extM_genWallThickness = 4;

ext_hole_diam = 4.4;
ext_hole_xoff = 50/2;
ext_hole_yoff = 20.55;

Zdir_edge_r = 15;

carr_hole_zoff = outline[2]/2;
carr_hole_xoff = 18/2;
carr_hole_dia = 4;

tchOuterWidth     = 7.3;
notchInnerWidth   = 5.4;
notchDepth        = 1.2;
notchLength       = 24 + 2.5;



module pb_Xtruder_mount() {
	ext_cutout_r = ext_hole_yoff- extM_genWallThickness*2;
	ext_cutout_scal = (ext_hole_xoff-extM_genWallThickness*1.5)/ext_cutout_r;
	extM_remainingPeeksXdir = (outline[0]-ext_cutout_r*ext_cutout_scal*2)/2;

	// notch
	difference() {
		union(){		
			translate([outline[0]/2, -notchDepth/2 + OS, carr_hole_zoff])
				cube(size=[notchLength, notchDepth, notchInnerWidth], center=true);
			
			for (i=[1,-1]) 
			translate([outline[0]/2,  + OS, carr_hole_zoff+i*notchInnerWidth/2+notchDepth/2])
			rotate(a=-30,v=X) rotate(a=90,v=Y) 
				triangle(l=notchDepth,h=notchLength);
		}
		union(){
			// carr holes
			for (i=[-1,1]) 
			translate([outline[0]/2+i*carr_hole_xoff, -OS- notchDepth, carr_hole_zoff])
			rotate(a=-90,v=X) 
				cylinder(r=carr_hole_dia/2, h=extM_genWallThickness+2*OS, center=false,$fn=24); 
		}
	}
	

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	intersection() {
		cube(size=outline, center=false);
		
		difference() {
			union(){
				// z dir edges
				difference() {
					for (i=[Zdir_edge_r,outline[0]-Zdir_edge_r]) 
					translate([i, Zdir_edge_r, 0]) 
						cylinder(r=Zdir_edge_r, h=outline[2], center=false, $fn = 48);
					translate([Zdir_edge_r, 0, 0]) 
						cube(size=[outline[0]-2*Zdir_edge_r, outline[1], outline[2]], center=false);
					translate([0, Zdir_edge_r, 0]) 
						cube(size=[outline[0], outline[1]- Zdir_edge_r, outline[2]], center=false);
				}
				
				// conact plate carriage
				translate([Zdir_edge_r, 0, 0]) 
					cube(size=[outline[0]-2*Zdir_edge_r, extM_genWallThickness, outline[2]], center=false);

				// contact plate extruder
				translate([Zdir_edge_r, 0, 0]) 
					cube(size=[outline[0]-2*Zdir_edge_r, outline[1], extM_tabelThickness], center=false);
				translate([0, Zdir_edge_r, 0]) 
					cube(size=[outline[0], outline[1]- Zdir_edge_r, extM_tabelThickness], center=false);

				// y dir support
				for (i=[0,1])
				translate([i*(outline[0]-extM_genWallThickness), Zdir_edge_r, 0]) 
					cube(size=[extM_genWallThickness, outline[1]-Zdir_edge_r, outline[2]], center=false);

				
			}
			union(){
				// z dir edges
				for (i=[Zdir_edge_r,outline[0]-Zdir_edge_r]) 
				translate([i, Zdir_edge_r, extM_tabelThickness]) 
					cylinder(r=Zdir_edge_r - extM_genWallThickness, h=outline[2], center=false);

				// ext cutout
				translate([outline[0]/2, ext_hole_yoff, -OS]) scale([ext_cutout_scal, 1, 1])
					cylinder(r=ext_cutout_r, h=extM_tabelThickness+2*OS, center=false,,$fn=48);
				translate([outline[0]/2, ext_hole_yoff+(outline[1]-ext_hole_yoff)/2 +OS, extM_tabelThickness/2-OS]) scale([ext_cutout_scal, 1, 1]) 
					cube(size=[ext_cutout_r*2, abs((outline[1]-ext_hole_yoff))+OS, extM_tabelThickness+2*OS], center=true);

				// ext holder holes
				for (i=[-ext_hole_xoff,ext_hole_xoff]) {
					translate([outline[0]/2, ext_hole_yoff, -OS]) 
					translate([i, 0, 0]) 
						cylinder(r=ext_hole_diam/2, h=extM_tabelThickness+2*OS, center=false,$fn=24);
				}

				// support cutout
				translate([-OS, outline[1], outline[2]]) 
				rotate(a=90,v=Y)
				scale([1, 1.3, 1]) 
					cylinder(r=outline[2]-extM_tabelThickness, h=outline[0]+2*OS, center=false,$fn=48);

				// support rounded edges
				translate([0, 0, outline[2]]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=0,_r=Zdir_edge_r*2,_l=outline[1],_fn=100);

				translate([outline[0], 0, outline[2]]) 
				rotate(a=-90,v=X) 
					roundEdge(_a=90,_r=Zdir_edge_r*2,_l=outline[1],_fn=100);

				// hole peeks rounded edges
				translate([outline[0]/2 - (ext_cutout_r*ext_cutout_scal), outline[1], 0]) 
					roundEdge(_a=180,_r=extM_remainingPeeksXdir*0.9,_l=outline[1],_fn=100);
				translate([outline[0]/2 + (ext_cutout_r*ext_cutout_scal), outline[1], 0]) 
					roundEdge(_a=-90,_r=extM_remainingPeeksXdir*0.9,_l=outline[1],_fn=100);

				// carr holes
				for (i=[-1,1]) 
				translate([outline[0]/2+i*carr_hole_xoff, -OS, carr_hole_zoff])
				rotate(a=-90,v=X) 
					cylinder(r=carr_hole_dia/2, h=extM_genWallThickness+2*OS, center=false,$fn=24); 
				
			}
		}
		
	}
	
}

if (mode == "inspect") {
	*translate([outline[0]/2, outline[1]/2, 0]) 
		%import_stl("pb-Xtruder-Mount.stl", convexity = 5);

	translate([-26.5/2+ outline[0]/2, -15/2-2.5, outline[2]/2])  rotate(a=90,v=Z)  rotate(a=90,v=X) 
		%import_stl("xCarriage.stl", convexity = 5);
	pb_Xtruder_mount();

	translate([0, -2, 41.712 -7]) 
	rotate(a=180,v=X) 
	rotate(a=90,v=Z) 
	%pb_x_End(isMotor=true);

	translate([outline[0], -2, 41.712 -7]) 
	rotate(a=180,v=X) 
	rotate(a=90,v=Z) 
	mirror([0, 1, 0]) 
		%pb_x_End(isIdle=true);

	translate([outline[0]/2, -45, 4.5]) 
		%cube(size=[200, 6, 2], center=true);

	translate([93, -45, 20]) 
	rotate(a=90,v=X) 
		%cylinder(r=11, h=8, center=true);

}
module pb_Xtruder_mount_print() {
	translate([-outline[1]/2, 0, 0]) 
	pb_Xtruder_mount(isMotor=true);
}
if (mode == "print") 
	pb_Xtruder_mount_print();




module roundEdge(_a=0,_r=1,_l=1,_fn=100){
	rotate (a=[0,0,_a]){
		translate(v=[_r,_r,0]){
			rotate (a=[0,0,0]) rotate (a=[0,0,180]){
				difference() {
					translate (v=[-OS/2,-OS/2,-OS/2])
						cube (size = [_r+OS,_r+OS,_l+OS],center=false );
					translate (v=[0,0,-OS*2/2])
						cylinder (h = _l+OS*2, r=_r, center = false, $fn=_fn);
				}
			}
		}
	}
}

module triangle(l,h){
	translate(v=[2*l/3,0,0]) rotate (a=180, v=[0,0,1])
	cylinder(r=2*l/3,h=h,center=true,$fn=3);
}