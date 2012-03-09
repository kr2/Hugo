/* bom
 * Copyright (c) 2012 by Krallinger Sebastian [s.krallinger+cc@gmail.com]
 * Dual-licensed under 
 * Creative Commons Attribution-ShareAlike 3.0 (CC BY-SA) [http://creativecommons.org/licenses/by-sa/3.0/]
 * and
 * LGPL v2 or later [http://www.gnu.org/licenses/].
 */

bomOutput = true;
module bomEcho(name="Unknown", param=[["none",0]]) {
	if (bomOutput) {
		echo(str("[BOM]|", name,"|",param));
	}
}
	



