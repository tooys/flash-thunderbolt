/**
* Logging Flex apps with Firebug using ThunderBolt AS3
* 
* @author	Jens Krause [www.websector.de]
* @date		06/17/07
* @see		http://www.websector.de/blog/?s=thunderbolt
* @see		http://code.google.com/p/flash-thunderbolt/
* @source	http://flash-thunderbolt.googlecode.com/svn/trunk/as3/
* 
* ***********************
* HAPPY LOGGING ;-)
* ***********************
* 
*/

package org.osflash.thunderbolt
{
	import mx.logging.AbstractTarget;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.ILogger;
	
	
	public class ThunderBoltTarget extends AbstractTarget
	{
		public var includeTime: Boolean = true;
		public var includeLevel: Boolean = true;   	    	
		public var includeCategory: Boolean = true;
		
		protected static const FIELD_SEPERATOR: String = " :: ";
		
		 
		public function ThunderBoltTarget ()
		{
			super();		
		}

 
	     /**
	     *  Listens to an log event based on Flex 2 Logging Framework
	     * 	and calls ThunderBolt trace method
	     * 
		 * @param 	event	LogEvent
		 * 
	     */
	    override public function logEvent(event: LogEvent):void
	    {		
			//
			// adds a timestamp
    		Logger.includeTime = includeTime;	    	
	    	//
	    	// logs level
	        var level: Number = LogEventLevel.ALL;
	        if (includeLevel) level = event.level;	
			//
			// logs category
	    	var message: String = ""
			if (includeCategory) message += ILogger(event.target).category + FIELD_SEPERATOR;
			//
			// logs message
			if (event.message.length) message += event.message;
			else message += "log message has'nt defined... ;-)";
	    	//
	    	// calls ThunderBolt	
	    	Logger.trace (level, message);

	    }   
        		
	}

}