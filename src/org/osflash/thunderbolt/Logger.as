
import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.data.LogInfo;
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
			getURL('javascript:console.info("Thunderbolt External Interface enabled")');			
			
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
		
			getURL('javascript:console.info("Thunderbolt enabled")');
		}
	}

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		if (!Logger.initialized){
			
			Logger.initialize();
		}
	
		
		if (String(traceObject).indexOf("+++") == 0){
		
			var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
		
			// open group	
			getURL("javascript:console.group('" + message + (message ? " " : "") + "(" +fullClassWithMethodName + ")');");
			
		} else if (traceObject == "---"){
			
			// close group
			getURL("javascript:console.groupEnd();");
			
		} else {
		
			var out:String;
			
			// send traces to console only if Firebug is available
			if (Logger.firebug){

				var info:LogInfo =  new LogInfo(traceObject, fullClassWithMethodName, fileName, lineNumber);

				var objectType:String = info.objectType;
	
				// switch between console actions: log, info, warn, error
				var console:String = "log";
	
				if (objectType == "string" && traceObject.charAt(1) == " ") {
					
					switch (traceObject.charAt(0).toLowerCase()) {
					
						case "d": console = "log";		break;
						case "i": console = "info";		break;
						case "w": console = "warn";		break;
						case "e": console = "error";	break;
						case "f": console = "error";	break;
					}
					
					traceObject = String(traceObject).slice(2);
					
				} else if (objectType == "xml" || objectType == "xml"){
					
					console = "group";
				}
	
				out = Parser.stringify(traceObject);
							
				info.checkFrameGroup();
				
				// send trace to console
				Logger.callFirebug(console, info, out);
				
				if (objectType == "xml"){
	
					Logger.traceXML(XML(traceObject));
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
	
	private static function traceXML(xml:XML){
		
		var out = xml.toString().split('"').join('\\"');
	
		getURL("javascript:" +
			"var tbTempNode = document.createElement('xml');" +
			"tbTempNode.innerHTML = \"" + out + "\";" +
			"console.dirxml(tbTempNode.firstChild); "
		);
		
		getURL("javascript:console.groupEnd();");				
	}
	

	

	
	private static function callFirebug(method:String, infoObject:LogInfo, traceObject:Object){
		
		if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && method == "log") {
			
			// TODO: create javascript IO handler
			getURL("javascript:console.group(" + infoObject.toString() + ");");

			var lines:Array = traceObject.slice(1,-1).split("\n");
			
			for (var i:Number = 0; i < lines.length; i++){
				
				getURL('javascript:console.log("' + lines[i] + '")');		
			}

			getURL("javascript:console.groupEnd();");
			
		} else {
			
			// request javascript action
			getURL('javascript:console.' + method + '(' + infoObject + ',":",' + traceObject + ')');				
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