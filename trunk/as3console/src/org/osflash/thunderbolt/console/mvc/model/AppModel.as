/** Logging Flex, AIR and Flash applications using ThunderBolt AS3 Console* * @author	Jens Krause [www.websector.de]* @see		http://www.websector.de/blog/category/thunderbolt/* @see		http://code.google.com/p/flash-thunderbolt/* * Source code based on the Mozilla Public License 1.1. Feel free to use it!**/package org.osflash.thunderbolt.console.mvc.model{	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	import flash.system.Capabilities;	

	/**	* AppModel    * @author Jens Krause [www.websector.de]	*/			public class AppModel extends EventDispatcher	{		//		// vars		[Bindable] public var viewState: int;		private var _logPath: String;				//		// log data		[Bindable]	public var logData: Array = new Array();		[Bindable]	public var logInfoData: Array = new Array();		[Bindable]	public var logErrorData: Array = new Array();		[Bindable]	public var logDebugData: Array = new Array();		[Bindable]	public var logWarnData: Array = new Array();													[Bindable]  public var isWatching: Boolean = false;		public var groupIgnore: Boolean = false;				public var group: Boolean = false;		public var groupEnd: Boolean = false;					public var groupInfo: Boolean = false;		public var groupInfoEnd: Boolean = false;						public var groupError: Boolean = false;		public var groupErrorEnd: Boolean = false;							public var groupDebug: Boolean = false;		public var groupDebugEnd: Boolean = false;							public var groupWarn: Boolean = false;		public var groupWarnEnd: Boolean = false;																		public var lastLine: int = 0;		
		[Bindable] public var htmlPage: String;				private var _alwaysInFront: Boolean = false;				private var _hideTraceLogs: Boolean = true;		//		// const			public static const VIEW_ADD_FILE: int = 0;		public static const VIEW_CONSOLE: int = 1;				//		// instances		private static var _instance: AppModel = null;		private var _sharedObject: SharedObject;						/**		* Constructor of AppModel which is a Singleton		*		*/		public function AppModel(enforcer: SingletonEnforcer) 		{			if (_instance != null)			{				throw ( new Error ("There can be only one instance of AppModel"));			}							//			// create and use a shared object			_sharedObject = SharedObject.getLocal( "ThunderBoltAS3Console" );            _sharedObject.objectEncoding = ObjectEncoding.AMF3;	                        //            // set the location of htmlPage			var prePath: String = (Capabilities.os.search("Mac") >= 0)					? "file://"					: "";								            htmlPage = prePath + File.applicationDirectory.nativePath + "/assets/html/output_list.html";                                                		}		public static function getInstance () : AppModel 		{			if (_instance == null)			{				AppModel._instance = new AppModel(new SingletonEnforcer());			}			return AppModel._instance;		};		//--------------------------------------------------------------------------		//		// getter / setter		//		//--------------------------------------------------------------------------						[Bindable]		public function get logPath (): String 		{			var logPath: String;			if (_sharedObject.data.logPath != null)			{				logPath = _sharedObject.data.logPath			}			else			{				logPath = _logPath;			}						return logPath;		};							public function set logPath (value: String): void 		{            try            {	            _sharedObject.data.logPath = value;	            _sharedObject.flush();                        }            catch(e: Error){}                           _logPath = value;		};					[Bindable]		public function get hideTraceLogs (): Boolean 		{			var value: Boolean;			if (_sharedObject.data.hideTraceLogs != null)			{				value = _sharedObject.data.hideTraceLogs			}			else			{				value = _hideTraceLogs;			}						return value;		};							public function set hideTraceLogs (value: Boolean): void 		{            try            {	            _sharedObject.data.hideTraceLogs = value;	            _sharedObject.flush();                        }            catch(e: Error){}                           _hideTraceLogs = value;		};					[Bindable]		public function get alwaysInFront (): Boolean 		{			var value: Boolean;			if (_sharedObject.data.alwaysInFront != null)			{				value = _sharedObject.data.alwaysInFront			}			else			{				value = _alwaysInFront;			}						return value;		};							public function set alwaysInFront (value: Boolean): void 		{            try            {	            _sharedObject.data.alwaysInFront = value;	            _sharedObject.flush();                        }            catch(e: Error){}                           _alwaysInFront = value;		};								//--------------------------------------------------------------------------		//		// toString		//		//--------------------------------------------------------------------------				override public function toString() : String 	    {		    return "[Instance of:  org.osflash.thunderbolt.console.mvc.model.AppModel]";	    }	}}internal class SingletonEnforcer{}