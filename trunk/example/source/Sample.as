import mx.utils.Delegate;
import org.osflash.thunderbolt.profiling.Profiler;
import org.osflash.thunderbolt.profiling.ProfileHandle;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.io.Console;


/**
 * @author Martin Kleppe kleppe@gmail.com
 */
class Sample {

	public static var APP:Sample;
	
	private var profileObject:Object;
	
	// entry point
	public static function main(mc:MovieClip):Void {
		Sample.APP = new Sample();
	}
	
	function Sample() {
		
		this.init();
	}
	
	private function init():Void{
		
		trace(this);
		
		for (var all in _root){
				
			_root[all].onRelease = function(){
				Sample.APP[this._name.split("Button")[0] + "Test"]();
			};
		}
		
		this.profileObject = {
			
			method1: function(){
				
				var sum:Number = 0;
				for (var i:Number=0; i<1000; i++) { sum += i; }
				return sum;
			},
			
			method2: function(){
			
				var sum:Number = 0;
				for (var i:Number=0; i<1000; i++){ sum += this.method1(); }
				return sum;
			}
		};		
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
		
		this.profileTest();
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
		trace("these message has 'been' grouped");
		trace("... with \"another\" message");
		trace("---");	
	}
	
	private function multilineTest():Void{
	
		trace("multi \nline \rmessage");	
	}

	private function profileTest():Void{
	
		Profiler.start(this.profileObject);
		trace("+++ Test Run: " + this.profileObject.method2());
		var log:Array = Profiler.stop();
		
		for (var i:Number=0; i<log.length; i++) {
		
			trace(log[i]);
		};
		
		trace("---");
	}
	
	public function randomizeAlpha(value:Number):String{
	
		for (var all in _root){
				
			_root[all]._alpha = 100 - random(value);
		}
		
		return "Alpha randomized";
	}
	
	public function restoreAlpha():String{
	
		for (var all in _root){
				
			_root[all]._alpha = 100;
		}
		
		return "Alpha restored";
	}	

}