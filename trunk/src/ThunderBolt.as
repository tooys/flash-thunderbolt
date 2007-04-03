
import flash.external.ExternalInterface;
/**

 * @author Martin Kleppe - http://labs.sumaato.net
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.1
 */
 
class ThunderBolt {
	
	private static var initialized:Boolean = false;
	private static var _firebug:Object;
	private static var externalInitialized:Boolean = false;
	
	public static function init():Void{
		
		if (!ThunderBolt.externalInitialized){
		
			ExternalInterface.addCallback("inspect", ThunderBolt, ThunderBolt.inspect);
			ExternalInterface.addCallback("set", ThunderBolt, ThunderBolt.setAttribute);
			ExternalInterface.addCallback("run", ThunderBolt, ThunderBolt.run);
			getURL('javascript:console.info("Thunderbolt External Interface enabled")');			
			
		} else {
			
			ThunderBolt.externalInitialized = true;
		}
	}

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){
	
		var out:String;
	
		if (!ThunderBolt.initialized){
			
			// check if Fibebug is available
			if (ThunderBolt.firebug){
			
				getURL('javascript:console.info("Thunderbolt enabled")');
			}
		}
		
		// send traces to console only if Firebug is available
		if (ThunderBolt.firebug){
	
			// replace all backslashes
			fileName = fileName.split("\\").join("/");
			
			if (fullClassWithMethodName === undefined) {
				
				fullClassWithMethodName = "";
			}

			if (fileName === undefined) {
				
				fileName = "";
			}

			if (lineNumber === undefined) {
				
				lineNumber = 0;
			}

			
			// retrieve information about current trace action
			var classParts:Array = fullClassWithMethodName.split("::");
			var methodName:String = classParts[1] || "anonymous";
			var fullClass:String = classParts[0] || "" ;
			var className:String = String(fullClass.split(".").pop()) || "Thunderbolt";
			var objectType:String = typeof traceObject;
					
			var time:String = (new Date()).toString().split(" ")[3];
			

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
			}

			if (traceObject == undefined){
				
				out = "undefined";
				objectType = "undefined";
				
			} else if (traceObject instanceof Date){
				
				out = 'new Date(' + traceObject.valueOf() + ')';	
				objectType = "date";
				
			} else if (traceObject instanceof MovieClip){
				
				out = traceMovieClip(MovieClip(traceObject));
				
			} else {
			
				if (objectType == "string"){
					
					out = '"' + String(traceObject).split('"').join('\\"') + '"';
					
				} else {
					
					out = JSON.stringify(traceObject);
				}					
			}
			
			var description:String = fullClassWithMethodName + "[" + lineNumber + "] : " + objectType + " @ " + time;
			
			// cunstruct info object
			var logInfo:String = "{" +
				"thunderbolt:'" + "                                              '," +  
				"description:'" + description 	+ "'," +  
				"method:'"		+ methodName	+ "'," +
				"line:'"		+ lineNumber	+ "'," +
				"type:'"		+ objectType	+ "'," +
				"time:'"		+ time			+ "'," +
				"fullClass:'" 	+ fullClass 	+ "'," +
				"file:'" 		+ fileName 		+ "'," +
				"toString:"		+ "function(){return '" + className + "." + methodName + "'}" +
				"}";			
			
			// send trace to console
			ThunderBolt.callFirebug(console, logInfo, out);
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
	
	// convert movieclip structure to object
	private static function traceMovieClip(target:MovieClip):String {
		
		var movieclip:Object = new Object();
		
		// get moviescript name
		var name:String = target._name;
		 
		if (target == _root) {
			
			// set moviescript name to "_root"	
			name = "_root";	
		}
		
		for (var properties:Object in target){
		
			// copy all properties
			movieclip[properties] = target[properties];	
		}
		
		// return movieclip information
		return "{" + name + ":" + JSON.stringify(movieclip)+ ", toString:function(){return '[movieclip]'}}";

	}
	
	private static function callFirebug(method:String, infoObject:Object, traceObject:Object){
		


		if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && method == "log") {
			
			getURL('javascript:console.log(' + infoObject + ',":");');
			
			getURL("javascript:console.group();");

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
		
		if (!ThunderBolt.initialized){

			ThunderBolt._firebug = ExternalInterface.call("function(){ return console && console.firebug}", true);
			ThunderBolt.initialized = true;
		}
		
		return ThunderBolt._firebug;
	}
}