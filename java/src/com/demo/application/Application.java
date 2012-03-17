/**
 * File		: Application.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.application;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

import org.red5.io.utils.ObjectMap;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.ScopeUtils;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.ServiceUtils;
import org.red5.server.api.stream.IBroadcastStream;
import org.red5.server.api.stream.IStreamAwareScopeHandler;
import org.slf4j.Logger;

import com.demo.model.Channel;
import com.demo.model.Connection;
import com.demo.model.Role;
import com.demo.model.User;
import com.demo.utils.CommonUtility;
import com.demo.utils.DemoConstants;

/**
 * @author arul
 * 
 */
public class Application extends MultiThreadedApplicationAdapter implements
		IPendingServiceCall, IStreamAwareScopeHandler {

	static final Logger LOG = Red5LoggerFactory.getLogger(Application.class, DemoConstants.APP_NAME);
	LinkedHashMap<String, User> usersMap = null;
	LinkedHashMap<String, Channel> channelsMap = null;
	LinkedHashMap<String, Connection> connectionsMap = null;
	LinkedHashMap<String, IScope> scopeMap = null;
	CommonUtility utility = null;
	public IScope globalScope = null;

	public Application() {
		super();
		setClientTTL(30);
		usersMap = new LinkedHashMap<String, User>();
		channelsMap = new LinkedHashMap<String, Channel>();
		connectionsMap = new LinkedHashMap<String, Connection>();
		scopeMap = new LinkedHashMap<String, IScope>();
		utility = CommonUtility.getInstance();
	}

	/**
	 * User defined functions
	 */

	/**
	 * 
	 * @return
	 */
	private String generateUserID() {
		String username = null;
		username = utility.generateString(DemoConstants.USER_ID_LENGTH);
		while (usersMap.containsKey(username)) {
			username = utility.generateString(DemoConstants.USER_ID_LENGTH);
		}
		return username;
	}

	/**
	 * 
	 * @param loginName
	 * @return
	 */
	public User getUserFromLoginName(String loginName) {
		User liveUser = null;
		for (User user : usersMap.values()) {
			if (user.getLoginName().equals(loginName)) {
				liveUser = user;
				break;
			}
		}
		return liveUser;
	}

	/**
	 * START: Override functions in MultiThreadedApplicationAdapter
	 */

	@SuppressWarnings("unchecked")
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.adapter.MultiThreadedApplicationAdapter#connect(org.red5
	 * .server.api.IConnection, org.red5.server.api.IScope, java.lang.Object[])
	 */
	@Override
	public boolean connect(IConnection connection, IScope scope, Object[] params) {
		try {
			User demoUser = null;
			Connection userConnection = null;
			String connectionName = null;
			String userid = null;
			ObjectMap<String, Object> flexUser = null;

			if (ScopeUtils.isRoom(scope)) {
				if (params.length > 1) {
					/* If have params that is the logined user */
					connectionName = (String) params[0];
					flexUser = (ObjectMap<String, Object>) params[1];
					userid = (String) flexUser.get("id");
					LOG.debug("user from flex : " + flexUser.toString());

					if (userid.equals(DemoConstants.GUEST)) {
						LOG
								.debug("No User for the user [" + userid
										+ "], Connection name ["
										+ connectionName + "]");
						userid = generateUserID();
						demoUser = new User(userid);
						userConnection = new Connection(userid);
						usersMap.put(userid, demoUser);
						connectionsMap.put(userid, userConnection);
					} else {
						demoUser = usersMap.get(userid);
						userConnection = connectionsMap.get(userid);
					}

					/**
					 * This will update user object from flex
					 */
					utility.updateUserInfo(flexUser, demoUser);
				} else {
					/* If its a anonymous */
					userid = generateUserID();
					demoUser = new User(userid);
					userConnection = new Connection(userid);
					demoUser.setRole(Role.ANONYMOUS);
					connectionName = DemoConstants.CONNECTIONS.get(1);
					usersMap.put(userid, demoUser);
					connectionsMap.put(userid, userConnection);
				}
			}

			if (demoUser != null && connectionName != null) {
				if (connectionName.equals(DemoConstants.CONNECTIONS.get(0))) {
					/* For public connection */
					userConnection.setPublicId(connection.getClient().getId());
					userConnection.setPublicConnection(connection);

					List<HashMap<String, Object>> mapList = new ArrayList<HashMap<String, Object>>();
					mapList.add(utility.getFlexUser(demoUser));
					ServiceUtils.invokeOnConnection(connection, "updateUser",
							new Object[] { demoUser });

					LOG.debug("Public Connection ID for the user [" + userid
							+ "] is [" + userConnection.getPublicId() + "]");

				} else if (connectionName
						.equals(DemoConstants.CONNECTIONS.get(1))) {
					/* For video connection */
					userConnection.setVideoId(connection.getClient().getId());
					userConnection.setVideoConnection(connection);
				} else if (connectionName
						.equals(DemoConstants.CONNECTIONS.get(2))) {
					/* For audio connection */
					userConnection.setAudioId(connection.getClient().getId());
					userConnection.setAudioConnection(connection);
				}

				/* set user id and room id in connection obj */
				IClient client = connection.getClient();
				client.setAttribute("userId", demoUser != null ? demoUser
						.getId() : "");
			}
		} catch (Exception ex) {
			LOG.debug("Exception in appConnect... ", ex);
		} finally {
		}
		return super.connect(connection, scope, params);
	}
	
	
	/* (non-Javadoc)
	 * @see org.red5.server.adapter.MultiThreadedApplicationAdapter#streamPublishStart(org.red5.server.api.stream.IBroadcastStream)
	 */
	@Override
	public void streamPublishStart(IBroadcastStream stream) {
		LOG.debug("Stream publish : "+stream.getPublishedName());
		super.streamPublishStart(stream);
	}
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.adapter.MultiThreadedApplicationAdapter#streamBroadcastStart
	 * (org.red5.server.api.stream.IBroadcastStream)
	 */
	@Override
	public void streamBroadcastStart(IBroadcastStream stream) {
		LOG.debug("Stream broadcast : "+stream.getPublishedName());
		super.streamBroadcastStart(stream);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.adapter.MultiThreadedApplicationAdapter#streamBroadcastClose
	 * (org.red5.server.api.stream.IBroadcastStream)
	 */
	@Override
	public void streamBroadcastClose(IBroadcastStream stream) {
		LOG.debug("Stream broadcast close : "+stream.getPublishedName());
		super.streamBroadcastClose(stream);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.adapter.MultiThreadedApplicationAdapter#appStart(org.
	 * red5.server.api.IScope)
	 */
	@Override
	public boolean appStart(IScope scope) {
		boolean retVal = super.appStart(scope);
		LOG.debug("red5Demo application started...");
		this.globalScope = scope;
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
		LOG.debug("red5Demo application stopped...");
		super.appStop(scope);
	}

	/**
	 * END: Override functions in MultiThreadedApplicationAdapter
	 */

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IPendingServiceCall#getCallbacks()
	 */
	@Override
	public Set<IPendingServiceCallback> getCallbacks() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IPendingServiceCall#getResult()
	 */
	@Override
	public Object getResult() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.api.service.IPendingServiceCall#registerCallback(org.
	 * red5.server.api.service.IPendingServiceCallback)
	 */
	@Override
	public void registerCallback(IPendingServiceCallback arg0) {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.api.service.IPendingServiceCall#setResult(java.lang.Object
	 * )
	 */
	@Override
	public void setResult(Object arg0) {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.api.service.IPendingServiceCall#unregisterCallback(org
	 * .red5.server.api.service.IPendingServiceCallback)
	 */
	@Override
	public void unregisterCallback(IPendingServiceCallback arg0) {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#getArguments()
	 */
	@Override
	public Object[] getArguments() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#getException()
	 */
	@Override
	public Exception getException() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#getServiceMethodName()
	 */
	@Override
	public String getServiceMethodName() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#getServiceName()
	 */
	@Override
	public String getServiceName() {
		// TODO Auto-generated method stub
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#getStatus()
	 */
	@Override
	public byte getStatus() {
		// TODO Auto-generated method stub
		return 0;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#isSuccess()
	 */
	@Override
	public boolean isSuccess() {
		// TODO Auto-generated method stub
		return false;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.red5.server.api.service.IServiceCall#setException(java.lang.Exception
	 * )
	 */
	@Override
	public void setException(Exception arg0) {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.red5.server.api.service.IServiceCall#setStatus(byte)
	 */
	@Override
	public void setStatus(byte arg0) {
		// TODO Auto-generated method stub

	}

	/**
	 * GETTER / SETTER
	 */

	/**
	 * @return the usersMap
	 */
	public LinkedHashMap<String, User> getUsersMap() {
		return usersMap;
	}

	/**
	 * @return the connectionsMap
	 */
	public LinkedHashMap<String, Connection> getConnectionsMap() {
		return connectionsMap;
	}

	/**
	 * @return the scopeMap
	 */
	public LinkedHashMap<String, IScope> getScopeMap() {
		return scopeMap;
	}

	/**
	 * @return the utility
	 */
	public CommonUtility getUtility() {
		return utility;
	}
}
