/**
 * File		: ChatSOSecurity.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.so;

import java.util.List;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IScope;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.so.ISharedObjectListener;
import org.red5.server.api.so.ISharedObjectSecurity;
import org.red5.server.api.so.ISharedObjectService;
import org.red5.server.so.SharedObjectService;
import org.slf4j.Logger;

import static org.red5.server.api.ScopeUtils.getScopeService;

import com.demo.utils.DemoConstants;

/**
 * @author arul
 *
 */
public class ChatSOSecurity implements ISharedObjectSecurity {

  private final static Logger LOG = Red5LoggerFactory.getLogger(ChatSOSecurity.class, DemoConstants.APP_NAME);
  
  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectSecurity#isConnectionAllowed(org.red5.server.api.so.ISharedObject)
   */
  @Override
  public boolean isConnectionAllowed(ISharedObject so) {
    return true;
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectSecurity#isCreationAllowed(org.red5.server.api.IScope, java.lang.String, boolean)
   */
  @Override
  public boolean isCreationAllowed(IScope scope, String name, boolean persistent) {
    try {
      if(name.regionMatches(0, DemoConstants.CHATSO_PREFIX, 0, DemoConstants.CHATSO_PREFIX.length())) {
        ISharedObjectService service = (ISharedObjectService) getScopeService(scope, ISharedObjectService.class, SharedObjectService.class, false);
        if (service.createSharedObject(scope, name, persistent) == true) {
          ISharedObject so = service.getSharedObject(scope, name);
          ISharedObjectListener listener = new ChatSOListener(name);
          so.addSharedObjectListener(listener);                    
        }
      }
      LOG.debug("isCreationAllowed : soName "+name);
      return true;
    } catch (Exception e) {
      LOG.debug("Exception in creating so : ",e);
      return false;
    } finally {
      
    }
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectSecurity#isDeleteAllowed(org.red5.server.api.so.ISharedObject, java.lang.String)
   */
  @Override
  public boolean isDeleteAllowed(ISharedObject so, String key) {
    return true;
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectSecurity#isSendAllowed(org.red5.server.api.so.ISharedObject, java.lang.String, java.util.List)
   */
  @Override
  public boolean isSendAllowed(ISharedObject so, String message, List<?> arguments) {
    return true;
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectSecurity#isWriteAllowed(org.red5.server.api.so.ISharedObject, java.lang.String, java.lang.Object)
   */
  @Override
  public boolean isWriteAllowed(ISharedObject so, String key, Object value) {
    return true;
  }

}
