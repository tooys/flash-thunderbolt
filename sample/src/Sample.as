

/**
 * @author Martin Kleppe kleppe@gmail.com
 */
class Sample {

	private static var classes:Array = [ThunderBolt];

	public static var APP:Sample;

	// entry point
	public static function main(mc:MovieClip):Void {
		Sample.APP = new Sample();
	}
	
	function Sample() {
		this.init();
	}
	
	private function init():Void{
		
		// Generate some visual output
		var tf:TextField = _root.createTextField("tf",0,0,0,400,200);
		tf.text = "Open your firebug console to see the thunderbold traces!";
		

		//check if firebug is enabled
		
		if (!ThunderBolt.enabled){
			
			tf.html = true;
			tf.htmlText = 'Please make sure <u><a href="http://www.getfirebug.com/" target="_blank">Firebug</a></u> is enabled!';
		}
		
		// simple traces
		trace("d This is a simple debug message.");
		trace("i An info icon will appear next to this line.");
		trace("w This warning message is highlighted.");
		trace("e Red and highlited error message.");
		
		// trace undefined
		var unknown;
		trace(unknown);
		
		// object trace
		var obj:Object = {
			a: "Hello",
			b: "World",
			c: {
				d: "Here",
				e: "We",
				f: {
					g: "Are"
				}
			}	
		};
		
		trace(obj);
		
		// array trace
		var arr:Array = [1, "2", "three", "IV", "101", {six:"seven"}];
		trace(arr);
		
		
		// movieclip trace
		
		var mc1:MovieClip = _root.createEmptyMovieClip("mc1", 1);
		var mc2:MovieClip = mc1.createEmptyMovieClip("mc2",1);
		
		trace(mc1);
		
	}


}