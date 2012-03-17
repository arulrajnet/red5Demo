/**
 * File   : DateAdapter.java
 * Date   : 09-Mar-2012
 * Owner  : arul
 * Project  : red5Demo
 * Contact  : http://arulraj.net
 * Description : 
 * History  :
 */
package com.demo.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.bind.annotation.adapters.XmlAdapter;

/**
 * @author Arul
 *
 */
public class DateAdapter extends XmlAdapter<String, Date> {

  private SimpleDateFormat dateFormat = new SimpleDateFormat("E, dd MMM yyyy hh:mm:ss z");//Tue, 05 Dec 2011 15:40:30 GMT

  @Override
  public String marshal(Date v) throws Exception {
    return dateFormat.format(v);
  }

  @Override
  public Date unmarshal(String v) throws Exception {
    return dateFormat.parse(v);
  }

}
