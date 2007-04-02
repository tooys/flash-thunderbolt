

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
		
		trace("Sample Class initialized");
		this.init();
	}
	
	private function init():Void{
		
		var link:TextField = _root.main.head.link;
		
		link.onRelease = function(){
			
			getURL("http://code.google.com/p/flash-thunderbolt/", "_blank");
		}
		
		var infoText:TextField = _root.main.infoText;
		
		//check if firebug is enabled
		if (ThunderBolt.firebug){
			
			infoText.text = "Open your FireBug console to see the ThunderBolt traces.";							
			
			ThunderBolt.init();
			
		} else {
			
			infoText.htmlText = 'Please make sure <u><a href="http://www.getfirebug.com/" target="_blank">Firebug</a></u> is enabled!';
		}
			
		trace("Firebug is enabled: " + ThunderBolt.firebug);
		
		this.testTraceLevel();
		this.testObjectTypes();
		
	}
	
	private function testTraceLevel():Void{
		
		// simple traces
		trace("d This is a simple debug message.");
		trace("i An info icon will appear next to this line.");
		trace("w This warning message is highlighted.");
		trace("e Red and highlited error message.");		
	}
	
	private function testObjectTypes():Void{
		
		// trace undefined
		var unknown:Object;
		trace(unknown);
		
		// trace date
		trace(new Date());
		
		// object trace
		trace({
			a: "Hello",
			b: "World",
			c: {
				d: "Here",
				e: "We",
				f: {
					g: "Are"
				}
			}	
		});
		
		// array trace
		trace([1, "2", "three", "IV", "101", {six:"seven"}]);
		
		// trace movieclip
		trace(_root);
		
		// trace root
		trace(_root.main);			
	}


}