/* roundEdges
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */


//Rounded Edges
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
//roundEdge(_a=0,_l=10);

