package org.osflash.thunderbolt.console.events
{
	import flash.events.Event;

	public class ViewEvent extends Event 
	{	
		//
		// vars	
		public var newViewState: int;
		//
		// const	
		public static const CHANGE_VIEW_STATE: String = "changeViewState";
		public static const CHECK_FOR_UPDATE: String = "checkForUpdate";

		public function ViewEvent( type:String )
        {
            super( type, true );
        }

		
	}
}
