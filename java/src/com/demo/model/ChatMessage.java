/**
 * File		: ChatMessage.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.model;

import java.util.Date;

/**
 * @author arul
 *
 */
public class ChatMessage {
  
  private String from;
  
  private String userId;
  
  private String message;
  
  private int userColor;
  
  private int messageColor;
  
  private Date date;
  
  /**
   * @return the from
   */
  public String getFrom() {
    return from;
  }
  
  /**
   * @param from the from to set
   */
  public void setFrom(String from) {
    this.from = from;
  }
  
  /**
   * @return the userId
   */
  public String getUserId() {
    return userId;
  }

  /**
   * @param userId the userId to set
   */
  public void setUserId(String userId) {
    this.userId = userId;
  }
  
  /**
   * @return the message
   */
  public String getMessage() {
    return message;
  }

  /**
   * @param message the message to set
   */
  public void setMessage(String message) {
    this.message = message;
  }

  /**
   * @return the userColor
   */
  public int getUserColor() {
    return userColor;
  }

  /**
   * @param userColor the userColor to set
   */
  public void setUserColor(int userColor) {
    this.userColor = userColor;
  }
  
  /**
   * @return the messageColor
   */
  public int getMessageColor() {
    return messageColor;
  }

  /**
   * @param messageColor the messageColor to set
   */
  public void setMessageColor(int messageColor) {
    this.messageColor = messageColor;
  }

  /**
   * @return the date
   */
  public Date getDate() {
    return date;
  }
  
  /**
   * @param date the date to set
   */
  public void setDate(Date date) {
    this.date = date;
  }
}
