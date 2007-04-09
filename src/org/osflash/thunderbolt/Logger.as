
import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.data.LogInfo;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.data.StringyfiedObject;
/**

 * @author Martin Kleppe - http://labs.sumaato.net
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.03
 */
 
class org.osflash.thunderbolt.Logger {
	
	private static var initialized:Boolean = false;
	private static var _firebug:Object;
	private static var externalInitialized:Boolean = false;
	
	private static var lastFrame:Number = 0;
	
	private var groupStarted:Boolean;
	
	public static function initExternalInterface():Void{
		
		if (!Logger.externalInitialized){
		
			ExternalInterface.addCallback("inspect", Logger, Logger.inspect);
			ExternalInterface.addCallback("set", Logger, Logger.setAttribute);
			ExternalInterface.addCallback("run", Logger, Logger.run);
			Console.info("Thunderbolt External Interface enabled");			
			
		} else {
			
			Logger.externalInitialized = true;
		}
	}
	
	private static function initialize():Void{
		
		Logger.initialized = true;	
		
		Logger.initExternalInterface();
		
		Logger._firebug = ExternalInterface.call("function(){ return console && console.firebug}", true);
		
		// check if Fibebug is available
		if (Logger.firebug){
		
			Console.info("Thunderbolt enabled", Logger.firebug);
		}
	}

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		if (!Logger.initialized){
			
			Logger.initialize();
		}
	
		if (String(traceObject).indexOf("+++") == 0){
		
			var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
		
			// open group	
			Console.group(message + (message ? " " : "") + "(" + fullClassWithMethodName + ")");
			
		} else if (traceObject == "---"){
			
			// close group
			 Console.groupEnd();
			
		} else {
		
			// send traces to console only if Firebug is available
			if (Logger.firebug){

				var info:LogInfo =  new LogInfo(traceObject, fullClassWithMethodName, fileName, lineNumber);

				var objectType:String = info.objectType;
	
				// switch between console actions: log, info, warn, error
				var console:Function = Console.log;
	
				if (objectType == "string" && traceObject.charAt(1) == " ") {
					
					switch (traceObject.charAt(0).toLowerCase()) {
					
						case "d": console = Console.log;		break;
						case "i": console = Console.info;		break;
						case "w": console = Console.warn;		break;
						case "e": console = Console.error;		break;
						case "f": console = Console.error;		break;
					}
					
					traceObject = String(traceObject).slice(2);
					
				} 
				
				info.checkFrameGroup();
				
				if (objectType == "xml"){
					
					Console.group(info, traceObject);
					Console.dirxml(traceObject);
					Console.groupEnd();
									
				} else {
							
					// send trace to console
					Logger.callFirebug(console, info, traceObject);
				}
			}
		}
	}
		
	private static function inspect(target:String):Void{
		
		var out = _global[target] || _root[target] || eval(target);
		trace(out);	
	}


	private static function run(expression:String):Void{
		
		trace(eval(expression));
	}
	
	private static function setAttribute(target:String, value:String):Void{
			
		var parts = target.split(".");
		
		var property = parts.pop();
		target = parts.join(".");

		var object:Object = _global[target] || _root[target] || eval(target);
		object[property] = value;
		
		trace(object);
		
	}	
	
	
	private static function callFirebug(method:Function, infoObject:LogInfo, traceObject:Object){
		
		if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && method == Console.log) {
			
			Console.group(infoObject);;

			var lines:Array = traceObject.slice(1,-1).split("\n");
			
			for (var i:Number = 0; i < lines.length; i++){
				
				Console.log(lines[i]);		
			}

			Console.groupEnd();
			
		} else {
			
			// request javascript action
			method(infoObject, new StringyfiedObject(traceObject));				
		}

	}
	
	public static function get firebug(Void):Object{

		// get the firebug version via ExternalInterface
		// at the first time it is requested
		
		if (!Logger.initialized){

			Logger.initialize();
		}
		
		return Logger._firebug;
	}
}