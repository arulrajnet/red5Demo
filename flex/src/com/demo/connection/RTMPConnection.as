/**
 * File		: RTMPConnection.as
 * Date		: Mar 09, 2012
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.connection
{
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;

	public interface RTMPConnection
	{
		function createConnection(client:Object):void;
		
		function netConnectionStatus(event:NetStatusEvent):void;
		
		function netConnectionClose(event:NetStatusEvent):void;
		
		function asyncErrorHandler(event:AsyncErrorEvent):void;		
		
	}
}
