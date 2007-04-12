/**
 * A Parser to convert an object into its JavaScript Object Notation 
 * (JSON) so it could be passed to JavaScipt calls.
 * 
 * @author Martin Kleppe <kleppe@gmail.com>
 */
 
class org.osflash.thunderbolt.data.Parser{
	
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
	 */
    static function stringify(target:Object, depth:Number):String {

        var output:String = '';

		var type:String = getObjectType(target);
		
		if (depth === undefined){
		
			depth = 2; 
		} 
		
		// stop execution if depth is equal or less than zero
		var stopAnalysing:Boolean = depth <= 0;
		
		if (stopAnalysing){
			
			return Parser.typeIsComplex(type) ? '{toString:function(){return "[' + type + ']"}}' : stringify(target);
		}

        switch (type) {
        	
        	case 'textfield': 
        	
        		output = 'toString:function(){return "[textfield | ' + target + ']"}';
        		
                for (var all:String in target) {
                	
                    output += "," + all + ':' + stringify(target[all].toString());
                } 
        		
        		return "{" + output + "}";     		
        		
        	case 'movieclip':
        	
        		output = 'toString:function(){return "[movieclip | ' + target + ']"}'; 
        		
        		for (var i:Number=0; i< Parser.mcProperties.length; i++) {
        		
        			var property:String = Parser.mcProperties[i];
        			
        			output += "," + property + ":" + target[property];
        		}
        	
	        case 'object':
	        
                for (var all:String in target) {
                	
                    output += (output ? "," : "") + all + ':' + stringify(target[all], depth-1);
                }
                
                return '{' + output + '}';
                
            
            case 'array':
                        
                for (var i:Number = 0; i < target.length; i++) {
                	
                    output += (output ? "," : "") + stringify(target[i], depth-1);
                }
                
                return '[' + output + ']';
                    	            
	        case 'number': 		return isFinite(target) ? String(target) : 'null';
	        case 'string': 		return '"' + target.split('"').join('\\"') + '"';
	        case 'boolean':		return String(target);
	        case 'date':		return 'new Date(' + target.valueOf() + ')';
	        case 'xml':
	        case 'xmlnode':		return '{xml:"' + target.toString().split('"').join('\\"') + '", toString:function(){return "[xml]";}}';
	        case 'undefined': 	return 'undefined';
	       	case 'function':  	return '{toString:function(){return "[' + type + ']"}}';
	            
	        default: 			return 'null';
        }
    }
    
    /**
     * Get the "real" type of an object. Possible values are:
     * undefined, null, number, string, boolean, number,
     * object, array, date, movieclip, button, textfield,
     * xml and xmlnode.
     *
     * @param	target	The object to analyse.
     * @return 	Object type.
     */
    static function getObjectType(target:Object):String{
    
		var type = typeof(target);

		if (type == "string" || type == "boolean" || type == "number" || type == "undefined" || type == "null") {
			
			return type;			

		} else if(target instanceof Date) {
			
			return "date";
			
		} else if(target instanceof Array) {
			
			return "array";
			
		} else if(target instanceof Button) {
			
			return "button";
			
		} else if(target instanceof MovieClip) {
			
			return "movieclip";
			
		} else if(target instanceof TextField) {
			
			return "textfield";
			
		} else if(target instanceof XML) {
			
			return "xml";
			
		} else if(target instanceof XMLNode) {
			
			return "xmlnode";
		}
   		
   		return type;
    }
    
    /**
     * Test if the object type is complex. This could be used 
     * to execute recursive code executions.
     *
     * @param	type	The object type
     * @return 			True if object type is complex
     */
    static function typeIsComplex(type:Object):Boolean{
    	
    	return type == "object" || type == "movieclip";
    }    
}