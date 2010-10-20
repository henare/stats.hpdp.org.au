<cfif isdefined("form.wk0") and form.wk0 is not "">
	<cflock name="pool" timeout="30">
		<cfquery datasource="pool">delete from `dates` where `year`='#session.year#'</cfquery>
		<cfquery datasource="pool">insert into `dates`(`year`,`week0`) values('#session.year#','#dateformat(dateadd('ww',-1,form.wk0),"yyyy-mm-dd")#')</cfquery>
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
