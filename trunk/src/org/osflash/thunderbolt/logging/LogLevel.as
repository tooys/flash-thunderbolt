import org.osflash.thunderbolt.io.Console;
/**
 * LogLevel class based on message shorcuts:
 * 
 * e = ERROR
 * i = INFO
 * w = WARNING
 * e = ERROR
 * f = fatal 
 * 
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.logging.LogLevel {
	
	private static var LOG:String 		= "LOG";
	private static var INFO:String 		= "INFO";
	private static var WARNING:String 	= "WARNING";
	private static var ERROR:String 	= "ERROR";
	private static var FATAL:String 	= "FATAL";
	
	public var level:String;
	public var message:String;
	
	public var messageModified:Boolean;
	
	/**
	 * Creates an LogLevel element based on a message.
	 * 
	 * Examples:
	 * trace("d This is a debug information."); will create a DEBUG LogLevel
	 * trace("i This is an information."); will create a INFO LogLevel
	 * trace("e This is an error."); will create a ERROR LogLevel
	 * trace("w This is a warning."); will create a WARNING LogLevel
	 * trace("f This is a fatal error."); will create a FATAL LogLevel
	 *
	 * @param	fullMessage	The message to analyse.
	 */
	function LogLevel(fullMessage:Object){
		
		this.level = LogLevel.LOG;
		this.messageModified = false;
		
		if (typeof fullMessage == "string" && fullMessage.charAt(1) == " ") {
			
			// TODO: "ERROR:", "INFO:" ... should also be parsed
			
			switch (fullMessage.charAt(0).toLowerCase()) {
			
				case "d": this.level = LogLevel.LOG;		break;
				case "i": this.level = LogLevel.INFO;	break;
				case "w": this.level = LogLevel.WARNING;	break;
				case "e": this.level = LogLevel.ERROR;	break;
				case "f": this.level = LogLevel.FATAL;	break;
			}
			
			this.message = String(fullMessage).slice(2);
			this.messageModified = true;
		} 		
	}
	
	/**
	 * Returns the Console method call which is associated 
	 * with the current LogLevel.
	 
	 * @return Console method call.
	 */
	public function get console():Function{
		
		switch (this.level){
			
			case LogLevel.LOG: 		return Console.log; 
			case LogLevel.INFO: 	return Console.info; 
			case LogLevel.WARNING: 	return Console.warn; 
			case LogLevel.ERROR: 	return Console.error; 
			case LogLevel.FATAL: 	return Console.error; 
			
			default:				return Console.log;
		};
	}
}