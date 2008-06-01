package org.osflash.thunderbolt.console.events
{
	import flash.events.Event;	

	/**
	 * ViewEvent 
	 * @author Jens Krause [www.websector.de]
	 */
	public class ViewEvent extends Event 
	{	
		//
		// vars	
		public var newViewState: int;
		//
		// const	
		public static const CHANGE_VIEW_STATE: String = "changeViewState";
				
		/**
		* constructor
		* @param type		Type definition of event
		* @param bubbles	Flag to bubble this event
		*/		
		public function ViewEvent(type : String)
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
		 	return "[Instance of:  org.osflash.thunderbolt.console.events.ViewEvent ]";

		}		
	}
}
