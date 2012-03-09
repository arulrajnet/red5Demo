/**
 * File		: Channel.as
 * Date		: Mar 09, 2012
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.models
{
	import mx.utils.StringUtil;

	[Bindable]
	public class Channel
	{
		public var id:String;
		
		public var title:String;
		
		public var description:String;
		
		public var channelName:String;
		
		public var password:String;
		
		public var maxUser:int;
		
		public var members:Array = new Array();
		
		public var enabled:Boolean = true;
		
		public var recorded:Boolean = true;
		
		public var startedAt:Date;
		
		public var expiresAt:Date;
		
		public function Channel(id:String)
		{
			this.id = id;
		}
		
		public function toString():String{
			return StringUtil.substitute("[Class Channel] id {0}, title {1}, description {2}, " +
				"channelName {3}, password {4}, maxUser {5}, members {6}, enabled {7}, " + 
				"recorded {8}, startedAt {9}, expiresAt {10}",
				id, title, description, channelName, password, maxUser, members, enabled, recorded, startedAt, expiresAt);
		}		
	}
}
