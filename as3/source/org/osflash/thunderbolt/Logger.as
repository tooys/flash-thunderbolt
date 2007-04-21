/**
* Logging Flex and AS3 projects with Firebug
* 
* @author	Jens Krause [www.websector.de]
* @date		04/21/07
* @see		http://www.websector.de/blog/2007/04/21/logging-flex-2-and-as-3-apps-with-firebug-and-thunderbolt/
* @source	http://flash-thunderbolt.googlecode.com/svn/trunk/as3/
* 
*/
package org.osflash.thunderbolt
{
	import flash.external.ExternalInterface;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;

	/**
	* 
	*/
	public class Logger
	{

		public static const LOG: String = "log";
		public static const INFO: String = "info";
		public static const WARN: String = "warn";
		public static const ERROR: String = "error";
		
		private static const MAX_DEPTH: int = 255;		

		private static var depth: int;	
		private static var logLevel: String;						
		 
		/**
		 * Calls Firebugs command line API to write log information
		 * 
		 * @param 	msg		log Message 
		 * @param 	obj		log object
		 */			 
		public static function trace (msg: String = null, obj:Object = null): void
		{
		 	depth = 0;
		 	//
		 	// log description
		 	logLevel = (msg != null) ? Logger.getLogLevel(msg) : Logger.LOG;
		 	var txtMessage: String = (msg != null && msg.length >= 3) ? msg.slice(2) : "";	 	
		 	var logMsg: String = logLevel.toUpperCase() + ": " + txtMessage;		 	
		 	ExternalInterface.call("console." + logLevel, logMsg);
		 	//
		 	// log object	 	
		 	if (obj) Logger.logProperties(obj);		 	
		}

		/**
		 * Logs nested instances and properties
		 * 
		 * @param 	logObj	log object
		 * @param 	id		short description of log object
		 */	
		private static function logProperties (logObj: *, id: String = null): void
		{	
			++ depth;
			
			var propID: String = id || "";
			
			if (depth < Logger.MAX_DEPTH)
			{
				var description:XML = describeType(logObj);				
				var type: String = description.@name;
				
				if (primitiveType(type))
				{					
					var msg: String = (propID.length) 	? 	"[" + type + "] " + propID + " = " + logObj
														: 	"[" + type + "] " + logObj;
															
					ExternalInterface.call("console." + Logger.LOG, msg);
				}
				else if (type == "Object")
				{
				  	ExternalInterface.call("console.group", "[Object] " + propID);				  	
				  	for (var element: String in logObj)
				  	{
				  		logProperties(logObj[element], element);				  		
				  	}
				  	ExternalInterface.call("console.groupEnd");
				}
				else if (type == "Array")
				{
				  	ExternalInterface.call("console.group", "[Array] " + propID);					  					  	
				  	for (var i: int = 0; i < logObj.length; i++)
				  	{
				  		logProperties(logObj[i]);				  		
				  	}
				  	ExternalInterface.call("console.groupEnd");					  			
				}
				else
				{
					var list: XMLList = description..variable;					
					if (list.length())
					{
						for each(var item: XML in list)
						{
							var propItem: String = item.@name;
							var typeItem: String = item.@type;
							// var ClassReference: Class = getDefinitionByName(typeItem) as Class;
							var valueItem: * = logObj[propItem];
	
							logProperties(valueItem, propItem);
						}					
					}
					else
					{
						logProperties(logObj, type);					
					}
				}

			}
			else
			{
				ExternalInterface.call("console." + Logger.WARN, "STOP LOGGING: More than " + depth + " nested objects or properties");
			}									
		}
			
		/**
		 * Checking for primitive types
		 * 
		 * @param 	type				type of object
		 * @return 	isPrimitiveType 	isPrimitiveType
		 * 
		 */							
		private static function primitiveType (type: String): Boolean
		{
			var isPrimitiveType: Boolean;
			
			switch (type) 
			{
				case "Boolean":
					isPrimitiveType = true;
				break;
				case "void":
					isPrimitiveType = true;
				break;
				case "int":
					isPrimitiveType = true;
				break;
				case "uint":
					isPrimitiveType = true;
				break;
				case "Number":
					isPrimitiveType = true;
				break;				
				case "String":
					isPrimitiveType = true;
				break;				
				case "undefined":
					isPrimitiveType = true;
				break;
				case "null":
					isPrimitiveType = true;
				break;			
				default:
					isPrimitiveType = false;
			}

			return isPrimitiveType;
		}

		/**
		 * Translates log keys to Firebug log levels,  
		 * which based on zeroi's key mapping
		 * @see 	http://www.osflash.org/zeroi/
		 * 
		 * @param 	msg
		 * @return 	level description
		 * 
		 */		
		private static function getLogLevel (msg: String): String
		{
			var firstChar: String = (msg.charAt(1) == " ") ? msg.charAt(0).toLowerCase() : "d";
			var level: String;
			
			switch (firstChar) 
			{
				case "i":
					level = Logger.INFO;
				break;
				case "w":
					level = Logger.WARN;
				break;				
				case "e":
					level = Logger.ERROR;
				break;
				case "d":
					level = Logger.LOG;
				break;
				default:
					level = Logger.LOG;
			}

			return level;
		}
	}
}