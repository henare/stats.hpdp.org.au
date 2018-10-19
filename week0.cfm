<cfif isdefined("form.wk0") and form.wk0 is not "">
	<cflock name="pool" timeout="30">
		<cfquery datasource="pool">delete from `dates` where `year`=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/></cfquery>
		<cfquery datasource="pool">insert into `dates`(`year`,`week0`) values(<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/>,'#dateformat(dateadd('ww',-1,form.wk0),"yyyy-mm-dd")#')</cfquery>
		<cfquery datasource="pool">delete from scoring where week='-1' and year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/></cfquery>
		<cfquery datasource="pool">insert into scoring(year,week,r1,r2,r3,r4,r5,r6,bb,modifier) values(<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/>,-1,0,1,2,4,8,16,0.5,1)</cfquery>
		<cflocation url="input.cfm" addtoken="no">
	</cflock>
</cfif>

<cfoutput>
<html>
<head>
<script type="text/javascript" src="datepicker/mootools-core.js"></script>
<script type="text/javascript" src="datepicker/datepicker.js"></script>
<link rel="stylesheet" type="text/css" href="datepicker/datepicker_vista.css">
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<form action="week0.cfm" method="post">
<p>set first week for <b>#session.year#</b>:
<input type="text" name="wk0" class="date_picker" value="<cfif isdate(week0)>#dateformat(dateadd("ww",1,week0),"yyyy-mm-dd")#</cfif>">
<input type="submit" value="ok">
</p>
</form>
</body>
</html>
</cfoutput>
