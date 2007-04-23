import org.osflash.thunderbolt.data.ObjectType;
/**
 * A Parser to convert an object into its JavaScript Object Notation 
 * (JSON) so it could be passed to JavaScipt calls.
 * 
 * @author Martin Kleppe <kleppe@gmail.com>
 */
 
class org.osflash.thunderbolt.data.Parser{
	
	private static var maxDepth:Number = 10;
	
	// movieclip properties that should be displayed
	private static var mcProperties:Array = [
		"_x", 
		"_y", 
		"_width", 
		"_height", 
		"_xscale", 
		"_yscale", 
		"_alpha"
	];
	
	/**
	 * Converts an object into its JavaScript Object Notation (JSON) 
	 * so it could be passed to JavaScipt calls.
	 * 
	 * @param	target	Object to stringify
	 * @param	depth	Optional paramter specifying the level of recusion
	 * @return 			Stringified object in JavaScript Object Notation (JSON)
	 * 
	 * @see	http://www.json.org/json.as
	 */
    public static function stringify(target:Object, depth:Number):String {

        var output:String = '';

		var type:String = ObjectType.get(target);
		
		if (depth === undefined){
		
			depth = Parser.maxDepth; 
		} 
		
		// stop execution if depth is equal or less than zero
		var stopAnalysing:Boolean = depth <= 0;
		
		if (stopAnalysing){
			
			return ObjectType.get(type) ? Parser.returnString(type, true) : Parser.stringify(target);
		}

        switch (type) {
        	
        	case 'textfield': 
        	
        		output = Parser.returnString("textfield | " + target);
        		
                for (var all:String in target) {
                	
                    output += "," + all + ':' + Parser.stringify(target[all].toString());
                } 
        		
        		return "{" + output + "}";     		
        		
        	case 'movieclip':
        	
        		output = Parser.returnString("movieclip | " + target); 
        		
        		for (var i:Number=0; i< Parser.mcProperties.length; i++) {
        		
        			var property:String = Parser.mcProperties[i];
        			
        			output += "," + property + ":" + target[property];
        		}
        	
	        case 'object':
	        
                for (var all:String in target) {
                	
                    output += (output ? "," : "") + all + ':' + Parser.stringify(target[all], depth-1);
                }
                
                return '{' + output + '}';
            
            case 'array':
                        
                for (var i:Number = 0; i < target.length; i++) {
                	
                    output += (output ? "," : "") + Parser.stringify(target[i], depth-1);
                }
                
                return '[' + output + ']';
                    	            
	        case 'number': 		return isFinite(target) ? String(target) : 'null';
	        case 'string': 		return '"' + target.split('"').join('\\"') + '"';
	        case 'boolean':		return String(target);
	        case 'date':		return 'new Date(' + target.valueOf() + ')';
	        case 'xml':
	        case 'xmlnode':		return '{xml:"' + target.toString().split('"').join('\\"') + '", ' + Parser.returnString('xml') + '}';
	        case 'undefined': 	return 'undefined';
	       	case 'function':  	return Parser.returnString(type, true);
	            
	        default: 			return 'null';
        }
    }
    
    private static function returnString(value:String, enclose:Boolean):String{
    	
    	var start:String = enclose ? "{" : "";
    	var end:String = enclose ? "}" : "";
    	
    	return start + 'toString:function(){return "[' + value + ']"}' + end;
    }
}