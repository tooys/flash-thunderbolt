package org.osflash.thunderbolt.console.events
{
	import flash.events.Event;

	public class OptionsEvent extends Event 
	{	
		//
		// vars	
		public var alwaysInFront: Boolean;
		public var hideTraceLogs: Boolean;
		
		
		//
		// const			
		public static const CHANGE_ALWAYS_IN_FRONT: String = "ViewEvent.CHANGE_ALWAYS_IN_FRONT";
		public static const CHANGE_HIDE_TRACE_LOGS: String = "ViewEvent.CHANGE_HIDE_TRACE_LOGS";

		public function OptionsEvent( type:String )
        {
            super( type, true );
        }

		
	}
}
