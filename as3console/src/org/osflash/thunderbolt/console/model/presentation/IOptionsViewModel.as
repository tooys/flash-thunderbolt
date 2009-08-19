package org.osflash.thunderbolt.console.model.presentation
{
	public interface IOptionsViewModel
	{
		[Bindable(event="propertyChange")]
		function get alwaysInFront():Boolean;
		function changeAlwaysInFront():void;

		[Bindable(event="propertyChange")]
		function get hideTraceLogs():Boolean;
		function changeHideTraceLogs():void;
		
	}
}