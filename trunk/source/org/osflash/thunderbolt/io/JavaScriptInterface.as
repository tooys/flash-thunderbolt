import org.osflash.thunderbolt.Settings;
/**
 * @author Martin Kleppe <kleppe@gmail.com>
 */
class org.osflash.thunderbolt.io.JavaScriptInterface {

	private static var codeSnippet:String =  
	
		"var ThunderBolt = {" +
		
		"	storedTarget: null," +
		
		// display structure of flash target
		"	inspect: function(target){" +
		"		this.getFlash().inspect(this.getFullTarget(target));" +
		"	}," +
		
		// run an expression within flash
		"	run: function(expression){" +
		"		this.getFlash().run(expression);" +
		"	}," +
		
		// assign a new value to the target
		"	set: function(target, value){" +
		"		this.getFlash().set(this.getFullTarget(target), value);" +
		"	}," +
		
		"	profile: function(target){" +
		"		this.getFlash().profile(target);" +
		"	}," +
		
		"	profileEnd: function(target){" +
		"		this.getFlash().profileEnd();" +
		"	}," +
		
		// set the target for future actions
		"	cd: function(path){" +
		
		"		if (path.indexOf('_root') == 0){" +
		"			this.storedTarget = path;	" +
		"		} else if (path){" +
		"			switch(path){" +
		"				case '.':	" +
		"				case '/': 	this.storedTarget = null; break;" +
		"				case '..':	this.storedTarget = this.storedTarget.split('.').slice(0,-1).join('.'); break;" +
		"				default: 	this.storedTarget = this.storedTarget ? this.storedTarget + '.' + path : path;" +
		"			}" +
		"		}" +
		"		this.inspect();" +
		"	}," +
	
		"	getFlash: function(){" +
				// returns the first flash movie in document
		"		return document.getElementsByTagName('embed')[0];		" +
		"	}," +
	
		// private method" 
		"	getFullTarget: function(target){" +
		"		if (!target){" +
		"			return this.storedTarget;" +
		"		} else {" +
		"			if (target.indexOf('_root') == 0) {" +
		"				return target;" +
		"			} else {" +
		"				return this.storedTarget ? this.storedTarget + '.' + target : target; " +
		"			}" +
		"		}" +
		"	}" +
		"};";
		
	public static function injectCode(){
	
		getURL("javascript:" + JavaScriptInterface.codeSnippet);
		getURL("javascript:var " + Settings.JAVASCRIPT_CONSOLE_SHORTCUT + " = ThunderBolt;");
	};
}