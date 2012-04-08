/**
 * File   : ErrorController.java
 * Date   : 02-Apr-2011 
 * Owner  : arul
 * Project  : red5Demo
 * Contact  : http://arulraj.net
 * Description : 
 * History  :
 */
package com.demo.web.controller;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.demo.utils.DemoConstants;


/* Copyright(c) arulraj.net 2012*/
/**
 * @author Arul
 *
 */
@Controller
@RequestMapping("/errors")
public class ErrorsController extends AbstractBaseController {
  
  private final static Logger LOG = Red5LoggerFactory.getLogger(ErrorsController.class, DemoConstants.APP_NAME);
  
  @RequestMapping(value = "/notfound", method=RequestMethod.GET)
  public String notFoundPage(ModelMap model) {
    model.addAttribute("pageTitle", "404 (Page Not Found) Error - Ever feel like you're in the wrong place?");
    return "errors.notfound";
  }
  
  @RequestMapping(value = "/error", method=RequestMethod.GET)
  public String serverErrorPage(ModelMap model) {
    LOG.debug("Loading error page.");
    model.addAttribute("pageTitle", "500 (Internal Server) Error We've happened upon a bit of a problem");    
    return "errors.error";
  }
  
  @RequestMapping(value = "/suspended", method=RequestMethod.GET)
  public String suspendedPage(ModelMap model) {
    model.addAttribute("pageTitle", "Site Suspended - This site has stepped out for a bit");
    return "errors.suspended";
  }
  
  @RequestMapping(value = "/comingsoon", method=RequestMethod.GET)
  public String comingsoonPage(ModelMap model) {
    model.addAttribute("pageTitle", "Coming Soon - Future home of something quite cool");    
    return "errors.comingsoon";
  }  

}
