<%-- Copyright(c) arulraj.net 2012 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div id="flashContent">

	<p> To view this page ensure that Adobe Flash Player version ${swfVersion} or greater is installed. </p>
	
	<script type="text/javascript"> 
		var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
		document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
						+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
	</script> 
</div>
 	
<noscript>
	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="<spring:message code="webapp.name"/>">
		<param name="movie" value="<%= request.getContextPath() %>/swf/main.swf" />
		<param name="quality" value="high" />
		<param name="bgcolor" value="#FFFFFF" />
		<param name="allowScriptAccess" value="sameDomain" />
		<param name="allowFullScreen" value="true" />
		<!--[if !IE]>-->
		<object type="application/x-shockwave-flash" data="<%= request.getContextPath() %>/swf/main.swf" width="100%" height="100%">
		    <param name="quality" value="high" />
		    <param name="bgcolor" value="#FFFFFF" />
		    <param name="allowScriptAccess" value="sameDomain" />
		    <param name="allowFullScreen" value="true" />
		<!--<![endif]-->
		<!--[if gte IE 6]>-->
			<p> 
				Either scripts and active content are not permitted to run or Adobe Flash Player version
				${swfVersion} or greater is not installed.
			</p>
		<!--<![endif]-->
		    <a href="http://www.adobe.com/go/getflashplayer">
		        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
		    </a>
		<!--[if !IE]>-->
		</object>
		<!--<![endif]-->
	</object>
</noscript>