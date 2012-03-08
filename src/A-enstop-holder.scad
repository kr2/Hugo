/* A-endstop-holder
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * original desing by abdrumm for the PrintrBot
 */

include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>


/*------------------------------------general---------------------------------*/
mode = "print";  // can be print or inspect [overlays the model with the original model] (uncomment next line)
//mode = "inspect";
//$fn=96;

genWallThickness           = 2.5;
strongWallThickness        = 5;

horizontalSuportThickness  = 0.3;
verticalSupportThickness   = 0.5;

/*------------------------------------rod-------------------------------------*/
rod_diam                   = 8.5;

/*------------------------------------enstop----------------------------------*/
end_height                 = 9;
end_wallWidth              = 4;
end_slotWidth              = rod_diam*0.7;
end_slotDepth              = 20.5;
end_clampHole_offset       = 15;
end_elongetatedHole_length = 10;
end_addLengthHole          = 5.5 + end_elongetatedHole_length;
end_edgeRadius             = 10; // availiable ony if perpendicular




// holeOffset is the distance form the center of the axis in the clamp to the center the hole
// nuttraps [clamp, switch connector]  0: off, -1 one side 1 other side
module A_endstop_holder(isPerpendicular= 1, holeOffset = [-34,14,5], nuttraps = [1,1]) {
	_end_edgeRadius = min(end_edgeRadius,(holeOffset[1]-3*genWallThickness));
	difference() {
		union(){	
			rotate(a=180,v=Z) 
				_clamp(holeOffset=holeOffset, nuttrap = nuttraps[0]);

			if (isPerpendicular == 0) {
				translate([-end_wallWidth/2, rod_diam/2, 0]) 
					cube(size=[end_wallWidth, holeOffset[1]-rod_diam/2+end_addLengthHole, end_height], center=false);
			}else{
				// normal side
				translate([-end_wallWidth/2, rod_diam/2, 0]) 
					cube(size=[end_wallWidth, holeOffset[1]-rod_diam/2+end_wallWidth/2, end_height], center=false);
				// Perpendicular sied
				if (holeOffset[0]>0) {
					translate([0, holeOffset[1]-end_wallWidth/2, ])
						cube(size=[holeOffset[0]+end_addLengthHole, end_wallWidth, end_height], center=false); 
				}else{
					translate([holeOffset[0]-end_addLengthHole, holeOffset[1]-end_wallWidth/2, ])
						cube(size=[abs(holeOffset[0])+end_addLengthHole, end_wallWidth, end_height], center=false); 
				}
				
			}

			// nuttrap outline
			if (nuttraps[1]!= 0) {
				for (i=[0:m3_nut_diameter/2:end_elongetatedHole_length]) 
				translate([holeOffset[0]+i*holeOffset[0]/abs(holeOffset[0]), holeOffset[1], end_height/2]) 
				rotate(a=90*isPerpendicular,v=Z)
				rotate(a=-90,v=Y)
				translate([0, 0, end_wallWidth/2*nuttraps[1]]) 
				rotate(a=30,v=Z) 
					cylinder(r=(end_height/2)/cos(30), h=m3_nut_heigth+OS, center=true,$fn=6);
			}

			//rounded edge
			if (isPerpendicular != 0) {
				if (holeOffset[0]>0) {
					translate([end_wallWidth/2, holeOffset[1]-end_wallWidth/2, 0]) 
						roundEdge(_a=-90,_r=_end_edgeRadius- end_wallWidth/2,_l=end_height,_fn=48);
				}else{
					translate([-end_wallWidth/2, holeOffset[1]-end_wallWidth/2, 0]) 
						roundEdge(_a=180,_r=_end_edgeRadius- end_wallWidth/2,_l=end_height,_fn=48);
				}
			}
			
		}
		union(){
			// switch screw hole and nuttrap
			translate([holeOffset[0], holeOffset[1], end_height/2]) 
			rotate(a=90*isPerpendicular,v=Z)
			rotate(a=-90,v=Y){
				

				
				difference() {
					union() {
						for (i=[0,end_elongetatedHole_length]) 
						translate([0, -i*holeOffset[0]/abs(holeOffset[0]), 0 ]) 
							cylinder(r=m3_diameter/2, h=end_wallWidth+2*OS, center=true,$fn=24);
						translate([0, end_elongetatedHole_length/2, -OS]) 
							cube(size=[  m3_diameter, end_elongetatedHole_length, end_wallWidth+2*OS], center=true);
					}
					union(){
						translate([0, end_elongetatedHole_length/2, -OS]) 
						for (i=[-end_elongetatedHole_length/2+m3_diameter/2:m3_diameter:end_elongetatedHole_length/2]) 
						translate([0, i, 0]) 
							cube(size=[  m3_diameter, verticalSupportThickness, end_wallWidth+2*OS], center=true);
					}
				}
				
				if (nuttraps[1]!= 0) {
					for (i=[0:m3_nut_diameter/2:end_elongetatedHole_length]) 
					translate([0, -i*holeOffset[0]/abs(holeOffset[0]), (end_wallWidth/2+OS)*nuttraps[1] ]) 
					rotate(a=30,v=Z) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth+OS, center=true,$fn=6);
				}	
			}

			if (isPerpendicular != 0) {
				if (holeOffset[0]>0) {
					translate([-end_wallWidth/2, holeOffset[1]+end_wallWidth/2, 0]) 
						roundEdge(_a=-90,_r=_end_edgeRadius+end_wallWidth/2,_l=end_height,_fn=48);
				}else{
					translate([end_wallWidth/2, holeOffset[1]+end_wallWidth/2, 0]) 
						roundEdge(_a=180,_r=_end_edgeRadius+ end_wallWidth/2,_l=end_height,_fn=48);
				}
			}
		}
	}

}

module _clamp(holeOffset,nuttrap) {
	difference() {
		union(){
			cylinder(r=rod_diam/2+end_wallWidth, h=end_height, center=false);
			// slot outline
			translate([-(end_slotWidth+2*end_wallWidth)/2, 0, 0]) 
			cube(size=[end_slotWidth+2*end_wallWidth, end_slotDepth, end_height], center=false);

			//nuttrap
			if (nuttrap != 0) {
				translate([0, end_clampHole_offset, end_height/2]) { // center screw hole
					translate([nuttrap * ((end_slotWidth)/2+end_wallWidth), 0, 0]) 
					rotate(a=90,v=Y) 
					rotate(a=30,v=Z) 
						cylinder(r=(end_height/2)/cos(30), h=m3_nut_heigth, center=true,$fn=6);
				}
			}
			

			// connector

			linear_extrude(height=end_height)
			rotate(a=-90,v=Z) 
				barbell(r1=(rod_diam+2*end_wallWidth)/2,r2=end_wallWidth/2,r3=end_wallWidth*4,r4=end_wallWidth*4,separation=min(end_edgeRadius,holeOffset[1]-3*genWallThickness));
		}
		union(){
			// rod coutout
			translate([0, 0, -OS]) 
			cylinder(r=rod_diam/2, h=end_height+2*OS, center=false);
			// slot coutout
			translate([-end_slotWidth/2, 0, -OS]) 
			cube(size=[end_slotWidth, end_slotDepth+OS, end_height+2*OS], center=false);

			
			translate([0, end_clampHole_offset, end_height/2]) { // center screw hole
				// clamp hole
				rotate(a=90,v=Y) 
					cylinder(r=m3_diameter/2, h=end_slotWidth+2*end_wallWidth+2*OS, center=true,$fn=24);
				if (nuttrap != 0) {
					// nuttrap
					translate([nuttrap * ((end_slotWidth)/2+end_wallWidth), 0, 0]) 
					rotate(a=90,v=Y) 
					rotate(a=30,v=Z) 
						cylinder(r=m3_nut_diameter/2, h=m3_nut_heigth+2*OS, center=true,$fn=6);
				}
			}
		}
	}
}
//_clamp();



if (mode == "inspect") {
	A_endstop_holder();
}
module A_endstop_print() {
	A_endstop_holder();
}
if (mode == "print") {
	A_endstop_print();
}
