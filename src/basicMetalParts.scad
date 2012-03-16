/* basicMetalParts
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <bom.scad>
include <units.scad>

module rod(r=10, h=20, center=true,info="-") {
	bomEcho("Rod",info,[["diameter",r*2],["length",h]]);
	color("Gray") {
		cylinder(r=r, h=h, center=center);
	}
}

module threadedRod(r=4, h=100, center=true,info="-") {
	bomEcho("threaded Rod",info,[["diameter",r*2],["length",h]]);
	threadDepth = 1;
	threadHeight = 0.5;

	color("Gray") 
		cylinder(r=r, h=h, center=center);

	*color("Gray") {
		cylinder(r=r - threadDepth, h=h, center=center);
		for (i=[0:0.5:h]) {
			if (center) {
				translate([0, 0, i-h/2]) 
					cylinder(r=r, h=threadHeight/2, center=true);
			} else {
				translate([0, 0, i]) 
					cylinder(r=r, h=threadHeight/2, center=true);
			}
		}
	}
}
//threadedRod();

module bear608ZZ(info="-") {
	bomEcho("Bearing 608ZZ",info,[]);
	difference() {
		union(){
			color("Gray")
			cylinder(r=11, h=7, center=false);
		}
		union(){
			color("Gray")
			translate([0, 0, -OS]) 
				cylinder(r=4, h=7+2*OS, center=false);
			color("LightGrey") 
			for (i=[0,7]) 
			translate([0, 0, i]) 
			difference() {
				cylinder(r=9.5, h=2, center=true);
				cylinder(r=5.5, h=2+2*OS, center=true);
			}
		}
	}
}
//bear608ZZ();

module table(size = [10,10,1],center = true,info="-") {
	bomEcho("Table",info,[["width",size[0]],["length",size[1]],["thickness",size[2]]]);
	color("Gainsboro")
	cube(size=size, center=center);
}
//table();