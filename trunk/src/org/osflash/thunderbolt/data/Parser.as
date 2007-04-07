/**
 * @author kleppe
 */
class org.osflash.thunderbolt.data.Parser{
	
    static function stringify(target, depth:Number):String {

        var output:String = '';

		var type:String = getObjectType(target);
		
		if (depth === undefined){
		
			depth = 2; 	
		} 
		
		var stopAnalysing:Boolean = depth <= 0;
		
		if (stopAnalysing){
			
			return objectIsComplex(type) ? '{toString:function(){return "[' + type + ']"}}' : stringify(target);
		}

        switch (type) {
        	
        	case 'movieclip':
        	
        		output = 'toString:function(){return "[movieclip | ' + target + ']"}'; 
        		
        		var mcProperties:Array = ["_x", "_y", "_width", "_height", "_xscale", "_yscale", "_alpha"];
        		
        		for (var i:Number=0; i<mcProperties.length; i++) {
        		
        			var property:String = mcProperties[i];
        			
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
			
			return "movieclip";
			
		} else if(target instanceof XML) {
			
			return "xml";
			
		} else if(target instanceof XMLNode) {
			
			return "xmlnode";
		}
   		
   		return type;
   		
    }
    
    static function objectIsComplex(type:Object):Boolean{
    	
    	return type == "object" || type == "movieclip";
    }    
}