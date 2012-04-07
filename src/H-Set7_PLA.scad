/* set7-PLA
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

use <ToothedLinearBearing_v1.scad>


%cube(size=[150, 150, 1], center=true);

 $fn=24*4; 

outer_d = 19.3;
inner_d = 12;
height = 24;

for (x=[-1,1]) 
for (y=[-1,1]) 
translate([x*(outer_d/2+0.5), y*(outer_d/2+0.5), height/2]) 
	TLB_linearBearing(
						inner_d          = inner_d, 
						outer_d          = outer_d,
						h                = height,
						stringWidth      = 0.5,
						minWallThickness = 0.85, 
						tooths           = 24, 
						toothRatio       = 0.3
					);