//PRUSAMendel
//GNUGPLv2
//GregFrost

/**
*@categoryPrinted
*/

layer_height=0.4;
perimeter_w_over_t=2;

single_layer_width=layer_height*perimeter_w_over_t;
bearing_inner=22.2;

edge_thickness=layer_height*4;
slope_thickness=layer_height*3.1;
height=7+edge_thickness;
wall_ascent=5;
wall_descent=0.5;
tolerance=0.15;

module bearing_guide(inner_r=2)
{
	difference()
	{
		union()
		{
			cylinder(r=inner_r++single_layer_width,h=height);

			cylinder(r=bearing_inner/2+wall_ascent,h=edge_thickness);
			translate([0,0,edge_thickness-layer_height*0.1])
			cylinder(r1=bearing_inner/2+wall_ascent,
				r2=bearing_inner/2+single_layer_width+tolerance,
				h=slope_thickness);
		}
		translate([0,0,-1])
		cylinder(r=bearing_inner/2-wall_descent,h=edge_thickness+2);

		translate([0,0,edge_thickness])
		cylinder(r=inner_r,h=height);
	}
}

module inner()
{
	bearing_guide(inner_r=bearing_inner/2+tolerance);
}

module outer()
{
	bearing_guide(inner_r=bearing_inner/2+single_layer_width+2*+tolerance);
}


module bearGuid_ass() {
	inner();

	translate([0,0,3.5+height])
	rotate(a=180,v=[1,0,0]) 
	outer();

}
bearGuid_ass();

inner();

translate([34,0,0])
outer();
