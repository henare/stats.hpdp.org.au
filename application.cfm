<cfapplication name="pool" 
	clientmanagement="yes"
	clientstorage="registry"
	setclientcookies="yes"
	sessionmanagement="yes"
	sessiontimeout=#CreateTimeSpan(0, 6, 0, 0)#>

<cfparam name="session.admin" default="0">
<cfparam name="session.year" default="#year(now())#">
<cfparam name="session.week" default="0">

<cfif isdefined("url.year")><cfset session.year=url.year></cfif>
<cfif isdefined("url.week")><cfset session.week=url.week></cfif>
<cfset nickPower = session.year is 2004 and session.week ge 38 and session.week le 40 >
<cfset nickPower = nickPower or (session.year is 2005 and session.week ge 44 and session.week le 46) >
<cfset nickPower = nickPower or (session.year is 2007 and session.week ge 6 and session.week le 8) >
<cfset nickPower = nickPower or (session.year is 2008 and session.week ge 41 and session.week le 43) >
<cfset nickPower = nickPower or (session.year is 2009 and session.week ge 41 and session.week le 43) >

<cfquery dataSource="pool" name="wk0">select * from `dates` where `year`='#session.year#'</cfquery>
<cfset week0 = wk0.week0>

<!--- process login --->
<cfif isdefined("form.password") and form.password is "8ball...">
	<cfset session.admin=1>
	<cfif isdefined("form.remember")>
		<cfcookie name="poolComp" expires="never" value="#form.password#">
	<cfelse>
		<cfcookie name="poolComp" expires="now" value="">
	</cfif>
</cfif>
<!--- process logout --->
<cfif isdefined("out")>
	<cfcookie name="poolComp" expires="now" value="">
	<cfset session.admin=0>
</cfif>
<!--- cookie login --->
<cfif not session.admin and isdefined("cookie.poolComp") and cookie.poolComp is "8ball...">
	<cfset session.admin = 1>
</cfif>

<!--- redirect to login --->
<cfset template = GetFileFromPath(GetTemplatePath())>
<cfif (template is "input.cfm") and not session.admin>
	<cflocation url="login.cfm?target=#urlencodedformat(GetFileFromPath(GetTemplatePath())&"?"&CGI.QUERY_STRING)#" addtoken="no">
	<cfabort>
</cfif>

<cfset ts=dateformat(now(),"dmy")&timeformat(now(),"hms")>

<script language="JavaScript">if(this!=top)	top.location="."</script>

<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
