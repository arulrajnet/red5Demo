/**
 * File		: Settings.as
 * Date		: Mar 09, 2012
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.models
{
	import com.demo.utils.DemoConstants;
	
	import flash.media.Camera;
	import flash.media.Microphone;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Settings
	{
		public var cameraArray:ArrayCollection = new ArrayCollection(Camera.names);
		
		public var micArray:ArrayCollection = new ArrayCollection(Microphone.names);
		
		public var frameRate:int = DemoConstants.CAMERA_FPS;
		
		public var micVolume:int = DemoConstants.AUDIO_GAIN;
		
		public var camSeletedItem:int = 0;
		
		public var fmMicSelectedItem:int = 0;
		
		public var videoMicSelectedItem:int = 0;
		
		public var camSelectedName:String;
		
		public var fmMicSelectedName:String;
		
		public var videoMicSelectedName:String;

		public var videoOption:int = 1;
		
		public var camQuality:int = DemoConstants.CAMERA_QUALITY;
		
		public var micQuality:int = DemoConstants.AUDIO_QUALITY;
		
		public var fmVolume:int = DemoConstants.DEFAULT_SPEAKER_VOLUME;
		
		public var videoVolume:int = DemoConstants.DEFAULT_SPEAKER_VOLUME;
		
		public function Settings()
		{
		}
	}
}
