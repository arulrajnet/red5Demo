/**
 * File		: ChatSOListener.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.so;

import java.util.List;
import java.util.Map;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.IAttributeStore;
import org.red5.server.api.so.ISharedObjectBase;
import org.red5.server.api.so.ISharedObjectListener;
import org.slf4j.Logger;

import com.demo.utils.DemoConstants;


/**
 * @author arul
 *
 */
public class ChatSOListener implements ISharedObjectListener {
  
  private final static Logger LOG = Red5LoggerFactory.getLogger(ChatSOListener.class, DemoConstants.APP_NAME);
  
  private String soName;
  
  public ChatSOListener(String soName) {
    this.soName = soName;
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectClear(org.red5.server.api.so.ISharedObjectBase)
   */
  @Override
  public void onSharedObjectClear(ISharedObjectBase so) {
    LOG.debug("onSharedObjectClear : soName = "+soName);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectConnect(org.red5.server.api.so.ISharedObjectBase)
   */
  @Override
  public void onSharedObjectConnect(ISharedObjectBase so) {
    LOG.debug("onSharedObjectConnect : soName = "+soName);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectDelete(org.red5.server.api.so.ISharedObjectBase, java.lang.String)
   */
  @Override
  public void onSharedObjectDelete(ISharedObjectBase so, String key) {
    LOG.debug("onSharedObjectDelete : soName = "+soName+ " key " + key);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectDisconnect(org.red5.server.api.so.ISharedObjectBase)
   */
  @Override
  public void onSharedObjectDisconnect(ISharedObjectBase so) {
    LOG.debug("onSharedObjectDisconnect : soName = "+soName);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectSend(org.red5.server.api.so.ISharedObjectBase, java.lang.String, java.util.List)
   */
  @Override
  public void onSharedObjectSend(ISharedObjectBase so, String method, List<?> params) {
    LOG.debug("onSharedObjectSend : soName = " +soName+ " method = " +method+ " params = " + params);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectUpdate(org.red5.server.api.so.ISharedObjectBase, org.red5.server.api.IAttributeStore)
   */
  @Override
  public void onSharedObjectUpdate(ISharedObjectBase so, IAttributeStore values) {
    LOG.debug("onSharedObjectUpdate : soName = " +soName+ " values = " +values);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectUpdate(org.red5.server.api.so.ISharedObjectBase, java.util.Map)
   */
  @Override
  public void onSharedObjectUpdate(ISharedObjectBase so, Map<String, Object> values) {
    LOG.debug("onSharedObjectUpdate : soName = " +soName+ " values = " +values);
  }

  /* (non-Javadoc)
   * @see org.red5.server.api.so.ISharedObjectListener#onSharedObjectUpdate(org.red5.server.api.so.ISharedObjectBase, java.lang.String, java.lang.Object)
   */
  @Override
  public void onSharedObjectUpdate(ISharedObjectBase so, String key, Object value) {
    LOG.debug("onSharedObjectUpdate : soName = " +soName+ " key = " +key+ " value = " + value);
  }
  
  /**
   * @return the soName
   */
  public String getSoName() {
    return soName;
  }
  
  /**
   * @param soName the soName to set
   */
  public void setSoName(String soName) {
    this.soName = soName;
  }

}
