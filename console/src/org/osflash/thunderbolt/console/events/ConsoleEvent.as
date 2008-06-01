package org.osflash.thunderbolt.console.events
{
	import flash.events.Event;	

	/**
	 * ConsoleEvent 
	 * @author Jens Krause [www.websector.de]
	 */
	public class ConsoleEvent extends Event 
	{	
		//
		// vars	

		//
		// const	
		public static const START_LOG_WATCHING: String = "startWatching";
		public static const STOP_LOG_WATCHING: String = "stopWatching";
		public static const CLEAR_LOG: String = "clearLog";
		public static const CHANGE_LOG_PATH: String = "changeLogPath";
						
		/**
		* constructor
		* @param type		Type definition of event
		* @param bubbles	Flag to bubble this event
		*/		
		public function ConsoleEvent(type : String)
		{
			super(type, true);
		}


		//--------------------------------------------------------------------------
		//
		//  to string
		//
		//--------------------------------------------------------------------------
		
		override public function toString() : String 
		{
		 	return "[Instance of:  org.osflash.thunderbolt.console.events.ConsoleEvent ]";

		}		
	}
}
