/**
 * File		: Red5Demo.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.application;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.red5.io.utils.ObjectMap;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.ScopeUtils;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.stream.IBroadcastStream;
import org.red5.server.api.stream.ISubscriberStream;
import org.red5.server.api.stream.ResourceExistException;
import org.red5.server.api.stream.ResourceNotFoundException;
import org.red5.server.stream.ClientBroadcastStream;
import org.slf4j.Logger;
import org.springframework.context.ApplicationContext;

import com.demo.model.Channel;
import com.demo.model.User;
import com.demo.so.ChatSOSecurity;
import com.demo.utils.DemoConstants;

/**
 * @author arul
 *
 */
public class Red5Demo extends Application {

	static final Logger LOG = Red5LoggerFactory.getLogger(Red5Demo.class, DemoConstants.APP_NAME);
	
	static IScope staticScope;
	
	boolean channelRecord;
	
	/**
	 * Get red5 bean class using bean id
	 * @param beanId
	 * @return
	 */
	public Object getBean(String beanId) {
		ApplicationContext appContext = globalScope.getContext().getApplicationContext();
		return appContext.getBean(beanId);
	}
	
  /**
   * @return the channelRecord
   */
  public boolean isChannelRecord() {
    return channelRecord;
  }
  
  /**
   * @param channelRecord the channelRecord to set
   */
  public void setChannelRecord(boolean channelRecord) {
    this.channelRecord = channelRecord;
  }

  /**
	 * Private functions
	 */
  private ISharedObject getChatSO(String channelName) {
    return getSharedObject(scopeMap.get(channelName), DemoConstants.CHATSO_PREFIX+channelName);
  }	
	
	/**
	 * START: override functions
	 */
	
	/* (non-Javadoc)
	 * @see com.live.application.Application#appStart(org.red5.server.api.IScope)
	 */
	@Override
	public boolean appStart(IScope scope) {
		boolean retVal = super.appStart(scope);
		if(retVal) {
			staticScope = scope;
			registerSharedObjectSecurity(new ChatSOSecurity());
		}
		return retVal;
	}

  /*
   * (non-Javadoc)
   * 
   * @see
   * org.red5.server.adapter.MultiThreadedApplicationAdapter#appStop(org.red5
   * .server.api.IScope)
   */
  @Override
  public void appStop(IScope scope) {
    super.appStop(scope);
  }	
	
	 @Override
	  public void streamPublishStart(IBroadcastStream stream) {
	   String publishedName = stream.getPublishedName();
	   LOG.info("streamPublishStart scope {}", stream.getScope().toString());
       
       if(channelRecord) {
         /**
          * Record user streams
          */
         ClientBroadcastStream broadcastStream = (ClientBroadcastStream) stream;
         if (!broadcastStream.isRecording()) {
            try {
              SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
              String folderName = format.format(new Date()).toString();            
              broadcastStream.saveAs(folderName+File.separator+usersMap.get(publishedName).getLoginName(), true);
            } catch (IOException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            } catch (ResourceNotFoundException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            } catch (ResourceExistException e) {
              // TODO Auto-generated catch block
              e.printStackTrace();
            }
         }
       }
	   super.streamPublishStart(stream);
	 }
	 
	 /* (non-Javadoc)
	 * @see com.demo.application.Application#connect(org.red5.server.api.IConnection, org.red5.server.api.IScope, java.lang.Object[])
	 */
	@Override
	public boolean connect(IConnection connection, IScope scope, Object[] params) {
	  String connectionName;
	  String channelName;
	  Channel demoChannel;
	  if (ScopeUtils.isRoom(scope))
	  {
      if (params.length > 1) {
        connectionName = (String) params[0];
        LOG.info("this scope {}", scope.toString());    
        if (connectionName
            .equals(DemoConstants.CONNECTIONS.get(0))) {
          /* For public connection */
          channelName = scope.getName();
          if(!channelsMap.containsKey(channelName)) {
            demoChannel = new Channel(channelName);
            demoChannel.setChannelName(channelName);
            channelsMap.put(channelName, demoChannel); 
            scopeMap.put(channelName, scope);
          }
        }
      }	    
	  }
	  return super.connect(connection, scope, params);
	}
	
	 @Override
	  public void streamBroadcastClose(IBroadcastStream stream) {
      ClientBroadcastStream broadcastStream = (ClientBroadcastStream) stream;
      if (broadcastStream.isRecording()) {
        broadcastStream.stopRecording();
      }       
	    super.streamBroadcastClose(stream);
	  }	 
	
	/* (non-Javadoc)
	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#streamSubscriberStart(org.red5.server.api.stream.ISubscriberStream)
	 */
	@Override
	public void streamSubscriberStart(ISubscriberStream stream) {
		LOG.debug("Subscriber start for the stream : "+stream.getName());
		super.streamSubscriberStart(stream);
	}
	
	/* (non-Javadoc)
	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#streamSubscriberClose(org.red5.server.api.stream.ISubscriberStream)
	 */
	@Override
	public void streamSubscriberClose(ISubscriberStream stream) {
		LOG.debug("Subscriber close for the stream : "+stream.getName());
		super.streamSubscriberClose(stream);
	}
	
	/**
	 * END: override function
	 */
	
	/**
	 * START: RPC functions
	 */
	
  /**
   * Update the user info from flex
   * @param flexDemoUser
   */
  public void updateUserInfo(ObjectMap<String, Object> flexDemoUser) {
    String userid = (String) flexDemoUser.get("id");
    User user = usersMap.get(userid);
    utility.updateUserInfo(flexDemoUser, user);
  }
  
  /**
   * Update the channel info from flex
   * @param flexFmUser
   */
  public void updateChannelInfo(ObjectMap<String, Object> flexDemoChannel) {
    String channelid = (String) flexDemoChannel.get("id");
    User user = usersMap.get(channelid);
    utility.updateUserInfo(flexDemoChannel, user);
  }
  
  /**
   * @param userId
   * @param channelName
   * @param message
   */
  public void sendGroupMessage(String userId, String channelName, Object message) {   
    LOG.debug(" sendGroupMessage : userId "+userId+ " channelName " + channelName);
    ISharedObject chatSO = getChatSO(channelName);
    if(chatSO != null) {
      List<Object> params = new ArrayList<Object>();
      params.add(message);
      chatSO.sendMessage("receiveGroupMessage", params);
    }
  }  
	
	/**
   * END: RPC functions
   */
}
