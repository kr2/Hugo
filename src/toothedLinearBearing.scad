/* toothedLinearBearing
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * GPL v2 or later [http://www.gnu.org/licenses/].
 */
include <units.scad>
 

/**
* @brief   Toothed Linear Bearing (TLB).
* 
* Linear Bearing with parallel triagnles towards the center.
* @param  inner_d   	Inner diameter (Axis Diameter)
* @param  outer_d   	outer diameter (holder Diameter)
* @param  h   			height
* @param  stringWidth   width of an single string of your printer (this defines the width of the tooth walls)
* @param  minWallThickness   minimum thickness of the outer wall. 
* @param  tooths   		number of toohts on the innside
* @param  toothRatio   	coverd length of the inner ring
**/ 
module TLB_linearBearing(
							inner_d          = 8, 
							outer_d          = 15,
							h                = 24,
							stringWidth      = 0.5,
							minWallThickness = 0.85, 
							tooths           = 16, 
							toothRatio       = 0.25
						) {
	
	stringWidth          = stringWidth; //!< the layer width of one string
	
	TLB_innerD           = inner_d;
	TLB_outerD           = outer_d;
	TLB_minWallThickness = minWallThickness;
	TLB_h                = h;
	TLB_tooths           = tooths;
	
	TLB_toothRate        = toothRatio;
	
	
	gapWidth             = (TLB_innerD*PI)/TLB_tooths *TLB_toothRate;
	//echo(str("gap Width: ", gapWidth));
	middR                = TLB_outerD/2- TLB_minWallThickness;
	
	//outer ring
	difference() {
		cylinder(r=TLB_outerD/2, h=TLB_h, center=true);
		cylinder(r=middR, h=TLB_h+2*OS, center=true);
	}
	

	difference() {
		union(){
			cylinder(r=TLB_innerD/2 + stringWidth, h=TLB_h, center=true);

			for (i=[0:360 / TLB_tooths : 360]) {
				rotate(a=i,v=Z) translate([-(gapWidth+2*stringWidth)/2, 0, -TLB_h/2])
					cube(size=[gapWidth+2*stringWidth, middR+OS, TLB_h], center=false);
			}
		}
		union(){
			cylinder(r=TLB_innerD/2, h=TLB_h+2*OS, center=true);
			
			for (i=[0:360 / TLB_tooths : 360]) {
				rotate(a=i,v=Z) translate([-gapWidth/2, 0, -TLB_h/2-OS]) 
					cube(size=[gapWidth, middR, TLB_h+2*OS], center=false);
			}
		}
	}

}

module TLB_test() {
	TLB_linearBearing(
							inner_d          = 8, 
							outer_d          = 15,
							h                = 24,
							stringWidth      = 0.5,
							minWallThickness = 0.85, 
							tooths           = 16, 
							toothRatio       = 0.25
						);
	translate([30, 0, 0]) 
	TLB_linearBearing(
							inner_d          = 8, 
							outer_d          = 20,
							h                = 12,
							stringWidth      = 0.5,
							minWallThickness = 3, 
							tooths           = 4, 
							toothRatio       = 0.25
						);

	translate([60, 0, 0]) 
	TLB_linearBearing(
							inner_d          = 12, 
							outer_d          = 26,
							h                = 6,
							stringWidth      = 1.5,
							minWallThickness = 3, 
							tooths           = 7, 
							toothRatio       = 0.6
						);
}
//TLB_test();


module TLB_print(s = 4) {
	$fn =100;
	dist = 2;
	translate([-s*(15+dist)/2-15/2, -s*(15+dist)/2, 0]) 
	for (x=[1:s]) {
		for (y=[1:s]) {
			if (y%2) {
				translate([x*(15+ dist)+15/2, y*(15*4/5 +dist), 0]) 
					TLB_linearBearing(
							inner_d          = 8, 
							outer_d          = 15,
							h                = 24,
							stringWidth      = 0.5,
							minWallThickness = 0.85, 
							tooths           = 16, 
							toothRatio       = 0.25);
			}else{
				translate([x*(15 +dist) -dist/2, y*(15*4/5 +dist), 0]) 
					TLB_linearBearing(
							inner_d          = 8, 
							outer_d          = 15,
							h                = 24,
							stringWidth      = 0.5,
							minWallThickness = 0.85, 
							tooths           = 16, 
							toothRatio       = 0.25);
			}
		}
	}
}
//TLB_print(s = 4);