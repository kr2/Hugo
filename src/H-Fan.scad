/* H-Fan [f]
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

include <config.scad>
include <units.scad>;
include <metric.scad>
include <roundEdges.scad>
include <utilities.scad>
include <barbell.scad>
use <teardrop.scad>


/*------------------------------------general---------------------------------*/
f_mode = "-";  
//f_mode = "print";  $fn=24*4;  // can be print or inspect [overlays the Ybd_model with the original Ybd_model] (uncomment next line)
f_mode = "inspect";
//f_mode = "assembly";

f_thinWallThickness          = 0.9;
f_genWallThickness           = 2.5;
f_strongWallThickness        = 10;

f_horizontalSuportThickness  = 0.3;
f_verticalSupportThickness   = 0.5;


/******************************************************************************/ 
/*                                  INTERNAL                                  */
/******************************************************************************/

module H_Fan() {
	

}




if (f_mode == "inspect") {
	H_Fan();
}
module H_Fan_print() {
	H_Fan();
}
if (f_mode == "print") {
	H_Fan_print();
}




/*------------------------------------assembly--------------------------------*/
module H_Fan_assembly() {
	H_Fan();
}

if (f_mode == "assembly"){
	H_Fan_assembly();
}