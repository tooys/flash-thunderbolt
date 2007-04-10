
import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.data.LogInfo;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.io.Commandline;
/**

 * @author Martin Kleppe - http://labs.sumaato.net
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.03
 */
 
class org.osflash.thunderbolt.Logger {
	
	private static var initialized:Boolean = false;
	private static var _firebug:Object;

	private static function initialize():Void{
		
		Logger.initialized = true;	
		Commandline.initialize();
	}

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		if (!Logger.initialized){
			
			Logger.initialize();
		}
	
		// send traces to console only if Firebug is available
		if (Console.enabled){
				
			if (String(traceObject).indexOf("+++") == 0){
			
				var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
			
				// open group	
				Console.group(message + (message ? " " : "") + "(" + fullClassWithMethodName + ")");
				
			} else if (traceObject == "---"){
				
				// close group
				 Console.groupEnd();
				
			} else {
			
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
}