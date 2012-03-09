/**
 * File		: PublicConnection.as
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
	import com.demo.utils.CommonUtility;
	import com.demo.utils.DemoEvent;
	
	import flash.external.ExternalInterface;
	
	import mx.core.FlexBitmap;
	import mx.core.FlexGlobals;
	import mx.events.PropertyChangeEvent;
	import mx.logging.ILogger;
	import mx.logging.Log;

	public class PublicConnection extends RTMPConnectionImpl
	{
		private static var LOG:ILogger = Log.getLogger('com.demo.connection.PublicConnection');
		
		public function PublicConnection()
		{
			super();
		}
		
		public function getConnection():void {
			LOG.debug("Creating public connection...");
			this.dispatchEvent(new DemoEvent(DemoEvent.PUBLIC_CONN_CONNECTING));
			super.createConnection(this);
		}
		
		/**
		 * RPC Calls 
		 */
		public function updateUser(result:Object):void {
			LOG.debug("update user : "+result.id);
			FlexGlobals.topLevelApplication.demoUser = CommonUtility.getUser(result);
		}
		
		public function updateRoom(result:Object):void {
			LOG.debug("UpdateRoom : call directly "+FlexGlobals.topLevelApplication.demoUser.id);
			FlexGlobals.topLevelApplication.refreshUserBox();
		}
		
		public function updateRoomInit(result:Object):void {
			updateRoom(result);
		}
		
		public function updateRecordedFiles(result:Object):void {
			LOG.debug("recorded Files",result);
			FlexGlobals.topLevelApplication.recordedFiles = result;
			FlexGlobals.topLevelApplication.refreshRecordBox();
		}
		
		public function onRoomChange(event:PropertyChangeEvent):void {
			LOG.debug("on change room property "+event.toString());
			/*LOG.debug("kind "+event.kind);
			LOG.debug("new value "+event.newValue);
			LOG.debug("old value "+event.oldValue);
			LOG.debug("property "+event.property);
			LOG.debug("source "+event.source);*/
			
			if(event.property != null && event.property == "goLive") {
				FlexGlobals.topLevelApplication.togglePlay();
			}
		}
	}
}
