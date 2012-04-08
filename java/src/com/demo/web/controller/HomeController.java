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

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 * @author arul
 *
 */
@Controller
@RequestMapping("/home")
public class HomeController extends AbstractBaseController {
  
  @RequestMapping(value= "/", method=RequestMethod.GET)
  public String home(ModelMap model) {
    model.addAttribute("pageTitle", "Home");
    return "main.home";
  }
}
