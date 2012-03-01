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
	<script>
		function setWant(statusarea) {
			statusarea.className='label label-important';
			statusarea.innerHTML='Want';			
		}
		function setHave(statusarea) {
			statusarea.className='label label-success';
			statusarea.innerHTML='Have';			
		}
		function setOffering(statusarea) {
			statusarea.className='label label-info';
			statusarea.innerHTML='Offering';			
		}
		function changeStatus(id) {
			identifier="status_";
			if(id < 10) {
				identifier += "0";
			}
			identifier += id;
			
			status = 0;
			obj = document.getElementById(identifier);
			if			(obj.innerHTML == 'Want') {
				setHave(obj)
				status = 1;
			} else if	(obj.innerHTML == 'Have') {
				setOffering(obj);
				status = 2;
			} else {
				setWant(obj);
			}
			
			url="/androidpinexchange?p="+id+"&s="+status;
			xmlHttp = new XMLHttpRequest();
			xmlHttp.open( "GET", url, false);
			xmlHttp.send( null );
		}
	</script>
	<%
	 	UserService userService = UserServiceFactory.getUserService();
	%>
    <meta charset="utf-8">
	<c:choose>
		<c:when test="${pageContext.request.userPrincipal eq null }">
   		<title>*UNOFFICIAL* MWC2012 Android Pin Exchange by Funky Android Ltd.</title>
   		</c:when>
   		<c:otherwise>
		<link rel="canonical" href="http://androidpinexchange.appspot.com/Collection?u=<%=userService.getCurrentUser().getUserId()%>" />
   		<title>My collection of Android MWC 2012 pins</title>
   		</c:otherwise>
   	</c:choose>
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

</script>  </head>

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
              <li class="active"><a href="#">Collect</a></li>
			  <c:if test="${pageContext.request.userPrincipal != null}">
              	<li><a href="/Trade">Trade</a></li>
    		  </c:if>
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
			<c:out value="${pageContext.request.userPrincipal.name}"/>&nbsp;|&nbsp;
			<a href='<%=userService.createLogoutURL(request.getContextPath())%>'>log out</a>
			</c:otherwise>
			</c:choose>
          </div>
        </div>
      </div>
    </div>

    <div class="container">

<div class="row"><div class="span12 label" align="center">
<c:choose>
<c:when test="${pageContext.request.userPrincipal eq null }">
Please <a href='<%=userService.createLoginURL(request.getRequestURI())%>' style="color:white; text-decoration: underline"">log in</a> to register your collection and trade.
</c:when>
<c:otherwise>Click on the status below the pin to change it.</c:otherwise>
</c:choose>
</div>
</div>	

<c:if test="${pageContext.request.userPrincipal != null }">
<div class="row"><div class="span12 label label-info" align="center">To share your collection with the world visit your <a href="http://androidpinexchange.appspot.com/Collection?u=<%=userService.getCurrentUser().getUserId()%>" style="color:white; text-decoration:underline">Collection Summary</a></div></div>
</c:if>
<% for(int i = 0 ; i < 8 ; i++) { %>
		<div class="row"><div class="span1">&nbsp;</div>
<% for(int j = 0 ; j < 10 ; j++) {
		StringBuilder imageUrl = new StringBuilder(128);
		imageUrl.append("/pins/");
		if(i > 0) {
			imageUrl.append(i);
		}
		imageUrl.append(j);
		imageUrl.append(".png");
		%>
		<div class="span1" align="center">
			<img src="<%=imageUrl%>">
			<c:if test="${pageContext.request.userPrincipal != null }">
				<br/><div align="center" class="label label-important" id="status_<%=i%><%=j%>" onclick="changeStatus(<%=i%><%=j%>)">Want</div>
			</c:if>
		</div>
<%	} %>
		<div class="span1">&nbsp;</div></div><div style="height:15px">&nbsp;</div>
<%  } %>
		<div class="row"><div class="span1">&nbsp;</div>
<% for(int j = 0 ; j < 6 ; j++) {
		StringBuilder imageUrl = new StringBuilder(128);
		imageUrl.append("/pins/8");
		imageUrl.append(j);
		imageUrl.append(".png");
		%>
		<div class="span1" align="center">
			<img src="<%=imageUrl%>">
			<c:if test="${pageContext.request.userPrincipal != null }">
				<br/><div align="center" class="label label-important" id="status_8<%=j%>" onclick="changeStatus(8<%=j%>)">Want</div>
			</c:if>
		</div>
<%	} %>
		<div class="span1">&nbsp;</div></div>
		<div class="span1">&nbsp;</div></div><div style="height:15px">&nbsp;</div>
    </div> <!-- /container -->
	<footer><div class="modal-footer" align="center">Site developed and &copy;Copyright 2012 <a href="http://www.alsutton.com/">Al Sutton</a> of <a href="http://www.funkyandroid.com/" target="_blank">Funky Android Ltd.</a>, All Rights Reserved.<br/>This site is <b>not</b> owned, operated, or approved by Google</div></footer>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/jquery-1.7.1.min.js"></script>
    <script src="/js/bootstrap.js"></script>
    <script src="/js/bootstrap-collapse.js"></script>
	<script>$(".collapse").collapse()</script>

	<c:if test="${pageContext.request.userPrincipal != null}">
    <script>
		$.getJSON(
			     '/androidpinexchangeStatus', 
			     { key: 'value', otherkey: true },
			     function(data){
			    	 for(i = 0 ; i < data.length ; i+=2) {
			    		if(data[i] < 0) 
			    			continue;
			    		pin = data[i];
						identifier="status_";
						if(pin < 10) {
							identifier += "0";
						}
						identifier += pin;
						obj = document.getElementById(identifier);

						status = data[i+1];
						if		  (status == 0) {
							setWant(obj);
						} else if (status == 1) {
							setHave(obj);
						} else if (status == 2) {
							setOffering(obj);
						}
			    	 }
			     }
			);
    </script>
	</c:if>
  </body>
</html>