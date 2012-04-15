<%-- Copyright(c) arulraj.net 2012 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/swfobject.js"></script>
<script type="text/javascript">
		<!-- For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. --> 
		var swfVersionStr = "${swfVersion}";
		<!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
		var xiSwfUrlStr = "<%= request.getContextPath() %>/swf/playerProductInstall.swf";
		var flashvars = {};
		flashvars.red5server = "${red5Server}";
		flashvars.secure = "${red5Secure}";
		flashvars.role = "${role}";
		flashvars.channelName = "${channelName}";
		var params = {};
		params.quality = "high";
		params.bgcolor = "#FFFFFF";
		params.allowscriptaccess = "sameDomain";
		params.allowfullscreen = "true";
		var attributes = {};
		attributes.id = "<spring:message code="webapp.name"/>";
		attributes.name = "<spring:message code="webapp.name"/>";
		attributes.align = "middle";
		swfobject.embedSWF(
		    "<%= request.getContextPath() %>/swf/main.swf", "flashContent", 
		    "100%", "100%", 
		    swfVersionStr, xiSwfUrlStr, 
		    flashvars, params, attributes);
	    
		<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
		swfobject.createCSS("#flashContent", "display:block;text-align:left;");
</script>			