
package org.osflash.thunderbolt.console.model.domain
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	
	import org.osflash.thunderbolt.console.model.Constants;
	
	/**
	 * Domain model of the app
	 * 
	 */	
	public class MainModel extends EventDispatcher
	{
		//
		// vars
		private var _logPath: String;
		private var _hideTraceLogs: Boolean = true;	
		private var _alwaysInFront: Boolean = false;		
		
		private var _mainViewState: int;
		//
		// const
	
		//
		// instances
		private var _logData: ArrayCollection;
		private var _sharedObject: SharedObject;
		
		public function MainModel()
		{
			super();
			
			init();

		}
		
		protected function init():void
		{
			//
			// sharedObjec
			_sharedObject = SharedObject.getLocal( "ThunderBoltAS3Console" );
			_sharedObject.objectEncoding = ObjectEncoding.AMF3;
			//
			// mainViewState
			setMainViewState( ( logPath != null && logPath.length > 0 ) 
/*							? Constants.VIEW_ADD_FILE
							: Constants.VIEW_CONSOLE;*/
							? Constants.VIEW_CONSOLE
							: Constants.VIEW_ADD_FILE );
		}
		
		//--------------------------------------------------------------------------
		//
		// getter / setter
		//
		//--------------------------------------------------------------------------
		
		
		
		public function set logData( value: ArrayCollection ):void
		{
			if (value !== _logData)
			{
				_logData = value;				
				this.dispatchEvent( new Event('logDataChanged') );				
			}
		}
		
		[Bindable (event='logDataChanged')]
		public function get logData ():ArrayCollection
		{
			return _logData;
		}
		
		
		[Bindable (event='logPathChanged')]
		public function get logPath (): String 
		{
			var logPath: String;
			if (_sharedObject.data.logPath != null)
			{
				logPath = _sharedObject.data.logPath
			}
			else
			{
				logPath = _logPath;
			}
			
			return logPath;
		};			
		
		public function setLogPath (value: String): void 
		{
			if (value !== logPath)
			{
				try
				{
					_sharedObject.data.logPath = value;
					_sharedObject.flush();            
				}
				catch(e: Error){}   
				
				_logPath = value;
				
				this.dispatchEvent( new Event('logPathChanged') );			
			}
			
		};	
		
		
		[Bindable (event='hideTraceLogsChanged')]		
		public function get hideTraceLogs (): Boolean 
		{
			var value: Boolean;
			if (_sharedObject.data.hideTraceLogs != null)
			{
				value = _sharedObject.data.hideTraceLogs
			}
			else
			{
				value = _hideTraceLogs;
			}
			
			return value;
		};			
		
		public function setHideTraceLogs (value: Boolean): void 
		{
			if (value !== hideTraceLogs)
			{
				try
				{
					_sharedObject.data.hideTraceLogs = value;
					_sharedObject.flush();            
				}
				catch(e: Error){}   
				
				_hideTraceLogs = value;
				
				this.dispatchEvent( new Event('hideTraceLogsChanged') );				
				
			}
			
		};	
		
		
		[Bindable (event='alwaysInFrontChanged')]	
		public function get alwaysInFront (): Boolean 
		{
			var value: Boolean;
			if (_sharedObject.data.alwaysInFront != null)
			{
				value = _sharedObject.data.alwaysInFront
			}
			else
			{
				value = _alwaysInFront;
			}
			
			return value;
		};			
		
		public function setAlwaysInFront( value: Boolean ):void 
		{
			try
			{
				_sharedObject.data.alwaysInFront = value;
				_sharedObject.flush();           
			}
			catch(e: Error){}   
			
			_alwaysInFront = value;
			
			this.dispatchEvent( new Event('alwaysInFrontChanged') );	
		}
		
		[Bindable (event='mainViewStateChanged')]		
		public function get mainViewState():int
		{
			return _mainViewState;
		}
		
		public function setMainViewState( value:int ):void
		{
			if ( value !== _mainViewState )
			{
				_mainViewState = value;				
				this.dispatchEvent( new Event('mainViewStateChanged') );
			}
		}
		
		;		
		
		
	}
}