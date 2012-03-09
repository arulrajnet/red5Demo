/**
 * File		: Connection.java
 * Date		: 09-Mar-2012 
 * Owner	: arulraj
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.model;

import org.red5.server.api.IConnection;

/**
 * @author arul
 *
 */
public class Connection {
	
	private String id;
	
	private IConnection publicConnection;
	
	private IConnection videoConnection;
	
	private IConnection audioConnection;
	
	private String publicId;
	
	private String videoId;
	
	private String audioId;
	
	
	public Connection(String id) {
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
	 * @return the publicConnection
	 */
	public IConnection getPublicConnection() {
		return publicConnection;
	}

	/**
	 * @param publicConnection the publicConnection to set
	 */
	public void setPublicConnection(IConnection publicConnection) {
		this.publicConnection = publicConnection;
	}

	/**
	 * @return the videoConnection
	 */
	public IConnection getVideoConnection() {
		return videoConnection;
	}

	/**
	 * @param videoConnection the videoConnection to set
	 */
	public void setVideoConnection(IConnection videoConnection) {
		this.videoConnection = videoConnection;
	}

	/**
	 * @return the audioConnection
	 */
	public IConnection getAudioConnection() {
		return audioConnection;
	}

	/**
	 * @param audioConnection the audioConnection to set
	 */
	public void setAudioConnection(IConnection audioConnection) {
		this.audioConnection = audioConnection;
	}

	/**
	 * @return the publicId
	 */
	public String getPublicId() {
		return publicId;
	}

	/**
	 * @param publicId the publicId to set
	 */
	public void setPublicId(String publicId) {
		this.publicId = publicId;
	}
	
	/**
	 * @return the videoId
	 */
	public String getVideoId() {
		return videoId;
	}

	/**
	 * @param videoId the videoId to set
	 */
	public void setVideoId(String videoId) {
		this.videoId = videoId;
	}

	/**
	 * @return the audioId
	 */
	public String getAudioId() {
		return audioId;
	}

	/**
	 * @param audioId the audioId to set
	 */
	public void setAudioId(String audioId) {
		this.audioId = audioId;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "Connection [audioConnection=" + audioConnection + ", audioId="
				+ audioId + ", id=" + id + ", publicConnection="
				+ publicConnection + ", publicId=" + publicId
				+ ", videoConnection=" + videoConnection + ", videoId="
				+ videoId + "]";
	}
	
}
