/**
 * File		: Channel.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import com.demo.utils.DemoConstants;


/**
 * @author arul
 *
 */
@XmlRootElement(name = "channel")
public class Channel {
  
  private String id;
  
  private String title;
  
  private String description;

  private String channelName;
  
  private String password;
  
  private int maxUser = DemoConstants.MAX_USER;
  
  private List<User> members = new ArrayList<User>();
  
  private Boolean enabled = Boolean.TRUE;
  
  private Boolean recorded = Boolean.TRUE;
  
  private Date startedAt;
  
  private Date expiresAt;
  
  public Channel(String id) {
    this.id = id;
    this.startedAt = new Date();
  }
  
  /**
   * @return the id
   */
  public String getId() {
    return id;
  }
  
  /**
   * @param id the id to set
   */
  public void setId(String id) {
    this.id = id;
  }

  /**
   * @return the title
   */
  public String getTitle() {
    return title;
  }
  
  /**
   * @param title the title to set
   */
  public void setTitle(String title) {
    this.title = title;
  }
  
  /**
   * @return the description
   */
  public String getDescription() {
    return description;
  }
  
  /**
   * @param description the description to set
   */
  public void setDescription(String description) {
    this.description = description;
  }

  /**
   * @return the channelName
   */
  public String getChannelName() {
    return channelName;
  }
  
  /**
   * @param channelName the channelName to set
   */
  public void setChannelName(String channelName) {
    this.channelName = channelName;
  }
  
  /**
   * @return the password
   */
  @XmlTransient
  public String getPassword() {
    return password;
  }
  
  /**
   * @param password the password to set
   */
  public void setPassword(String password) {
    this.password = password;
  }
  
  /**
   * @return the maxUser
   */
  @XmlTransient
  public int getMaxUser() {
    return maxUser;
  }
  
  /**
   * @param maxUser the maxUser to set
   */
  public void setMaxUser(int maxUser) {
    this.maxUser = maxUser;
  }
  
  /**
   * @return the members
   */
  @XmlTransient
  public List<User> getMembers() {
    return members;
  }
  
  /**
   * @param members the members to set
   */
  public void setMembers(List<User> members) {
    this.members = members;
  }
  
  /**
   * @return the enabled
   */
  @XmlTransient
  public Boolean getEnabled() {
    return enabled;
  }
  
  /**
   * @param enabled the enabled to set
   */
  public void setEnabled(Boolean enabled) {
    this.enabled = enabled;
  }
  
  /**
   * @return the recorded
   */
  public Boolean getRecorded() {
    return recorded;
  }
  
  /**
   * @param recorded the recorded to set
   */
  public void setRecorded(Boolean recorded) {
    this.recorded = recorded;
  }
  
  /**
   * @return the startedAt
   */
  public Date getStartedAt() {
    return startedAt;
  }
  
  /**
   * @param startedAt the startedAt to set
   */
  public void setStartedAt(Date startedAt) {
    this.startedAt = startedAt;
  }
  
  /**
   * @return the expiresAt
   */
  public Date getExpiresAt() {
    return expiresAt;
  }
  
  /**
   * @param expiresAt the expiresAt to set
   */
  public void setExpiresAt(Date expiresAt) {
    this.expiresAt = expiresAt;
  }
  
  /**
   *
   * @return
   */
  @XmlElement(name = "members")
  public int getMemberCount() {
    return members.size();
  }  

  /* (non-Javadoc)
   * @see java.lang.Object#toString()
   */
  @Override
  public String toString() {
    return "Channel [channelName=" + channelName + ", description=" + description + ", enabled=" + enabled
        + ", expiresAt=" + expiresAt + ", id=" + id + ", maxUser=" + maxUser + ", members=" + members + ", password="
        + password + ", recorded=" + recorded + ", startedAt=" + startedAt + ", title=" + title + "]";
  }
}
