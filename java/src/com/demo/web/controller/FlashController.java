/**
 * File		: FlashController.java
 * Date		: 14-Apr-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.demo.model.Channel;
import com.demo.utils.PropertiesUtil;
import com.demo.web.service.ChannelService;

/**
 * @author arul
 *
 */
@Controller
@RequestMapping("/flash")
public class FlashController extends AbstractBaseController {
  
  @Autowired
  PropertiesUtil properties;
  
  @Autowired
  ChannelService channelService;

  @RequestMapping(value="/{channelName}/broadcaster", method=RequestMethod.GET)
  public String broadcaster(@PathVariable String channelName, ModelMap model) {
    model.addAttribute("pageTitle", "Broadcaster");
    model.addAttribute("role", "admin");
    model.addAttribute("channelName", channelName);
    model.addAttribute("red5Server", properties.getProperty("red5.server"));
    model.addAttribute("red5Secure", properties.getProperty("red5.secure"));
    model.addAttribute("swfVersion", properties.getProperty("major.version")+"."+properties.getProperty("minor.version")+"."+properties.getProperty("revision.version"));
    Channel channel = channelService.channelInfo(channelName);
    if(channel != null) {
      return "flash.broadcaster_info";
    } else {
      return "flash.broadcaster";      
    }
  }
  
  @RequestMapping(value="/{channelName}/player", method=RequestMethod.GET)
  public String player(@PathVariable String channelName, ModelMap model) {
    model.addAttribute("pageTitle", "Player");
    model.addAttribute("role", "player");
    model.addAttribute("channelName", channelName);
    model.addAttribute("red5Server", properties.getProperty("red5.server"));
    model.addAttribute("red5Secure", properties.getProperty("red5.secure"));
    model.addAttribute("swfVersion", properties.getProperty("major.version")+"."+properties.getProperty("minor.version")+"."+properties.getProperty("revision.version"));
    return "flash.viewer";
  }  
  
}
