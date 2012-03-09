/**
 * File		: User.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.model;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import com.demo.utils.DemoConstants;

/**
 * @author arul
 *
 */
@XmlRootElement(name = "user")
public class User {
	
	private String id;
	
	private String loginName = DemoConstants.GUEST;
	
	private String displayName = DemoConstants.GUEST;
	
	private String sex = DemoConstants.ALL;
	
	private Role role = Role.ANONYMOUS;
	
	private String place = DemoConstants.ALL;
	
	private int broadcastTime = 60; //In seconds
	
	private Boolean video = Boolean.FALSE;
	
	private Boolean audio = Boolean.FALSE;
	
	public User() {
	}

	public User(String id) {
		this.id = id;
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
	 * @return the loginName
	 */
	public String getLoginName() {
		return loginName;
	}

	/**
	 * @param loginName the loginName to set
	 */
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	/**
	 * @return the displayName
	 */
	public String getDisplayName() {
		return displayName;
	}

	/**
	 * @param displayName the displayName to set
	 */
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	/**
	 * @return the sex
	 */
	@XmlTransient
	public String getSex() {
		return sex;
	}

	/**
	 * @param sex the sex to set
	 */
	public void setSex(String sex) {
		this.sex = sex;
	}

	/**
	 * @return the role
	 */
	public Role getRole() {
		return role;
	}

	/**
	 * @param role the role to set
	 */
	public void setRole(Role role) {
		this.role = role;
	}

	/**
	 * @return the place
	 */
	@XmlTransient
	public String getPlace() {
		return place;
	}

	/**
	 * @param place the place to set
	 */
	public void setPlace(String place) {
		this.place = place;
	}
	
  /**
   * @return the broadcastTime
   */
  public int getBroadcastTime() {
    return broadcastTime;
  }
  
  /**
   * @param broadcastTime the broadcastTime to set
   */
  public void setBroadcastTime(int broadcastTime) {
    this.broadcastTime = broadcastTime;
  }

  /**
	 * @return the video
	 */
	@XmlTransient
	public Boolean getVideo() {
		return video;
	}

	/**
	 * @param video the video to set
	 */
	public void setVideo(Boolean video) {
		this.video = video;
	}

	/**
	 * @return the audio
	 */
	@XmlTransient
	public Boolean getAudio() {
		return audio;
	}

	/**
	 * @param audio the audio to set
	 */
	public void setAudio(Boolean audio) {
		this.audio = audio;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "User [audio=" + audio + ", displayName=" + displayName
				+ ", id=" + id + ", loginName=" + loginName + ", place="
				+ place + ", role=" + role + ", sex=" + sex + ", video="
				+ video + "]";
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result
				+ ((loginName == null) ? 0 : loginName.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		User other = (User) obj;
		if (id == null) {
			if (other.id != null) {
				return false;
			}
		} else if (!id.equals(other.id)) {
			return false;
		}
		if (loginName == null) {
			if (other.loginName != null) {
				return false;
			}
		} else if (!loginName.equals(other.loginName)) {
			return false;
		}
		return true;
	}
}
