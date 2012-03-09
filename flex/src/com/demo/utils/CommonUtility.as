/**
 * File		: CommonUtility.as
 * Date		: Mar 09, 2012
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.utils
{
	import com.demo.models.Role;
	import com.demo.models.User;
	import com.demo.utils.DemoEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.utils.StringUtil;

	public class CommonUtility
	{
		private static var LOG:ILogger = Log.getLogger('com.demo.utils.CommonUtility');
		
		public function CommonUtility()
		{
		}
		
		public static function getCurrentTime():String {
			var currentDate:Date = new Date();
			var dateFormat:DateFormatter = new DateFormatter();
			dateFormat.formatString = "HH:NN:SS> ";
			return dateFormat.format(currentDate);			
		}	
		
		public static function dispatchEvent(event:DemoEvent):void {
			var dispatcher:EventDispatcher  = new EventDispatcher();
			dispatcher.dispatchEvent(event);
		}
		
		public static function getRole(name:String):Role {
			name = name.toLowerCase();
			var retVal:Role;
			switch(name) {
				case Role.ADMIN.name:
					retVal = Role.ADMIN;
					break;
				
				case Role.PLAYER.name:
					retVal = Role.PLAYER;
					break;
				
				case Role.ANONYMOUS.name:
					retVal = Role.ANONYMOUS;
					break;
				
				default:
					retVal = Role.ANONYMOUS;
			}
			return retVal;
		}
		
		public static function getUser(obj:Object):User {
			var demoUser:User = new User(obj.id);
			if(obj.id != DemoConstants.GUEST_ID) {
				demoUser.loginName = obj.loginName;
				demoUser.displayName = obj.displayName;
				demoUser.sex = obj.sex;
				demoUser.role = getRole(obj.role as String);				
				demoUser.place = obj.place;
				demoUser.audio = obj.audio;
				demoUser.video = obj.video;
			}
			return demoUser;
		}
		
		public static function getUsers(obj:Object):Array {
			var demoUsers:Array = new Array();
			var objArray:Array = obj as Array;
			for(var i:int=0; i < objArray.length; i++) {
				demoUsers[i] = getUser(objArray[i])
			}
			return demoUsers;
		}
		
		public static function getRandomColor():uint {
			var min:uint = 1;
			var max:uint = (256*256*256) - 1;
			var scale:Number = max - min;
			return Math.random() * scale;			
		}
		
		public static function getFileSizeFormat(size:Number):String {
			var retVal:String;
			var baseSize:Number = 1024;
			var factor:Number = 100;
			if( size < baseSize) {
				retVal = size + " bytes";
			} else if(size < (baseSize * baseSize)) {
				retVal = toFixed(size / baseSize, factor) + " KB";
			} else if(size < (baseSize * baseSize * baseSize)) {
				retVal = toFixed(size/(baseSize * baseSize), factor) + " MB";
			} else if(size >= (baseSize * baseSize * baseSize)) {
				retVal = toFixed(size/(baseSize * baseSize * baseSize), factor) + " GB";
			} else {
				retVal = size + " bytes";
			}
			return retVal;
		}
		
		private static function toFixed(number:Number, factor:Number):Number {
			return Math.round(number * factor) / factor;
		}		
		
		/**
		 * remove the html tags in chat
		 */
		public static function stripHtmlTags(html:String, tags:String = ""):String
		{
			var tagsToBeKept:Array = new Array();
			if (tags.length > 0)
				tagsToBeKept = tags.split(new RegExp("\\s*,\\s*"));
			
			var tagsToKeep:Array = new Array();
			for (var i:int = 0; i < tagsToBeKept.length; i++)
			{
				if (tagsToBeKept[i] != null && tagsToBeKept[i] != "")
					tagsToKeep.push(tagsToBeKept[i]);
			}
			
			var toBeRemoved:Array = new Array();
			var tagRegExp:RegExp = new RegExp("<([^>\\s]+)(\\s[^>]+)*>", "g");
			
			var foundedStrings:Array = html.match(tagRegExp);
			for (i = 0; i < foundedStrings.length; i++) 
			{
				var tagFlag:Boolean = false;
				if (tagsToKeep != null) 
				{
					for (var j:int = 0; j < tagsToKeep.length; j++)
					{
						var tmpRegExp:RegExp = new RegExp("<\/?" + tagsToKeep[j] + "( [^<>]*)*>", "i");
						var tmpStr:String = foundedStrings[i] as String;
						if (tmpStr.search(tmpRegExp) != -1) 
							tagFlag = true;
					}
				}
				if (!tagFlag)
					toBeRemoved.push(foundedStrings[i]);
			}
			for (i = 0; i < toBeRemoved.length; i++) 
			{
				var tmpRE:RegExp = new RegExp("([\+\*\$\/])","g");
				var tmpRemRE:RegExp = new RegExp((toBeRemoved[i] as String).replace(tmpRE, "\\$1"),"g");
				html = html.replace(tmpRemRE, "");
			} 
			return html;
		}
	}
}
