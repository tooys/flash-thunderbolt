package org.osflash.thunderbolt.console.utils
{
	import mx.controls.Alert;


	public class ErrorUtil
	{
		public function ErrorUtil()
		{
		}
		
		public function showError( message: String ):void
		{
			Alert.show( message );			
		}
	}
}