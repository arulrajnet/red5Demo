/**
 * File		: PropertiesUtil.java
 * Date		: 05-Apr-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.utils;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;


/**
 * @author arul
 *
 */
public class PropertiesUtil extends PropertyPlaceholderConfigurer {
  
  private static Map<String, String> propertiesMap;
  
  /* (non-Javadoc)
   * @see org.springframework.beans.factory.config.PropertyPlaceholderConfigurer#processProperties(org.springframework.beans.factory.config.ConfigurableListableBeanFactory, java.util.Properties)
   */
  @Override
  protected void processProperties(ConfigurableListableBeanFactory beanFactoryToProcess, Properties props)
      throws BeansException {
    super.processProperties(beanFactoryToProcess, props);
    
    propertiesMap = new HashMap<String, String>();
    for (Object key : props.keySet()) {
      String keyStr = key.toString();
      propertiesMap.put(keyStr, props.getProperty(keyStr));
    }
    
  }
  
  public String getProperty(String key) {
    return propertiesMap.get(key);
  }
}
