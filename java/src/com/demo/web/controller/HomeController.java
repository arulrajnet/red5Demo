/**
 * File		: HomeController.java
 * Date		: 08-Apr-2012 
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.demo.model.Channel;
import com.demo.utils.CommonUtility;
import com.demo.utils.PropertiesUtil;
import com.demo.web.service.ChannelService;


/**
 * @author arul
 *
 */
@Controller
@RequestMapping("/home")
public class HomeController extends AbstractBaseController {
  
  CommonUtility utility = CommonUtility.getInstance();
  
  @Autowired
  PropertiesUtil properties;
  
  @Autowired
  ChannelService channelService;
  
  @RequestMapping(value= {"","/"}, method=RequestMethod.GET)
  public String home(ModelMap model) {
    Channel channel = null;
    String channelName = null;
    do {
      channelName = utility.generateString(4);
      channel = channelService.channelInfo(channelName);
    }while(channel!=null);
    
    String url = "http://"+properties.getProperty("red5.server")+":"+properties.getProperty("red5.http.port")+properties.getProperty("webapp.contextPath")+"/web/flash/"+channelName;
    model.addAttribute("pageTitle", "Home");
    model.addAttribute("broadcasterUrl", url+"/broadcaster");
    model.addAttribute("viewerUrl", url+"/player");
    return "main.home";
  }
}
