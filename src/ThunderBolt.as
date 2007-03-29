
import flash.external.ExternalInterface;
/**

 * @author Martin Kleppe - http://labs.sumaato.net
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.1
 */
 
class ThunderBolt {
	
	private static var initialized:Boolean = false;
	private static var firebugEnabled:Boolean = false;

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){
	
		if (!ThunderBolt.initialized){
			
			var firebugVersion:Object = ExternalInterface.call("function(){ return console && console.firebug}", true);
			
			ThunderBolt.firebugEnabled = Number(firebugVersion) > 1;
			
			if (ThunderBolt.firebugEnabled){
			
				getURL('javascript:console.info("Thunderbolt enabled")');
			}
		
			ThunderBolt.initialized = true;
		}
		
		if (ThunderBolt.firebugEnabled){
	
			fileName = fileName.split("\\").join("/");
			
			var classParts:Array = fullClassWithMethodName.split("::");
			
			var methodName:String = classParts[1];
			var fullClass:String = classParts[0];
			var className:String = String(fullClass.split(".").pop());
			var objectType:String = typeof traceObject;
			
			var date:Date = new Date();
			
			var time:String = date.toString().split(" ")[3];
			
			var logInfo:String = "{" +
				"thunderbolt:'" + "                                              '," +  
				"description:'" + fullClassWithMethodName + "[" + lineNumber + "] : " + objectType + " @ " + time + "'," +  
				"method:'"		+ methodName	+ "'," +
				"line:'"		+ lineNumber	+ "'," +
				"type:'"		+ objectType	+ "'," +
				"time:'"		+ time			+ "'," +
				"fullClass:'" 	+ fullClass 	+ "'," +
				"file:'" 		+ fileName 		+ "'," +
				"toString:"		+ "function(){return '" + className + "." + methodName + "'}" +
				"}";

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
			
			var out:String = JSON.stringify(traceObject);
			
			if (objectType == "movieclip"){
			
				out = traceMovieClip(MovieClip(traceObject));
			}
				
			ThunderBolt.callFirebug(console, logInfo, out);
		}
	}
	
	private static function traceMovieClip(target:MovieClip):String {
		
		var subMovieClips:Object = new Object();
		
		var name:String = target._name;
		
		if (target == _root) {
		
			name = "_root";	
		}
		
		for (var all in target){
		
			var mc:MovieClip = MovieClip(target[all]);	
			subMovieClips[all] = target[all];	
		}
		
		return "{" + name + ":" + JSON.stringify(subMovieClips)+ ",toString:function(){return '[movieclip]'}}";

	}
	
	private static function callFirebug(method:String, infoObject:Object, traceObject:Object){
		
		getURL('javascript:console.' + method + '(' + infoObject + ',":",' + traceObject + ')');	
	}
	
	public static function get enabled(Void):Boolean{

		return ExternalInterface.call("function(){ return console && console.firebug}", true) > 1;
	}
}