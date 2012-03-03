/*
 *  Copyright (C) 2012  Krallinger Sebastian
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License,
 *  LGPL version 2.1, or (at your option) any later version of the GPL.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
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

