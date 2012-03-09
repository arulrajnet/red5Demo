/**
 * File		: AudioConnection.as
 * Date		: Mar 09, 2012
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
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.SyncEvent;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class AudioConnection extends RTMPConnectionImpl
	{
		private static var LOG:ILogger = Log.getLogger('com.demo.connection.AudioConnection');
		private var liveStream:NetStream = null;
//		private var liveAudio:Video = null;		
		public var chatSO:SharedObject = null;
		
		private var microphone:Microphone = null;			
		
		public function AudioConnection()
		{
			super();
		}
		
		public function getConnection():void {
			LOG.debug("Creating audio connection...");
			this.dispatchEvent(new DemoEvent(DemoEvent.AUDIO_CONN_CONNECTING));
			createConnection(this);
		}
		
		public function createSO():void {
			chatSO = SharedObject.getRemote(DemoConstants.CHATSO_PREFIX+FlexGlobals.topLevelApplication.demoChannel.id, this.uri, false);
			chatSO.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			chatSO.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			chatSO.addEventListener(SyncEvent.SYNC, soSyncEventHandler);
			chatSO.client = this;
			chatSO.connect(this);
		}
		
		/**
		 * RPC Functions 
		 */
		public function receiveGroupMessage(message:Object):void {
			if(FlexGlobals.topLevelApplication.demoUser.displayName != message.from) {
				FlexGlobals.topLevelApplication.receiveGroupMessage(message);
			}
		}		
		
		private function lauchLiveStream():void {
			LOG.debug("launch live audio stream");
			liveStream = new NetStream(this);
			liveStream.client = this;
			liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			liveStream.addEventListener("status", streamStatus);
			liveStream.addEventListener("error", streamError);
			liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		
		public function publishLiveAudio():void {
			var microphoneName:String;
			var micArray:ArrayCollection = FlexGlobals.topLevelApplication.demoSettings.micArray;
			var micIndex:int = -1;
			
			if(micArray != null && micArray.length > 0) {
				microphoneName = micArray.getItemAt(FlexGlobals.topLevelApplication.demoSettings.audioMicSelectedItem) as String;
				micIndex = FlexGlobals.topLevelApplication.demoSettings.audioMicSelectedItem;
			}
			
			if(micIndex != -1) {
				microphone = Microphone.getMicrophone(micIndex);
			}
			
			if(liveStream == null) {
				/*Initialize the Netstream for your audio */
				liveStream = new NetStream(this);
				liveStream.client = this;
				liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				liveStream.addEventListener("status", streamStatus);
				liveStream.addEventListener("error", streamError);
				liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			}
			
			LOG.info("Publishing microphone "+microphoneName+ "  "+microphone);
			if(microphone != null) {
				//microphone.codec = SoundCodec.SPEEX;
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
				LOG.info(micDetails);
				liveStream.attachAudio(microphone);
				liveStream.publish(DemoConstants.AUDIO_STREAM_NAME, "live");
			}				
		}		
		
		public function stopLiveAudio():void {
			if(liveStream != null) {
				liveStream.attachAudio(null);
				liveStream.close();
				liveStream = null;
				FlexGlobals.topLevelApplication.demoUser.audio = false;
			}			
		}		
		
		public function playLiveStream():void {
			LOG.debug("play live audio stream");
			if(liveStream == null) {
				/*Initialize the Netstream for your audio */
				liveStream = new NetStream(this);
				liveStream.client = this;
				liveStream.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
				liveStream.addEventListener("status", streamStatus);
				liveStream.addEventListener("error", streamError);
				liveStream.soundTransform.volume = DemoConstants.DEFAULT_SPEAKER_VOLUME * 0.01;
				liveStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			}			
			liveStream.play(DemoConstants.AUDIO_STREAM_NAME, -2, -1, true);			
		}
		
		public function pauseLiveStream():void {
			if(liveStream != null) {
				LOG.debug("pause live audio stream");
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
		
		/*Override functions*/
		override public function netConnectionStatus(event:NetStatusEvent):void {
			LOG.debug("Status : "+event.info.code);
			if(event.info.code == "NetStream.Publish.Start") {
				FlexGlobals.topLevelApplication.adminView.audioPublishButton.label = "Stop";
			} else if(event.info.code == "NetStream.Pause.Notify") {
				FlexGlobals.topLevelApplication.adminView.audioPublishButton.label = "Publish";
			} else if (event.info.code == "NetStream.Unpublish.Success") {
				FlexGlobals.topLevelApplication.adminView.audioPublishButton.label = "Publish";
			} else if(event.info.code == "NetConnection.Connect.Success") {
				createSO();
			}
			super.netConnectionStatus(event);
		}
		
		override public function createConnection(client:Object):void {
			super.createConnection(this);
		}
	}
}
