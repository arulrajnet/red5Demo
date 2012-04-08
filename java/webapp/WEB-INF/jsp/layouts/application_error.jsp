<%-- Copyright(c) arulraj.net 2012 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${pageTitle}</title>

<link href="<%= request.getContextPath() %>/css/errors-styles.css" rel="stylesheet" type="text/css" media="screen" />

</head>
  <body>
    <tiles:insertAttribute name="body"/>
  </body>
</html>