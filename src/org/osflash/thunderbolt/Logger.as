
import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.io.Commandline;
import org.osflash.thunderbolt.logging.LogInfo;
import org.osflash.thunderbolt.logging.LogLevel;
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

			var info:LogInfo =  new LogInfo(traceObject, fullClassWithMethodName, fileName, lineNumber);
			info.checkFrameGroup();

				
			if (String(traceObject).indexOf("+++") == 0){
			
				var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
			
				// open group	
				Console.group(message + (message ? " " : "") + "(" + fullClassWithMethodName + ")");
				
			} else if (traceObject == "---"){
				
				// close group
				 Console.groupEnd();
				
			} else {
	
	
				// switch between console actions: log, info, warn, error
				var logLevel:LogLevel = new LogLevel(traceObject);
	
				if (logLevel.messageModified){
									
					traceObject = logLevel.message;
				}
				
				if (info.objectType == "xml"){
					
					Console.group(info, traceObject);
					Console.dirxml(traceObject);
					Console.groupEnd();
									
				} else {
							
					// send trace to console
					Logger.callFirebug(logLevel.console, info, traceObject);
				}
			}
		}
	}
		
	private static function callFirebug(method:Function, infoObject:LogInfo, traceObject:Object){
		
		if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && method == Console.log) {
			
			Console.group(infoObject);;

			var lines:Array = traceObject.split("\n");
			
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