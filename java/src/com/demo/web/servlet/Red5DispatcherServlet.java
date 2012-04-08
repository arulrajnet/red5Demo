/**
 * File : Red5DispatcherServlet.java
 * Date : 26-Mar-2012
 * Owner : arul
 * Project : red5Demo
 * Contact : http://arulraj.net
 * Description : History :
 */
package com.demo.web.servlet;

import org.red5.logging.Red5LoggerFactory;
import org.slf4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.DispatcherServlet;

import com.demo.utils.DemoConstants;

/* Copyright(c) arulraj.net 2012 */
/**
 * @author Arul
 */
public class Red5DispatcherServlet extends DispatcherServlet {

  /**
   * 
   */
  private static final long serialVersionUID = 1L;
  
  private static final Logger LOG = Red5LoggerFactory.getLogger(Red5DispatcherServlet.class, DemoConstants.APP_NAME);
  
  private WebApplicationContext parentContext;

  @Override
  protected WebApplicationContext initWebApplicationContext() {
    WebApplicationContext wac = null;
    parentContext = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
    if (parentContext == null) {
      parentContext = (WebApplicationContext) getServletContext().getAttribute(
          WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
    }
    if (parentContext == null) {
      LOG.error("No web application context found.");
    } else {
      wac = createWebApplicationContext(parentContext);
    }

    setDetectAllHandlerAdapters(Boolean.TRUE);
    setDetectAllHandlerMappings(Boolean.TRUE);
    setDetectAllHandlerExceptionResolvers(Boolean.TRUE);
    setDetectAllViewResolvers(Boolean.TRUE);

    onRefresh(wac);

    String attrName = getServletContextAttributeName();
    getServletContext().setAttribute(attrName, wac);
    if (this.logger.isDebugEnabled()) {
      this.logger.debug("Published WebApplicationContext of servlet '" + getServletName()
          + "' as ServletContext attribute with name [" + attrName + "]");
    }

    return wac;
  }

  /**
   * @return the parentContext
   */
  public WebApplicationContext getParentContext() {
    return parentContext;
  }

  /**
   * @param parentContext the parentContext to set
   */
  public void setParentContext(WebApplicationContext parentContext) {
    this.parentContext = parentContext;
  }
}
