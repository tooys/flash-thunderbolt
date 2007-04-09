import org.osflash.thunderbolt.data.Parser;
import org.osflash.thunderbolt.io.Console;
/**
 * @author kleppe
 */
class org.osflash.thunderbolt.data.LogInfo {
	
	public var fullClassWithMethodName:String;
	
	public var fileName:String;
	
	public var classParts:Array;
	
	public var methodName:String;
	public var fullClass:String;
	
	public var className:String;
	
	public var traceObject:Object;
	
	public var lineNumber:Number;
	public var objectType:String;
	
	private static var lastFrame:Number;
	public static var frameNumber:Number;
	
	private static var frameCounter:MovieClip;
	
	function LogInfo(traceObject:Object, fullClassWithMethodName:String, fileName:String, lineNumber:Number){
		
		this.traceObject = traceObject;
		this.fullClassWithMethodName = fullClassWithMethodName || "";
		this.fileName = fileName.split("\\").join("/") || ""; 
		this.lineNumber = lineNumber || 0;

		this.objectType = Parser.getObjectType(traceObject);
		
		if (!LogInfo.frameNumber){
		
			LogInfo.frameNumber = 1;
			LogInfo.initializeFrameCounter();	
		}
	}
	
	private static function initializeFrameCounter():Void{
	
		LogInfo.frameCounter = _root.createEmptyMovieClip("thunderbolt", _root.getNextHighestDepth());
		
		LogInfo.frameCounter.onEnterFrame = function(){
		
			LogInfo.frameNumber++;
		};
		
	}
		
	public function toString():String{

		// retrieve information about current trace action
		this.classParts = this.fullClassWithMethodName.split("::");
		this.methodName = classParts[1] || "anonymous";
		this.fullClass = classParts[0] || "" ;
		this.className = String(fullClass.split(".").pop()) || "Thunderbolt";
		
		var description:String = fullClassWithMethodName + "[" + lineNumber + "] : " + objectType + " @ " + time;
				
		// cunstruct info object
		return "{" +
		
			"thunderbolt:'" + "                                                    		'," +  
			"description:'" + description 				+ "'," +  
			"method:'"		+ methodName				+ "'," +
			"line:'"		+ lineNumber				+ "'," +
			"type:'"		+ objectType				+ "'," +
			"time:'"		+ time						+ "'," +
			"frame:'"		+ LogInfo.frameNumber 		+ "'," +
			"fullClass:'" 	+ fullClass 				+ "'," +
			"file:'" 		+ fileName 					+ "'," +
			"toString:"		+ "function(){return '" + className + "." + methodName + "'}" +
		"}";		
	}
	
	private function get time():String{

		return (new Date()).toString().split(" ")[3];	
	}
	
	public function checkFrameGroup():Void{
		
		if (LogInfo.frameNumber != LogInfo.lastFrame){
			
			Console.groupEnd();

			var movieUrl:String = _root._url.split("\\").pop().split("/").pop();
			
			Console.group(movieUrl + " [frame " + LogInfo.frameNumber + "] @ " + this.time);
			
			LogInfo.lastFrame = LogInfo.frameNumber;
		}		
	}	
}