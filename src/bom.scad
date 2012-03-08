bomOutput = true;
module bomEcho(name="Unknown", param=[["none",0]]) {
	if (bomOutput) {
		echo(str("[BOM]|", name,"|",param));
	}
}
	



