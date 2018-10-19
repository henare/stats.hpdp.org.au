
<cfquery dataSource="pool" name="np1">select * from `np` where `year`=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_VARCHAR"/> and `week`=1</cfquery>

<cfif np1.recordCount>
	<cflocation url="NickPower.cfm?year=#year(now())#" addtoken="no">
<cfelse>
	<cflocation url="ladder.cfm?year=#year(now())#" addtoken="no">
</cfif>

<html>
<head>
<title>HPDP Pool Comp</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>

<cfoutput>
<body>
<table height="100%" width="100%" border="0">
<tr><td class="sm" valign="top" height="10%"><a href="http://www.hpdp.org.au/" class="sm"><i>hpdp.org.au</i></a></td></tr>
<tr>
<td align="center" height="60%">
	<a href="ladder.cfm?year=2008&week=0&#ts#" title="Harold Park Displaced Persons' Pool Comp">
	<h1>HPDP POOL COMP<br>
	2008</h1></a>
</td>
</tr>
<tr>
<td align="center" valign="top">
	<a href="ladder.cfm?year=2002&week=0&#ts#">2002</a> &nbsp; 
	<a href="ladder.cfm?year=2003&week=0&#ts#">2003</a> &nbsp; 
	<a href="ladder.cfm?year=2004&week=0&#ts#">2004</a> &nbsp;
	<a href="ladder.cfm?year=2005&week=0&#ts#">2005</a> &nbsp;
	<a href="ladder.cfm?year=2006&week=0&#ts#">2006</a> &nbsp;
	<a href="ladder.cfm?year=2007&week=0&#ts#">2007</a>
</td>
</tr>
<tr><td height="30%"></td></tr>
</table>

</body>
</html>
</cfoutput>
