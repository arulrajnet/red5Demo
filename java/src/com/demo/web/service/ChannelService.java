/**
 * File		: ChannelService.java
 * Date		: 09-Apr-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.web.service;

import java.util.List;

import com.demo.model.Channel;


/**
 * @author arul
 *
 */
public interface ChannelService {
  
  public List<Channel> channels();
  
  public Channel channelInfo(String channelName);

}
