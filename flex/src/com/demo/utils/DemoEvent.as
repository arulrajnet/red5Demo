/**
 * File		: DemoEvent.as
 * Date		: Mar 09, 2012
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.utils
{
	import flash.events.Event;

	public class DemoEvent extends Event
	{
		public static const PUBLIC_CONN_CONNECTING:String = "connection.public.connecting";
		public static const VIDEO_CONN_CONNECTING:String = "connection.video.connecting";
		public static const AUDIO_CONN_CONNECTING:String = "connection.video.connecting";		
		
		public static const PUBLIC_CONN_SUCCESS:String = "connection.public.success";
		public static const VIDEO_CONN_SUCCESS:String = "connection.video.success";
		public static const AUDIO_CONN_SUCCESS:String = "connection.audio.success";
		
		public static const PUBLIC_CONN_FAILED:String = "connection.public.failed";
		public static const VIDEO_CONN_FAILED:String = "connection.video.failed";
		public static const AUDIO_CONN_FAILED:String = "connection.audio.failed";
		
		public static const PUBLIC_CONN_CLOSED:String = "connection.public.closed";
		public static const VIDEO_CONN_CLOSED:String = "connection.video.closed";
		public static const AUDIO_CONN_CLOSED:String = "connection.audio.closed";
		
		public static const VIDEO_PUBLISHED:String = "netstream.video.published";
		public static const AUDIO_PUBLISHED:String = "netstream.audio.published";
		public static const VIDEO_AUDIO_PUBLISHED:String = "video.audio.published";
		
		public static const VIDEO_NOT_AVAILABLE:String = "video.available.false";
		public static const AUDIO_NOT_AVAILABLE:String = "audio.available.false";		
		
		/**
		 * By Default bubbles are true. Then only we can listen anywhere in the  
		 * application
		 */
		public function DemoEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}		
	}
}
