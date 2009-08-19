package org.osflash.thunderbolt.console.model.presentation
{
	public interface IMainViewModel
	{
		[Bindable(event="propertyChange")]
		function get viewState():String;

		[Bindable(event="propertyChange")]
		function get logPath():String;

		function changeMainViewState():void;
	}
}