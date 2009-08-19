package org.osflash.thunderbolt.console.model.presentation
{
	import flash.events.IEventDispatcher;
	
	import org.osflash.thunderbolt.console.events.OptionsEvent;

	public class OptionsViewModel implements IOptionsViewModel
	{
		//
		// vars
		[Bindable] 
		public var alwaysInFront: Boolean;

		[Bindable] 
		public var hideTraceLogs: Boolean;
		//
		// const	
	
		//
		// instances
		public var dispatcher : IEventDispatcher;
		
		
		public function OptionsViewModel()
		{
		}
		
		

		public function changeAlwaysInFront():void
		{
			var event: OptionsEvent = new OptionsEvent( OptionsEvent.CHANGE_ALWAYS_IN_FRONT );
			event.alwaysInFront = !alwaysInFront;
			dispatcher.dispatchEvent( event );
			
		}
		

		public function changeHideTraceLogs():void
		{
			var event: OptionsEvent = new OptionsEvent( OptionsEvent.CHANGE_HIDE_TRACE_LOGS );
			event.hideTraceLogs = !hideTraceLogs;
			dispatcher.dispatchEvent( event );
			
		}
		
		
	}
}