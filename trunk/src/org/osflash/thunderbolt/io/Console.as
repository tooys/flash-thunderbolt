import flash.external.ExternalInterface;
import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.data.StringyfiedObject;
import org.osflash.thunderbolt.data.JSReturn;
/**
 * @author kleppe
 */
class org.osflash.thunderbolt.io.Console {
	
	public static var version:Number;
	private static var _enabled:Boolean;

	// Writes a message to the console.
	public static function log(){
	
		Console.run("log", arguments);	
	}
		
	// Writes a message to the console with the visual "info" icon and color coding.
	public static function info(){
	
		Console.run("info", arguments);	
	}

	// Writes a message to the console with the visual "warning" icon and color coding.
	public static function warn(){
	
		Console.run("warn", arguments);	
	}

	// Writes a message to the console with the visual "error" icon and color coding.
	public static function error(){
	
		Console.run("error", arguments);	
	}
	
	// Prints an interactive listing of all properties of the object.
	public static function dir(){
	
		Console.run("dir", arguments);	
	}	

	// Prints the XML source tree of an HTML or XML element.
	public static function dirxml(node:Object){
	
		var out = node.toString().split('"').join('\\"');
	
		var returnObject:JSReturn = new JSReturn(
			"var n = document.createElement('xml');" +
			"n.innerHTML = \"" + out + "\";" +
			"return n;"
		);
				
		Console.run("dirxml", [returnObject]);
	}	

	// Writes a message to the console and opens a nested block 
	// to indent all future messages sent to the console.
	public static function group():Void{
		
		Console.run("group", arguments);	
	}

	// Closes the most recently opened block.
	public static function groupEnd():Void{
		
		Console.run("groupEnd");	
	}

	// Executes JavaScript command
	private static function run(method, parameter:Array):Void{
			
		var parameterString:String;
		
		if (parameter){
		
			// check if unquoted strings are in cluded in parameters
			for (var i:Number=0; i < parameter.length; i++) {
			
				if (typeof parameter[i] == "string" && parameter[i].indexOf('"') != 0){
					
					parameter[i] = Parser.stringify(parameter[i]);
				}
			}
			
		} else {
			
			parameterString = "";
		}

		parameterString = parameter.join(",");
	
		getURL("javascript:console." + method + "(" + parameterString + ");");		
	}
	
	// Check if Firebug is enabled
	public static function get enabled():Boolean{
	
		if (Console._enabled !== undefined){
			
			return Console._enabled;
			
		} else {
			
			Console.version = Number(ExternalInterface.call("function(){ return console && console.firebug}", true));
			Console._enabled = Console.version > 0;
			
			if (Console._enabled){
				
				Console.log("Firebug enabled", Console.version);
			} 
		}
	}	
}