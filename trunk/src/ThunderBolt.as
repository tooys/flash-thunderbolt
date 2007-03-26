import mx.utils.ClassFinder;
import flash.external.ExternalInterface;
/**
 * @author Manfred Weber - http://manfred.dschini.org
 * @author Sebastian Wichmann - http://www.flashhilfe.de/
 * @author Martin Kleppe - http://labs.sumaato.net
 * @author Jens Krause - http://www.websector.de/
 * 
 * @link http://code.google.com/p/flash-thunderbolt/
 * 
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
			
			var out:String = ThunderBolt.stringify(traceObject);
			
			var logInfo:String = "{" +
				"description:'" + fullClassWithMethodName + "[" + lineNumber + "] : " + objectType + " @ " + time + "'," +  
				"method:'"		+ methodName	+ "'," +
				"line:'"		+ lineNumber	+ "'," +
				"type:'"		+ objectType	+ "'," +
				"time:'"		+ time			+ "'," +
				"fullClass:'" 	+ fullClass 	+ "'," +
				"file:'" 		+ fileName 		+ "'," +
				"toString:"		+ "function(){return '" + className + "." + methodName + "'}" +
				"}";
				
			ThunderBolt.callFirebug(ThunderBolt.getFirebugMethod(String(traceObject)), logInfo, out);
		}
	}
	
	private static function callFirebug(method:String, infoObject:Object, traceObject:Object){
		
		getURL('javascript:console.' + method + '(' + infoObject + ',":",' + traceObject + ')');	
	}
	
	private static function getFirebugMethod(traceObject:String):String{
	
		if (traceObject.charAt(1) != " ") {
		
			return "log";
				
		} else {
			
			switch (traceObject.charAt(0)) {
			
				case "d": return "log";
				case "i": return "info";
				case "w": return "warn";
				case "e": return "error";
				case "f": return "fatal";
				
				default: return "log";
			}
		}
	}
	
	/**
	 * Transform an actionscript object to a JSON string
	 * @param arg The object to jsonize
	 * @returns The JSON string
	 */
    private static function stringify(arg):String {

        var c, i, l, s = '', v;

        switch (typeof arg) {
        case 'object':
            if (arg) {
                if (arg instanceof Array) {
                    for (i = 0; i < arg.length; ++i) {
                        v = stringify(arg[i]);
                        if (s) {
                            s += ',';
                        }
                        s += v;
                    }
                    return '[' + s + ']';
                } else if (typeof arg.toString != 'undefined') {
                    for (i in arg) {
                        v = arg[i];
                        if (typeof v != 'undefined' && typeof v != 'function') {
                            v = stringify(v);
                            if (s) {
                                s += ',';
                            }
                            s += stringify(i) + ':' + v;
                        }
                    }
                    return '{' + s + '}';
                }
            }
            return 'null';
        case 'number':
            return isFinite(arg) ? String(arg) : 'null';
        case 'string':
            l = arg.length;
            s = '"';
            for (i = 0; i < l; i += 1) {
                c = arg.charAt(i);
                if (c >= ' ') {
                    if (c == '\\' || c == '"') {
                        s += '\\';
                    }
                    s += c;
                } else {
                    switch (c) {
                        case '\b':
                            s += '\\b';
                            break;
                        case '\f':
                            s += '\\f';
                            break;
                        case '\n':
                            s += '\\n';
                            break;
                        case '\r':
                            s += '\\r';
                            break;
                        case '\t':
                            s += '\\t';
                            break;
                        default:
                            c = c.charCodeAt();
                            s += '\\u00' + Math.floor(c / 16).toString(16) +
                                (c % 16).toString(16);
                    }
                }
            }
            return s + '"';
        case 'boolean':
            return String(arg);
        default:
            return 'null';
        }
    }
}