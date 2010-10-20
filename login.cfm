<cfset session.admin=0><cfparam name="target" default="input.cfm">
<html>
<head>
<title>HPDP Pool Comp</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript">//<!--
W3C = (document.getElementById) ? 1 : 0;
IE4 = (document.all && !W3C) ? 1 : 0;
doc=W3C?document.getElementsByTagName('*'):(IE4?document.all:false)
//--></script>
</head>

<body onLoad="document.forms[0].password.focus()">
<span class="h1">HPDP Pool Comp</span>
<form action="<cfoutput>#target#<cfif find("?",target)>&<cfelse>?</cfif>#ts#</cfoutput>" method="post">
<blockquote>
<table><tr><td>
<b>login</b>
<input type="password" name="password" style="text-align:left">
</td></tr>
<tr><td align="right" class="sm"><label for="rem">remember password</label><input type="checkbox" name="remember" value="1" id="rem"></td></tr></table>
</blockquote>
</form>
</body>
</html>
