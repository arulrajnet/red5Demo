/**
 * File		: Role.java
 * Date		: 09-Mar-2012 
 * Owner	: arul
 * Project	: red5Demo
 * Contact	: http://arulraj.net
 * Description : 
 * History	:
 */
package com.demo.model;

/**
 * @author arul
 *
 */
public enum Role {
	ADMIN("admin"), PLAYER("player"), ANONYMOUS("anonymous");
	
	private String name;
	
	Role(String name) {
		this.name = name;
	}

	public int getId() {
		return ordinal();
	}
	
	public String getDisplayName() {
		char[] result = name().toLowerCase().toCharArray();
		result[0] = name().toCharArray()[0];
		return new String(result);
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Enum#toString()
	 */
	@Override
	public String toString() {
		return String.format("Role { id = %d, name = %s, displayName = %s }", getId(), getName(), getDisplayName());
	}
}
