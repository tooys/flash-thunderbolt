import org.osflash.thunderbolt.data.Parser;

/**
 * @author kleppe
 */
class org.osflash.thunderbolt.data.StringyfiedObject {
	
	private var dataString:String;
	
	function StringyfiedObject(data:Object){
	
		this.dataString = Parser.stringify(data);	
	}
	
	public function toString():String{
		
		return dataString;
	}
}