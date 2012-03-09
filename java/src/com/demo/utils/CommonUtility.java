/**
 * File		: Commonutility.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.utils;

import static java.lang.Math.abs;
import static java.lang.Math.min;
import static java.lang.Math.pow;
import static java.lang.Math.random;
import static java.lang.Math.round;
import static org.apache.commons.lang.StringUtils.leftPad;

import java.util.ArrayList;
import java.util.List;

import org.red5.io.utils.ObjectMap;
import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;

import com.demo.model.Channel;
import com.demo.model.Role;
import com.demo.model.User;

/**
 * @author arul
 *
 */
public class CommonUtility {
	
	private final static Logger LOG = Red5LoggerFactory.getLogger(CommonUtility.class);
	
	private final static CommonUtility INSTANCE = new CommonUtility();
	
	/**
	 * singleton class
	 */
	private CommonUtility() {
		
	}
	
	public static CommonUtility getInstance() {
		return INSTANCE;
	}
	
	/**
	 * Generate a string with the particular length
	 * @param length
	 * @return
	 */
	public String generateString(int length) { 
		StringBuffer sb = new StringBuffer(); 
		for (int i = length; i > 0; i -= 12) { 
			int n = min(12, abs(i)); 
			sb.append(leftPad(Long.toString(round(random() * pow(36, n)), 36), n, '0')); 
		}
		return sb.toString().toUpperCase(); 
	}
	
	public Role getRole(String name) {
		for(Role role : Role.values()) {
			if(role.getName().equals(name)) {
				return role;
			}
		}
		return null;
	}
	
	@SuppressWarnings("unchecked")
	public User getRed5User(ObjectMap<String, Object> flexUser) {
		User user = new User((String) flexUser.get("id"));
		user.setLoginName((String)flexUser.get("loginName"));
		user.setDisplayName((String) flexUser.get("displayName"));
		user.setSex((String) flexUser.get("sex"));
		user.setRole(getRole((String) ((ObjectMap)flexUser.get("role")).get("name")));
		user.setPlace((String)flexUser.get("place"));
		user.setVideo((Boolean)flexUser.get("video"));
		user.setAudio((Boolean) flexUser.get("audio"));
		LOG.debug("java user : "+user.toString());
		return user;		
	}
	

	/**
	 * It returns object to easily bind with flex user object
	 * @return
	 */
	public ObjectMap<String, Object> getFlexUser(User user) {
		ObjectMap<String, Object> roleMap = new ObjectMap<String, Object>();
		roleMap.put("name", user.getRole().getName());
		ObjectMap<String, Object> userMap = new ObjectMap<String, Object>();
		userMap.put("id", user.getId());
		userMap.put("loginName", user.getLoginName());
		userMap.put("displayName", user.getDisplayName());
		userMap.put("sex",user.getSex());
		userMap.put("role", roleMap);
		userMap.put("place", user.getPlace());
		userMap.put("video", user.getVideo());
		userMap.put("audio", user.getAudio());
		LOG.debug("flex user object map : "+userMap.toString());
		return userMap;
	}
	
	public List<ObjectMap<String, Object>> getListFlexUser(List<User> users) {
		List<ObjectMap<String, Object>> usersMapList = new ArrayList<ObjectMap<String, Object>>();
		
		for(User user : users) {
			usersMapList.add(getFlexUser(user));
		}
		
		return usersMapList;
	}
	
	public ObjectMap<String, Object> getFlexChannel(Channel channel) {
		ObjectMap<String, Object> roomMap = new ObjectMap<String, Object>();
		roomMap.put("id", channel.getId());
		roomMap.put("title", channel.getTitle());
		roomMap.put("channelName", channel.getChannelName());
		roomMap.put("password", channel.getPassword());
		roomMap.put("maxUser", channel.getMaxUser());
		roomMap.put("members", getListFlexUser(channel.getMembers()));
		roomMap.put("enabled", channel.getEnabled());
		roomMap.put("recorded", channel.getRecorded());
		roomMap.put("startedAt", channel.getStartedAt());
		roomMap.put("expiresAt", channel.getExpiresAt());
		LOG.debug("flex room object map : "+roomMap.toString());
		return roomMap;
	}
	
	public ObjectMap<String, Object> getFlexChatMessage(ObjectMap<String, Object> message) {
		ObjectMap<String, Object> messageMap = new ObjectMap<String, Object>();
		messageMap.put("", message);
		return messageMap;
	}
	
	/**
	 * This will update User object from flex 
	 * @param flexUser
	 * @param user
	 */
	@SuppressWarnings("unchecked")
	public void updateUserInfo(ObjectMap<String, Object> flexUser, User user) {
		if(user.getId() == null) {
			user.setId((String) flexUser.get("id"));
		}
		user.setLoginName(flexUser.get("loginName") != null ? (String)flexUser.get("loginName") : user.getLoginName());
		user.setDisplayName(flexUser.get("displayName") != null ? (String)flexUser.get("displayName") : user.getDisplayName());		
		user.setSex(flexUser.get("sex") != null ? (String) flexUser.get("sex") : user.getSex());
		user.setRole(flexUser.get("role") != null ? getRole((String) ((ObjectMap)flexUser.get("role")).get("name")) : user.getRole());
		user.setPlace(flexUser.get("place") != null ? (String) flexUser.get("place") : user.getPlace());
		user.setVideo(flexUser.get("video") != null ? (Boolean) flexUser.get("video") : user.getVideo());
		user.setAudio(flexUser.get("audio") != null ? (Boolean) flexUser.get("audio") : user.getAudio());
		
		LOG.debug("updateUserInfo user.tostring() : "+user.toString());
	}
	
	/**
	 * This will update the channel object from flex
	 * @param flexChannel
	 * @param channel
	 */
	public void updateChannelInfo(ObjectMap<String, Object> flexChannel, Channel channel) {
		if(channel.getId() == null) {
			channel.setId((String) flexChannel.get("id"));
		}
		channel.setTitle(flexChannel.get("title") != null ? (String)flexChannel.get("title") : channel.getTitle());
		channel.setDescription(flexChannel.get("description") != null ? (String)flexChannel.get("description") : channel.getDescription());
		channel.setChannelName(flexChannel.get("channelName") != null ? (String)flexChannel.get("channelName") : channel.getChannelName());
		channel.setPassword(flexChannel.get("password") != null ? (String)flexChannel.get("password") : channel.getPassword());
		channel.setMaxUser(flexChannel.get("maxUser") != null ? (Integer)flexChannel.get("maxUser") : channel.getMaxUser());
		channel.setEnabled(flexChannel.get("enabled") != null ? (Boolean)flexChannel.get("enabled") : channel.getEnabled());
		channel.setRecorded(flexChannel.get("recorded") != null ? (Boolean)flexChannel.get("recorded") : channel.getRecorded());
		
		LOG.debug("updateChannelInfo channel.tostring() : "+channel.toString());
	}
}
