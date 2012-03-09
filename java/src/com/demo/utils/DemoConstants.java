/**
 * File		: DemoConstants.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.utils;

import java.util.Arrays;
import java.util.List;

/**
 * @author arul
 *
 */
public class DemoConstants {
	
	public final static List<String> CONNECTIONS = Arrays.asList("publicConn", "videoConn", "audioConn");
	public final static List<String> ROOMS = Arrays.asList("red5Demo","public","private");	
	
	public final static String APP_NAME = "red5Demo";
	
	public final static String AUDIO_STREAM_NAME = "livestreamaudio";
	public final static String VIDEO_STREAM_NAME = "livestreamvideo";
	
	public final static String GUEST = "Guest";
	public final static String ALL = "All";
	public final static int USER_ID_LENGTH = 8;	
	
	public final static String CHATSO_PREFIX = "chatso-";
	
	public final static int DEFAULT_PLAY_TIME = 60; //In seconds
	
	public final static int MAX_USER = 99;
	
	private DemoConstants(){
		
	}
}
