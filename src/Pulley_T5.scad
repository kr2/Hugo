// Belt pulley is http://www.thingiverse.com/thing:3104 by GilesBathgate
// GPLV3

include <metric.scad>

p_mode = "-"; 
//p_mode = "print"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)
//p_mode = "printSet"; $fn=24*4; // can be print or inspect [overlays the Xc_model with the original Xc_model] (uncomment next line)


motor_shaft = 5.5;


/**
 * @name Pulley
 * @category Printed
 * @using 1 m3nut
 * @using 1 m3x10
 */
module pulley()
{


	module spur()
	{
		linear_extrude(height=20) polygon([[-1,-1],[-1,1],[0.7,0.7],[0.7,-0.7]],[[0,1,2,3,0]]);
	}
	
 difference()
 {	 
 	union()
 	{
 		//base
 		rotate_extrude($fn=30)
 		{
 				square([9,8]);
 				square([10,7]);
 				translate([9,7]) circle(1);
 		}
    	
    	//shaft
    	cylinder(r=motor_shaft-0.2,h=20, $fn=8);
    	
    	//spurs
    	for(i=[1:8]) rotate([0,0,i*(360/8)])
    	translate([5.6,0,0])spur();
   }
   
   //shaft hole
    translate([0,0,-1])cylinder(r=motor_shaft/2+0.1,h=22,$fn=15);
    		
 	//captive nut and grub holes
    for(j=[1:1]) rotate([0,0,j*(360/3)])
	translate([0,20,4])rotate([90,0,0])
	union()
	{
		//entrance
		translate([0,-3,15]) cube([6,7,2.5],center=true);
		//nut
		translate([0,0,15]) rotate([0,0,30])cylinder(r=3.47,h=2.5,$fn=6,center =true);
		//grub hole
		translate([0,0,9]) cylinder(r=1.9,h=10);
	}

 }

   
}

/*------------------------------------assembly--------------------------------*/

module p_print() {
	pulley();
}

if (p_mode == "print") {
	p_print();
}


module p_printSet() {
	for (i=[-10.5,10.5]) 
	translate([i, 0, 0]) 
	pulley();
}

if (p_mode == "printSet") {
	p_printSet();
}


