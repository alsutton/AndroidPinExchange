<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored ="false" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 
 Copyright (c) 2012, Funky Android Ltd.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
 following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
   disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
   disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of Funky Android nor the names of its contributors may be used to endorse or promote products derived 
   from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  -->
<!-- Funky Android can be contacted via their web site at www.funkyandroid.com -->
<!DOCTYPE html>
<html lang="en">
  <head>
	<%
	 	UserService userService = UserServiceFactory.getUserService();
	%>
    <meta charset="utf-8">
    <title>*UNOFFICIAL* MWC2012 Android Pin Exchange by Funky Android Ltd.</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/bootstrap-responsive.min.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <link href="/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-29466722-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Unofficial MWC 2012 Android Pin Exchange</a>
           <div class="nav-collapse">
            <ul class="nav">
              <li><a href="index.jsp">Collect</a></li>
              <li><a href="/Trade">Trade</a></li>
    		  <li><a href="http://www.android.com/events/mwc/2012/" target="_blank">Android @ MWC2012</a>
    		  <li><a href="http://www.funkyandroid.com/" target="_blank">Funky Android Ltd.</a>
            </ul>
          </div><!--/.nav-collapse -->
           <div class="nav pull-right" style="color:#ddd">
			<c:choose>
			<c:when test="${pageContext.request.userPrincipal eq null }">
			<a href='<%=userService.createLoginURL(request.getRequestURI())%>' style="color:#ddd; text-decoration: underline">Log in</a>
			</c:when>
			<c:otherwise>
			<c:out value="${pageContext.request.userPrincipal.name}"/> | <a href='<%=userService.createLogoutURL(request.getContextPath())%>'>log out</a>
			</c:otherwise>
			</c:choose>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
		<div class="row">
			<div class="span1"><img src="/pins/<c:out value="${pin}"/>.png"></div>
			<div class="span11">
				<h1>Trading notice board</h1>
			</div>
		</div>
		<div style="height:10px">&nbsp;</div>
		<div class="row">
			<div class="span12 well" align="center">
			<form action="/BoardPostMessage" method="POST">
				<fieldset>
				<div><textarea name="message" style="width:80%" rows="5"></textarea></div>
				<input type="hidden" name="pin" value="<c:out value='${pin}'/>"/>
				<button class="btn btn-primary">Submit New Message</button>
				</fieldset>
			</form>
			</div>
		</div>
		
		<c:forEach var="message" items="${messages}">
			<div class="row">
				<div class="span12 well">
					<c:out value="${message.message}"/>
				</div>
				<div style="height:10px">&nbsp;</div>				
			</div>
		</c:forEach>
		
    </div> <!-- /container -->
	<footer><div class="modal-footer" align="center">Site developed and &copy;Copyright 2012 <a href="http://www.alsutton.com/">Al Sutton</a> of <a href="http://www.funkyandroid.com/" target="_blank">Funky Android Ltd.</a>, All Rights Reserved.<br/>This site is <b>not</b> owned, operated, or approved by Google</div></footer>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/bootstrap.js"></script>
    <script src="/js/bootstrap-collapse.js"></script>
	<script>$(".collapse").collapse()</script>
  </body>
</html>