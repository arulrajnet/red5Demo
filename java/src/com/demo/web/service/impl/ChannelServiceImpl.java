/**
 * File		: ChannelServiceImpl.java
 * Date		: 09-Apr-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.web.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.demo.application.Red5Demo;
import com.demo.model.Channel;
import com.demo.web.service.ChannelService;


/**
 * @author arul
 *
 */
@Service("channelService")
public class ChannelServiceImpl extends AbstractService implements ChannelService {
  
  @Autowired
  private Red5Demo red5app;

  @Override
  public Channel channelInfo(String channelName) {
    Map<String, Channel> channels = red5app.getChannelsMap();
    return channels.get(channelName);
  }

  @SuppressWarnings("unchecked")
  @Override
  public List<Channel> channels() {
    Map<String, Channel> channels = red5app.getChannelsMap();
    Collection<Channel> collection = channels.values();
    List<Channel> list;
    if(collection instanceof List) {
      list = (List) collection;
    } else {
      list = new ArrayList<Channel>(collection);
    }
    return list;
  }

}
