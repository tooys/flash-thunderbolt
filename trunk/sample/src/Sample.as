

/**
 * @author Martin Kleppe kleppe@gmail.com
 */
class Sample {

	public static var APP:Sample;
	

	// entry point
	public static function main(mc:MovieClip):Void {
		Sample.APP = new Sample();
	}
	
	function Sample() {
		
		trace("Sample Class initialized");
		trace(this);
		this.init();
	}
	
	private function init():Void{
		
		var link:TextField = _root.main.head.link;
		
		link.onRelease = function(){
			
			getURL("http://code.google.com/p/flash-thunderbolt/", "_blank");
		}
		
		var infoText:TextField = _root.main.infoText;
		
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

		// array trace
		trace([1, "2", "three", "IV", "101", {six:"seven"}]);
		
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
		
		trace("multi \nline \rmessage");	
		
		trace("Spéciâl chäráctêrs wíth \t tabs, \"inline quotes\" and ' slashes \\ ... ");
		trace('" ... /  \\ ');

		trace(new XML("<parent><child id='first'>First Paragraph</child><child id='second'><subchild>Subchild text content</subchild></child></parent>"));
		
		trace("+++ manually grouped output");
		trace("these message was grouped");
		trace("... with this message");
		trace("---");
		
		// trace movieclip
		trace(_root);
		
		// trace root
		trace(_root.main);				

	}


}