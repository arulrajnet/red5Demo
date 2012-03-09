/**
 * File		: User.as
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
	public class User
	{
		public var id:String;
		
		public var loginName:String;
		
		public var displayName:String;
		
		public var sex:String;
		
		public var role:Role;
		
		public var place:String;

		public var broadcastTime:int;
		
		public var video:Boolean;
		
		public var audio:Boolean;
		
		public function User(id:String)
		{
			this.id = id;
		}
		
		public function toString():String {
			return StringUtil.substitute("[Class User] id {0}, loginName {1} displayName {2}, " +
				"sex {3}, role {4}, place {5}, broadcastTime {8}, video {6}, audio {7}",id, loginName, displayName,
				sex, role.toString(), place, video, audio, broadcastTime);
		}
	}
}
