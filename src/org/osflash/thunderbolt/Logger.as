
import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.io.Console;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.io.Commandline;
import org.osflash.thunderbolt.logging.LogInfo;
import org.osflash.thunderbolt.logging.LogLevel;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.03
 */
 
class org.osflash.thunderbolt.Logger {
	
	private static var initialized:Boolean = false;

	private static function initialize():Void{
		
		Logger.initialized = true;	
		Commandline.initialize();
	}

	/**
	 * Compiling your project using the MTASC trace command will replace 
	 * all calls of trace by calls to your custom trace function 
	 * and will add more parameters that contains debug infos such as 
	 * full class name with method name, file name and line number 
	 */
	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		// check if Logger has been initialized
		if (!Logger.initialized){
			
			Logger.initialize();
		}
	
		// send traces to console 
		// but only if Firebug is available
		if (Console.enabled){

			// get more detailed information about current trace
			var info:LogInfo = new LogInfo(traceObject, fullClassWithMethodName, fileName, lineNumber);
			
			// check if movie has entered a new frame
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
	
				// check if message should be sliced									
				traceObject = logLevel.messageModified ? logLevel.message : traceObject;
				
				// start group for xml output
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