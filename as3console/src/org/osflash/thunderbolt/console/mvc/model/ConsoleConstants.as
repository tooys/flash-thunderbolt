/*
* Logging Flex, AIR and Flash applications using ThunderBolt AS3 Console
* 
* @author	Jens Krause [www.websector.de]
* @see		http://www.websector.de/blog/category/thunderbolt/
* @see		http://code.google.com/p/flash-thunderbolt/
* 
* Source code based on the Mozilla Public License 1.1. Feel free to use it!
*
*/
package org.osflash.thunderbolt.console.mvc.model
{
	
	public class ConsoleConstants
	{
		public static const TRACE_INFO: String = "[INFO]";
		public static const TRACE_WARN: String = "[WARN]";
		public static const TRACE_ERROR: String = "[ERROR]";
		public static const TRACE_DEBUG: String = "[DEBUG]";
		public static const TRACE: String = "[TRACE]";		
	
		//
		// short cuts which will traced by ThunderBolt's Logger logging within flashlog.txt
		// Use constant to avoid issues using these pretty crazy short cuts ;-)
		public static const INFO: String = "i__";		
		public static const INFO_GROUP_START: String = "igr";
		public static const INFO_GROUP_END: String = "ige";

		public static const WARN: String = "w__";		
		public static const WARN_GROUP_START: String = "wgr";
		public static const WARN_GROUP_END: String = "wge";

		public static const ERROR: String = "e__";		
		public static const ERROR_GROUP_START: String = "egr";
		public static const ERROR_GROUP_END: String = "ege";

		public static const DEBUG: String = "d__";		
		public static const DEBUG_GROUP_START: String = "dgr";
		public static const DEBUG_GROUP_END: String = "dge";

		public static const LOG: String = "l__";		
		public static const LOG_GROUP_START: String = "lgr";
		public static const LOG_GROUP_END: String = "lge";
				
	}
}