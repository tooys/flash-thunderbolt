
import flash.external.ExternalInterface;
/**

 * @author Martin Kleppe - http://labs.sumaato.net
 * @link http://code.google.com/p/flash-thunderbolt/
 * @version 0.03
 */
 
class ThunderBolt {
	
	private static var initialized:Boolean = false;
	private static var _firebug:Object;
	private static var externalInitialized:Boolean = false;
	
	private static var frameNumber:Number = 1;
	private static var lastFrame:Number = 0;
	
	private var groupStarted:Boolean;
	
	private static var mc:MovieClip;
	
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
	
	private static function initialize():Void{
		
		ThunderBolt.initialized = true;	
		
		ThunderBolt.mc = _root.createEmptyMovieClip("thunderbolt", _root.getNextHighestDepth());
		
		ThunderBolt.mc.onEnterFrame = function(){
		
			ThunderBolt.frameNumber++;
		};
		
		ThunderBolt._firebug = ExternalInterface.call("function(){ return console && console.firebug}", true);
		
		// check if Fibebug is available
		if (ThunderBolt.firebug){
		
			getURL('javascript:console.info("Thunderbolt enabled")');
		}
	}

	public static function trace(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){

		if (!ThunderBolt.initialized){
			
			ThunderBolt.initialize();
		}
	
		var time:String = ThunderBolt.getTime();		
		
		if (String(traceObject).indexOf("+++") == 0){
		
			var message:String = String(traceObject).slice(String(traceObject).charAt(3) == " " ? 4 : 3);
		
			// open group	
			getURL("javascript:console.group('" + message + (message ? " " : "") + "(" +fullClassWithMethodName + ")');");
			
		} else if (traceObject == "---"){
			
			// close group
			getURL("javascript:console.groupEnd();");
			
		} else {
		
			var out:String;
			
			ThunderBolt.checkFrameGroup();
			
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
			}
				
			// retrieve information about current trace action
			var classParts:Array = fullClassWithMethodName.split("::");
			var methodName:String = classParts[1] || "anonymous";
			var fullClass:String = classParts[0] || "" ;
			var className:String = String(fullClass.split(".").pop()) || "Thunderbolt";
			var objectType:String = typeof traceObject;

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
				
			} else if (traceObject instanceof XML){
				
				objectType = "xml";
				out = '{xml:"' + traceObject.toString().split('"').join('\\"') + '", toString:function(){return "XML";}}';
				
				console = "group";
				
			} else if (objectType == "string"){
					
				out = '"' + String(traceObject).split('"').join('\\"') + '"';
			
			} else if (objectType == "movieclip" || traceObject instanceof TextField){
				
				out = ThunderBolt.stringfyMoviclip(traceObject, true);
				
			} else {
				
				out = JSON.stringify(traceObject || "_root");
			}
			
			var description:String = fullClassWithMethodName + "[" + lineNumber + "] : " + objectType + " @ " + time;
			
			// cunstruct info object
			var logInfo:String = "{" +
				"thunderbolt:'" + "                                              '," +  
				"description:'" + description 				+ "'," +  
				"method:'"		+ methodName				+ "'," +
				"line:'"		+ lineNumber				+ "'," +
				"type:'"		+ objectType				+ "'," +
				"time:'"		+ time						+ "'," +
				"frame:'"		+ ThunderBolt.frameNumber 	+ "'," +
				"fullClass:'" 	+ fullClass 				+ "'," +
				"file:'" 		+ fileName 					+ "'," +
				"toString:"		+ "function(){return '" + className + "." + methodName + "'}" +
				"}";			
						
			// send trace to console
			ThunderBolt.callFirebug(console, logInfo, out);
			
			if (objectType == "xml"){

				ThunderBolt.traceXML(XML(traceObject));
					
			}
		}
	}
	
	private static function stringfyMoviclip(mc:Object, topLevel:Boolean){
		
        var c, i, l, s = '', v;
        
        if (topLevel){
        	
        	s = "toString:function(){return '" + mc + " [movieclip] '}"; 
        	
        	var mcProps:Array = ["_x", "_y", "_width", "_height", "_xscale", "_yscale", "_alpha"];
        	
        	for (var j:Number=0; j < mcProps.length; j++){
        		
        		s += "," + mcProps[j] + ":" + mc[mcProps[j]];
        	}
        };

        if (mc) {
        	
    		for (i in mc) {
    			
                v = mc[i];
                
                if (typeof v == "movieclip" || v instanceof TextField){
                	   
                    s += (s ? "," : "") + JSON.stringify(i) + ':' + ThunderBolt.stringfyMoviclip(v);                	
                	
                } else if (topLevel && typeof v != 'undefined' && typeof v != 'function') {

                    s += (s ? "," : "") + JSON.stringify(i) + ':' + JSON.stringify(v);
                }
            }
            
            var name:String = (mc == _root ? "_root" : mc._name) || mc.toString(); 
            
            var mcType:String = (typeof mc == "movieclip") ? "movieclip" : "textfield";
            
            s += (s ? "," : "") + "toString:function(){return '[" + mcType + " | " + name + "]';}";
            
            return '{' + s + '}';
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
	
	private static function checkFrameGroup():Void{
		
		if (ThunderBolt.frameNumber != ThunderBolt.lastFrame){
			
			getURL("javascript:console.groupEnd();");

			var movieUrl:String = _root._url.split("\\").pop().split("/").pop();
			
			getURL("javascript:console.group('" + movieUrl + " [frame " + ThunderBolt.frameNumber + "] @ " + ThunderBolt.getTime() + "');");
			
			ThunderBolt.lastFrame = ThunderBolt.frameNumber;
		}		
	}
	
	private static function getTime():String{

		return (new Date()).toString().split(" ")[3];		
	}
	
	private static function callFirebug(method:String, infoObject:Object, traceObject:Object){
		
		if (typeof traceObject == "string" && traceObject.indexOf("\n") > -1 && method == "log") {
			
			getURL("javascript:console.group(" + infoObject + ");");

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

			ThunderBolt.initialize();
		}
		
		return ThunderBolt._firebug;
	}
}