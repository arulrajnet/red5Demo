/**
 * File		: Role.as
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
	public class Role
	{
		public static const ADMIN:Role = new Role("admin");
		
		public static const PLAYER:Role = new Role("player");
		
		public static const ANONYMOUS:Role = new Role("anonymous");
		
		public var name:String = null;
		
		public function Role(name:String)
		{
			this.name = name;
		}
		
		public function toString():String {
			return StringUtil.substitute("[Class Role] name {0}",name);
		}
	}
}
