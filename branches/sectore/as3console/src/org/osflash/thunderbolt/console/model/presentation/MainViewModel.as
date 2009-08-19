package org.osflash.thunderbolt.console.model.presentation
{
	import flash.events.IEventDispatcher;
	
	import org.osflash.thunderbolt.console.events.ViewEvent;
	import org.osflash.thunderbolt.console.model.Constants;
	
	public class MainViewModel implements IMainViewModel
	{
		//
		// vars
		[Bindable] 
		public var viewState: String = "configFileViewState";
		
		
		[Bindable] 
		public var logPath: String;
		
		protected var _mainViewState: int;
		
		//
		// const	
		
		//
		// instances
		public var dispatcher : IEventDispatcher;
		
		
		public function MainViewModel()
		{
		}
		
		public function changeMainViewState():void
		{
			var newViewState: int = ( _mainViewState == Constants.VIEW_ADD_FILE )
									? Constants.VIEW_CONSOLE
									: Constants.VIEW_ADD_FILE;
			
			
			var viewEvent: ViewEvent = new ViewEvent( ViewEvent.CHANGE_VIEW_STATE );				
			viewEvent.newViewState = newViewState;
			dispatcher.dispatchEvent(viewEvent);				
		}
		
		public function set mainViewState( value: int ):void
		{
			_mainViewState = value;
			
			switch( _mainViewState )
			{
				case Constants.VIEW_ADD_FILE:
					viewState = "configFileViewState";	
					break;
				case Constants.VIEW_CONSOLE:
					viewState = "consoleViewState";
					break;
				default:
					viewState = "configFileViewState";
					
			}
			
		}
	}
}