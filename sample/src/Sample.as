import mx.utils.Delegate;


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
		this.init();
	}
	
	private function init():Void{
		
		for (var all in _root){
				
			_root[all].onRelease = function(){
				Sample.APP[this._name + "Test"]();
			};
		}
	}
	
	private function completeTest(){
		
		this.logTest();
		this.infoTest();
		this.warnTest();
		this.errorTest();
		this.dateTest();
		this.arrayTest();
		this.objectTest();
		this.xmlTest();
		this.movieclipTest();
		this.multilineTest();
		this.groupTest();
	}
	
	private function logTest():Void{
	
		trace("d This is a simple debug message.");	
	}
	
	private function infoTest():Void{
	
		trace("i An info icon will appear next to this line.");	
	}
	
	private function warnTest():Void{
	
		trace("w This warning message is highlighted.");	
	}
	
	private function errorTest():Void{
	
		trace("e Red and highlited error message.");	
	}
	
	private function dateTest():Void{
	
		trace(new Date());	
	}
	
	private function arrayTest():Void{
	
		trace([1, "2", "three", "IV", "101", {six:"seven"}]);	
	}
	
	private function objectTest():Void{
	
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
	}
	
	private function xmlTest():Void{
	
		trace(new XML("<parent><child id='first'>First Paragraph</child><child id='second'><subchild>Subchild text content</subchild></child></parent>"));
	}
	
	private function movieclipTest():Void{
	
		trace(_root);
	}
	
	private function groupTest():Void{
	
		trace("+++ manually grouped output");
		trace("these message was grouped");
		trace("... with this message");
		trace("---");	
	}
	
	private function multilineTest():Void{
	
		trace("multi \nline \rmessage");	
	}

}