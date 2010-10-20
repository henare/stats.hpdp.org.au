<cfif isdefined("form.name1")>
	<cfset name2 = ucase(name2)>
	<cfquery datasource="pool">update games set name='#name2#' where name='#name1#'</cfquery>
	<cfquery datasource="pool">update pics set name='#name2#' where name='#name1#'</cfquery>
	<b>OK, done</b>
</cfif>
<html>
<head>
<title>HPDP Replace</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<form action="replace.cfm" method="post">
<table>
<tr><td>replace:</td><td><input type="text" name="name1"></td></tr>
<tr><td>with:</td><td><input type="text" name="name2"></td></tr>
<tr><td colspan="2" align="right"><input type="submit" value="      ok      "></td></tr>
</table>
</form>


</body>
</html>
