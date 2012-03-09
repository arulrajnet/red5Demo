/**
 * File		: DemoConstants.as
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

	[Bindable]
	public class DemoConstants
	{
		/*rtmp constants*/
		public static const MAIN_APP:String = "red5Demo";
//		public static const MAIN_APP:String = "oflaDemo";
		public static const RTMP_PORT:Number = 1935;
		public static const HTTP_PORT:Number = 5080;
		public static const DEFAULT_ROLE:Role = Role.PLAYER;
		
		public static const AUDIO_STREAM_NAME:String = "livestreamaudio";
		public static const VIDEO_STREAM_NAME:String = "livestreamvideo";
		
		/*camera properties*/
		public static const CAMERA_BANDWIDTH:int = 0;
		public static const CAMERA_QUALITY:int = 75;
		public static const CAMERA_FPS:int = 13;
		
		/*microphone properties*/
		public static const AUDIO_RATE:int = 16;
		public static const AUDIO_PACKET:int = 2;
		public static const AUDIO_GAIN:int = 90;
		public static const AUDIO_SILENCE_LEVEL_TIMEOUT:int = 5000; //ms
		public static const AUDIO_QUALITY:int = 7;
		public static const DEFAULT_SPEAKER_VOLUME:int = 90;
		
		/*video properties 4:3 ratio*/
		public static const ADMIN_VIDEO_WIDTH:Number = 320;
		public static const ADMIN_VIDEO_HEIGHT:Number = 240;
		public static const PUBLISH_VIDEO_WIDTH:Number = 640;
		public static const PUBLISH_VIDEO_HEIGHT:Number = 480;
		public static const PLAYER_VIDEO_WIDTH:Number = 320;
		public static const PLAYER_VIDEO_HEIGHT:Number = 240;		
		
		/*Non-member constants*/
		public static const GUEST_ID:String = "Guest";
		public static const ALL:String = "All";
		
		/*chat properties*/
		public static const CHATSO_PREFIX:String = "chatso-";
		public static const DEFAULT_CHAT_COLOR:uint = 0x000000;

	}
}
