/* text.scad [txt]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

$fn=24;
txt_height = 8;
txt_width = 5;

txt_thickness = 0.1;

txt_z = 0.6;


module txt_hugo() {
	dist = 1;

	step = txt_width + dist;

	//mirror([1, 0, 0])  
	translate([-step*2 + dist/2, 0, 0]) {
		translate([step*0, 0, 0]) 
			_H();
		translate([step*1, 0, 0]) 
			_U();
		translate([step*2, 0, 0]) 
			_G();
		translate([step*3, 0, 0]) 
			_O();
	}
}
//txt_hugo();

module _O() {
	translate([0, 0, txt_z/2])  //!!!!!!!!
	intersection() {
		translate([txt_width/2, 0, 0]) 
			cube(size=[txt_width, txt_height, txt_z], center=true);
		
		union() {
			translate([txt_width/2, 0, 0]) 
			scale([1, txt_height/txt_width, 1]) 
			difference() {
				cylinder(r=txt_width/2, h=txt_z, center=true); 
				cylinder(r=txt_width/2- txt_thickness, h=txt_z + 2*0.001, center=true); 
			}
		}	
	}
}

module _G() {
	_r = txt_width*0.75;
	_scaly = (txt_height/2)/_r;
	translate([0, 0, txt_z/2])  //!!!!!!!!
	intersection() {
		translate([txt_width/2, 0, 0]) 
			cube(size=[txt_width, txt_height, txt_z], center=true);
		
		union() {
			translate([txt_width*0.75, 0, 0]) 
				cube(size=[txt_width/2, txt_thickness, txt_z], center=true);

			translate([_r, 0, 0]) 
			scale([1, _scaly, 1]) 
			difference() {
				cylinder(r=_r, h=txt_z, center=true);
				cylinder(r=_r - txt_thickness, h=txt_z + 2*0.001, center=true);
			}
			
			#translate([txt_width-txt_thickness, 0, -txt_z/2]) 
			mirror([0, 1, 0]) 
				cube(size=[txt_thickness, txt_height/2 * 0.93, txt_z], center=false); 
			
		}	
	}
}

module _U() {
	translate([0, 0, txt_z/2])  //!!!!!!!!
	intersection() {
		translate([txt_width/2, 0, 0]) 
			cube(size=[txt_width, txt_height, txt_z], center=true);
		
		union() {
			translate([txt_width/2, -txt_height/2 + txt_width/2, 0]) 
			difference() {
				cylinder(r=txt_width/2, h=txt_z, center=true);
				cylinder(r=txt_width/2 - txt_thickness, h=txt_z+2*0.001, center=true);					
				translate([0, txt_width/2, 0]) 
					cube(size=[txt_width + 2*0.001, txt_width, txt_z + 2* 0.001], center=true);
			}

			for (i=[txt_width - txt_thickness,0]) 
			translate([i, -txt_height/2 + txt_width/2, -txt_z/2])		
				cube(size=[txt_thickness, txt_height- txt_width/2, txt_z], center=false);
		}
	}
}


module _H() {
	translate([0, 0, txt_z/2]) //!!!!!!!!
	intersection() {
		translate([txt_width/2, 0, 0]) 
			cube(size=[txt_width, txt_height, txt_z], center=true);
		
		union() {
			translate([0, -txt_thickness/2, -txt_z/2]) 
				cube(size=[txt_width, txt_thickness, txt_z], center=false);
			for (i=[0,txt_width-txt_thickness]) 
			translate([i, -txt_height/2,- txt_z/2]) 
				cube(size=[txt_thickness, txt_height, txt_z], center=false);
		}
	}
}


module _R() {
	translate([0, 0, txt_z/2]) //!!!!!!!!
	intersection() {
	translate([txt_width/2, 0, 0]) 
	cube(size=[txt_width, txt_height, txt_z], center=true);
	
	union() {
		translate([txt_thickness/2, 0, 0]) 
		cube(size=[txt_thickness, txt_height , txt_z], center=true);


		translate([txt_width - txt_height/4, txt_height/4, 0]) 
		difference() {
			cylinder(r=txt_height/4, h=txt_z, center=true);
			cylinder(r=txt_height/4 - txt_thickness, h=txt_z+0.002, center=true);
			translate([-5, 0, 0]) 
				cube(size=[txt_width*2, txt_height*2, txt_z*2], center=true);
		}

		for (i=[0,txt_height/2- txt_thickness]) 
		translate([0, i, -txt_z/2]) 
			cube(size=[txt_width-txt_height/4 + 0.01, txt_thickness, txt_z], center=false);


		translate([txt_width-txt_height/4 - txt_thickness,0 , -txt_z/2]) 
		rotate(a=-atan((txt_height/2)/(txt_width-(txt_width-txt_height/4 - txt_thickness/2))),v=[0,0,1]) 	
			cube(size=[txt_height*5, txt_thickness, txt_z], center=false);
	}
}
}

module _K() {
	translate([0, 0, txt_z/2]) //!!!!!!!!
	intersection() {
	translate([txt_width/2, 0, 0]) 
	cube(size=[txt_width, txt_height, txt_z], center=true);
	
	union() {
		translate([txt_thickness/2, 0, 0]) 
		cube(size=[txt_thickness, txt_height , txt_z], center=true);
		
		translate([txt_thickness,0 , 0]) 
		rotate(a=atan((txt_height/2)/(txt_width-txt_thickness)),v=[0,0,1]) 	
			cube(size=[txt_height*5, txt_thickness, txt_z], center=true);

		translate([txt_thickness,0 , 0]) 
		rotate(a=-atan((txt_height/2)/(txt_width-txt_thickness)),v=[0,0,1]) 	
			cube(size=[txt_height*5, txt_thickness, txt_z], center=true);
	}
}
}

module _2() {
	translate([0, 0, txt_z/2]) //!!!!!!!!
	intersection() {
	translate([txt_width/2, 0, 0]) 
		cube(size=[txt_width, txt_height, txt_z], center=true);
	
	union() {
		translate([txt_width/2, -txt_height/2 + txt_thickness/2, 0]) 
			cube(size=[txt_width, txt_thickness , txt_z], center=true);

		translate([0, -txt_height/2, -txt_z/2]) 
		rotate(a=45,v=[0,0,1]) 
			cube(size=[txt_height*0.9, txt_thickness , txt_z], center=false);

		translate([txt_width/2, txt_height/2-txt_width/2, 0]) 
		difference() {
			cylinder(r=txt_width/2, h=txt_z, center=true);
			cylinder(r=txt_width/2 - txt_thickness, h=txt_z+0.002, center=true);

			translate([0, -5- txt_thickness, 0]) 
			rotate(a=-20,v=[0,0,1]) 
				cube(size=[10, 10, 10], center=true);
		}
	}
}

}