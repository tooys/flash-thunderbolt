import org.osflash.thunderbolt.logging.LogLevel;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 * 
 * Change these settings for your need.
 * 
 */
class org.osflash.thunderbolt.Settings {
	
	/* 
	 * Set this flag to false if you do not want to group messages by frames.  
	 */
	public static var USE_FRAME_COUNTER:Boolean = true;
		
	/*
	 * Set the debugger log level.
	 * 
	 * LogLevel.LOG		- traces all messages
	 * LogLevel.INFO	- traces info, warning, error and fatal messages
	 * LogLevel.WARNING	- traces warning, error and fatal messages
	 * LogLevel.ERROR	- traces error and fatal messages
	 * LogLevel.FATAL	- traces fatal messages only
	 */
	public static var LOG_LEVEL:String = LogLevel.LOG;	
}