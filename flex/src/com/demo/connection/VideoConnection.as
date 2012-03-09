/**
 * File		: VideoConnection.as
 * Date		: Mar 09, 2011
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.connection
{
	import com.demo.utils.DemoConstants;
	import com.demo.utils.DemoEvent;
	
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class VideoConnection extends RTMPConnectionImpl
	{
		private static var LOG:ILogger = Log.getLogger('com.demo.connection.VideoConnection');
		private var liveStream:NetStream = null;
		private var liveVideo:Video = new Video(DemoConstants.ADMIN_VIDEO_WIDTH, DemoConstants.ADMIN_VIDEO_HEIGHT);		
		
		private var camera:Camera = null;
		private var microphone:Microphone = null;		
		
		public function VideoConnection()
		{
			super();
		}
		
		public function getConnection():void {
			LOG.debug("Creating video connection...");
			this.dispatchEvent(new DemoEvent(DemoEvent.VIDEO_CONN_CONNECTING));
			super.createConnection(this);
		}
		
		private function lauchLiveStream():void {
			LOG.debug("launch live video stream");
			liveStream = new NetStream(this);
			liveStream.client = this;
			liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			liveStream.addEventListener("status", streamStatus);
			liveStream.addEventListener("error", streamError);
			liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		
		public function publishLiveVideo(event:FlexEvent=null):void {
			LOG.debug("demoUser tostring : "+ FlexGlobals.topLevelApplication.demoUser.toString());
			if(!FlexGlobals.topLevelApplication.demoUser.video){
				var cameraName:String;
				var cameraArray:ArrayCollection = FlexGlobals.topLevelApplication.demoSettings.cameraArray;
				var camIndex:int = -1;
				
				if(cameraArray != null && cameraArray.length > 0) {
					cameraName = cameraArray.getItemAt(FlexGlobals.topLevelApplication.demoSettings.camSeletedItem) as String;
					camIndex = FlexGlobals.topLevelApplication.demoSettings.camSeletedItem;
				}
				
				if(camIndex != -1) {
					camera = Camera.getCamera(camIndex as String);
				}
				
				var microphoneName:String;
				var micArray:ArrayCollection = FlexGlobals.topLevelApplication.demoSettings.micArray;
				var micIndex:int = -1;
				
				if(micArray != null && micArray.length > 0) {
					microphoneName = micArray.getItemAt(FlexGlobals.topLevelApplication.demoSettings.videoMicSelectedItem) as String;
					micIndex = FlexGlobals.topLevelApplication.demoSettings.videoMicSelectedItem;
				}
				
				if(micIndex != -1) {
					microphone = Microphone.getMicrophone(micIndex);
				}
				
				LOG.info("Publishing camera "+cameraName+ "  "+camera);
				
				LOG.debug("cameraArray "+cameraArray);
				LOG.debug("cameraArray.length "+cameraArray.length);
				LOG.debug("camIndex "+camIndex);
				
				/*Initialize the Netstream for your video*/
				if(liveStream == null) {
					liveStream = new NetStream(this);
					liveStream.client = this;
					liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
					liveStream.addEventListener("status", streamStatus);
					liveStream.addEventListener("error", streamError);
					liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				}
				
				if(liveVideo == null) {
					liveVideo = new Video(DemoConstants.ADMIN_VIDEO_WIDTH, DemoConstants.ADMIN_VIDEO_HEIGHT);;
				}
				
				if(camera != null) {
					camera.addEventListener(StatusEvent.STATUS, onCamStatus);
					
					/*Initialize the camera properties*/
					camera.setMode(DemoConstants.PUBLISH_VIDEO_WIDTH, DemoConstants.PUBLISH_VIDEO_HEIGHT, DemoConstants.CAMERA_FPS, true);
					camera.setQuality(DemoConstants.CAMERA_BANDWIDTH, DemoConstants.CAMERA_QUALITY);
					camera.addEventListener(ActivityEvent.ACTIVITY, onVideoActivity);
					
					liveStream.attachCamera(camera);
					liveVideo.attachCamera(camera);
					liveVideo.x = 0;
					liveVideo.y = 0;
					FlexGlobals.topLevelApplication.adminView.liveVideoDisplay.addChild(liveVideo);
				} else {
					/* Add a black window? */
					LOG.debug("camera not published");
					FlexGlobals.topLevelApplication.demoUser.video = false;
					this.dispatchEvent(new DemoEvent(DemoEvent.VIDEO_NOT_AVAILABLE));
				}
				
				LOG.info("Publishing microphone "+microphoneName+ "  "+microphone);
				if(microphone != null) {
					microphone.codec = SoundCodec.SPEEX;
					microphone.encodeQuality = DemoConstants.AUDIO_QUALITY;
					microphone.rate = DemoConstants.AUDIO_RATE;
					microphone.framesPerPacket = DemoConstants.AUDIO_PACKET;
					microphone.gain = FlexGlobals.topLevelApplication.demoSettings.micVolume;
					microphone.setUseEchoSuppression(true); 
					microphone.setLoopBack(false); 
					microphone.setSilenceLevel(0, DemoConstants.AUDIO_SILENCE_LEVEL_TIMEOUT); 
					//microphone.setSilenceLevel(10, 20000);
					
					microphone.addEventListener(ActivityEvent.ACTIVITY, this.onMicActivity); 
					microphone.addEventListener(StatusEvent.STATUS, this.onMicStatus); 
					
					var micDetails:String = '\n'+"Sound input device name: " + microphone.name + '\n'; 
					micDetails += "Gain: " + microphone.gain + '\n'; 
					micDetails += "Rate: " + microphone.rate + " kHz" + '\n'; 
					micDetails += "Muted: " + microphone.muted + '\n';
					micDetails += "Quality: " + microphone.encodeQuality + '\n';
					micDetails += "Frames / Packet: " + microphone.framesPerPacket + '\n';
					micDetails += "Silence level: " + microphone.silenceLevel + '\n'; 
					micDetails += "Silence timeout: " + microphone.silenceTimeout + '\n'; 
					micDetails += "Echo suppression: " + microphone.useEchoSuppression + '\n';
					//micDetails += "Noise suppression level: " + microphone.noiseSuppressionLevel + '\n';
					LOG.info(micDetails);
					liveStream.attachAudio(microphone);
				}				
				
				if (microphone != null || camera != null) {
					liveStream.publish(FlexGlobals.topLevelApplication.demoUser.id,"live");
				}
			}	
		}		
		
		public function stopLiveVideo():void {
			if(liveStream != null) {
				liveStream.attachAudio(null);
				liveStream.attachCamera(null);
				liveStream.close();
				FlexGlobals.topLevelApplication.demoUser.video = false;
				liveStream = null;
				if(liveVideo != null) {
					liveVideo.attachCamera(null);
					liveVideo = null;
				}
			}			
		}
		
		public function playLiveStream():void {
			LOG.debug("play live video stream");
			/*Initialize the Netstream for your video*/
			if(liveStream == null) {
				liveStream = new NetStream(this);
				liveStream.client = this;
				liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				liveStream.addEventListener("status", streamStatus);
				liveStream.addEventListener("error", streamError);
				liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				liveStream.soundTransform.volume = DemoConstants.DEFAULT_SPEAKER_VOLUME * 0.01;
				liveVideo = new Video(FlexGlobals.topLevelApplication.playerView.videoPlayer.liveVideoDisplay.width, 
									FlexGlobals.topLevelApplication.playerView.videoPlayer.liveVideoDisplay.height);
				liveVideo.attachNetStream(liveStream);
				FlexGlobals.topLevelApplication.playerView.videoPlayer.liveVideoDisplay.addChild(liveVideo);
			}			
			liveStream.play(DemoConstants.VIDEO_STREAM_NAME, -2, -1, true);
		}
		
		public function pauseLiveStream():void {
			if(liveStream != null) {
				LOG.debug("pause live video stream");
				liveStream.pause();
			}
		}
		
		public function changeMicVolume(value:Number):void {
			if(microphone != null) {
				var st:SoundTransform = microphone.soundTransform
				st.volume = value * .01;
				microphone.soundTransform = st;
				microphone.gain = value;
			}
		}
		
		public function changeSpeakarVolume(value:Number):void {
			if(liveStream != null) {
				var st:SoundTransform = liveStream.soundTransform;
				st.volume = value * .01;
				liveStream.soundTransform = st;
			}
		}
		
		public function changeVideoDimention(width:Number, height:Number):void {
			liveVideo.x = 0;
			liveVideo.y = 0;
			liveVideo.width = width;
			liveVideo.height = height;
		}
		
		/*Override functions*/
		override public function netConnectionStatus(event:NetStatusEvent):void {
			if(event.info.code == "NetStream.Publish.Start") {
				FlexGlobals.topLevelApplication.adminView.videoPublishButton.label = "Stop";
			} else if(event.info.code == "NetStream.Pause.Notify") {
				FlexGlobals.topLevelApplication.adminView.videoPublishButton.label = "Publish";
			} else if (event.info.code == "NetStream.Unpublish.Success") {
				FlexGlobals.topLevelApplication.adminView.videoPublishButton.label = "Publish";
			}
			super.netConnectionStatus(event);
		}
	}
}
