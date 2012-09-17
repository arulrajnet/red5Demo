/**
 * File		: RTMPConnectionImpl.as
 * Date		: Mar 09, 2011
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://www.arulraj.net
 * Description :
 * History	:
 */

package com.demo.connection
{
	import com.demo.models.Role;
	import com.demo.utils.DemoConstants;
	import com.demo.utils.DemoEvent;
	
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	import mx.core.FlexGlobals;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class RTMPConnectionImpl extends NetConnection implements RTMPConnection
	{
		private static var LOG:ILogger = Log.getLogger('com.demo.connection.RTMPConnectionImpl');
		private var hostname:String;
		private var scope:String;
		private var port:Number;
		private var isHttps:Boolean;
		private var clientObj:Object;
		
		public function RTMPConnectionImpl()
		{
			super();
			initConnectionVars();
		}
		
		private function initConnectionVars():void {
			hostname = FlexGlobals.topLevelApplication.hostname;
			scope = FlexGlobals.topLevelApplication.context;
			port = FlexGlobals.topLevelApplication.rtmpPort;
			isHttps = FlexGlobals.topLevelApplication.issecure;
		}
		
		/**
		 * START : Implemnted functions
		 */
		
		public function createConnection(client:Object):void
		{
			var connectionName:String = "publicConn";
			var scope:String = this.scope;
			this.clientObj = client;
			LOG.info("you are connecting to "+this.hostname+"..."+" client object "+clientObj);
			
			this.objectEncoding = ObjectEncoding.AMF3;
			this.addEventListener(NetStatusEvent.NET_STATUS, netConnectionStatus);
			this.addEventListener(Event.CLOSE, netConnectionClose);
			this.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this.proxyType = "best";			
			this.client = clientObj;
			
			if(clientObj is PublicConnection) {
				connectionName = "publicConn";
			} else if (clientObj is VideoConnection) {
				connectionName = "videoConn";
			} else if (clientObj is AudioConnection) {
				connectionName = "audioConn";
			}
			
			if(FlexGlobals.topLevelApplication.demoUser.role == Role.ADMIN) {
				scope = this.scope+"/"+FlexGlobals.topLevelApplication.demoChannel.channelName;
			} else {
				scope = this.scope+"/"+FlexGlobals.topLevelApplication.demoChannel.channelName;
			}
			
			if (this.isHttps) {
				this.connect("rtmps://" + this.hostname + ":"+this.port+"/"+scope, connectionName, FlexGlobals.topLevelApplication.demoUser);
			} else {
				this.connect("rtmp://" + this.hostname + ":"+this.port+"/"+scope, connectionName, FlexGlobals.topLevelApplication.demoUser);
			}
		}
		
		public function netConnectionStatus(event:NetStatusEvent):void
		{
			LOG.debug("Status : "+event.info.code);
			if (event.info.code == "NetConnection.Connect.Success") {
				
				if(clientObj is PublicConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.PUBLIC_CONN_SUCCESS));
				} else if (clientObj is VideoConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.VIDEO_CONN_SUCCESS));
				} else if (clientObj is AudioConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.AUDIO_CONN_SUCCESS));
				}
				
			} else if (event.info.code == "NetConnection.Connect.Closed") {
				if(clientObj is PublicConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.PUBLIC_CONN_CLOSED));
				} else if (clientObj is VideoConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.VIDEO_CONN_CLOSED));
				} else if (clientObj is AudioConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.AUDIO_CONN_CLOSED));
				}				
			} else if (event.info.code == "NetConnection.Connect.Failed" ||
								event.info.code == "NetConnection.Connect.Rejected") {
				if(clientObj is PublicConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.PUBLIC_CONN_FAILED));
				} else if (clientObj is VideoConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.VIDEO_CONN_FAILED));
				} else if (clientObj is AudioConnection) {
					this.dispatchEvent(new DemoEvent(DemoEvent.AUDIO_CONN_FAILED));
				}				
			} else if (event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Play.Start") {
				
			} else if(event.info.code == "NetStream.Publish.Start") {
				if(clientObj is PublicConnection) {
				}				
			} else if(event.info.code == "NetStream.Unpublish.Success") {
				if(clientObj is PublicConnection) {
				}		
			} else if(event.info.code == "NetStream.Publish.BadName") {
				if(clientObj is PublicConnection) {
				}							
			} else if(event.info.code == "NetStream.Play.UnpublishNotify") {
				
			} else if(event.info.code == "NetStream.Record.Stop") {
				
			}			
		}
		
		public function netConnectionClose(event:NetStatusEvent):void
		{
			LOG.debug("net Connection close "+event.info);
		}
		
		public function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			LOG.debug(event.text)
		}
		
		public function soSyncEventHandler(event:SyncEvent):void {
			LOG.debug("SO sync Event : "+event);
		}
		
		/**
		 * END : Implemnted functions
		 */		
		
		public function streamStatus(evtObject:Object):void {
			
		}
		
		public function streamError(evtObject:Object):void {
			
		}
		
		public function onVideoActivity(event:ActivityEvent):void {
			
		}
		
		public function onMicActivity(event:ActivityEvent):void { 
			
		}

		/**
		 * START: Netstream callback methods
		 */

		public function onMetaData(infoObject:Object):void {
		    LOG.debug("metadata");
		}

		public function onImageData(infoObject:Object):void {
		    LOG.debug("imagedata");
		}

		public function onTextData(infoObject:Object):void {
		    LOG.debug("textdata");
		}

		public function onXMPData(infoObject:Object):void {
		    LOG.debug("xmpdata");
		}
		 
		public function onCuePoint(infoObject:Object):void {
		    LOG.debug("cue point");
		}

		public function onPlayStatus(infoObject:Object):void {
		    LOG.debug("play status");			
		}

		/**
		 * END: Netstream callback methods
		 */ 
		
		public function onMicStatus(event:StatusEvent):void { 
			switch(event.code) {
				case "Microphone.Muted":
					FlexGlobals.topLevelApplication.demoUser.audio = false;
					break;
				case "Microphone.Unmuted":
					FlexGlobals.topLevelApplication.demoUser.audio = true;
					break;
			}			
		}
		
		public function onCamStatus(event:StatusEvent):void {
			switch(event.code) {
				case "Camera.Muted":
					FlexGlobals.topLevelApplication.demoUser.video = false;
					FlexGlobals.topLevelApplication.demoSettings.videoOption = 1;
//					FlexGlobals.topLevelApplication.camNotAllowInfoPopup(null);
					break;
				case "Camera.Unmuted":
					FlexGlobals.topLevelApplication.demoUser.video = true;
					FlexGlobals.topLevelApplication.demoSettings.videoOption = 0;
					break;
			}
		}
	}
}
