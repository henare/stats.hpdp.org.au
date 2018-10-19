<cfapplication name="pool" 
	clientmanagement="yes"
	clientstorage="registry"
	setclientcookies="yes"
	sessionmanagement="yes"
	sessiontimeout=#CreateTimeSpan(0, 6, 0, 0)#>

<!--- <cferror type="exception" template="error.cfm" /> --->

<cfparam name="session.admin" default="0">
<cfparam name="session.year" default="#year(now())#">
<cfparam name="session.week" default="0">

<cfif isdefined("url.year")><cfset session.year=url.year></cfif>
<cfif isdefined("url.week")><cfset session.week=url.week></cfif>

<cftry>
<cfquery dataSource="pool" name="np">select * from `np` where `year`=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_VARCHAR"/> and `week`=<cfqueryparam value="#session.week#" cfsqltype="CF_SQL_VARCHAR"/></cfquery>
<cfcatch type="database">
	<cfquery dataSource="pool">CREATE TABLE `np` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `year` INT NOT NULL, `week` INT NOT NULL) ENGINE = MYISAM</cfquery>
	<cfquery dataSource="pool">INSERT INTO `np` (`year`, `week`) VALUES (2004, 38),(2004, 39),(2004, 40),(2005, 44),(2005, 45),(2005, 46),(2007, 6),(2007, 7),(2007, 8),(2008, 41),(2008, 42),(2008, 43),(2009, 41),(2009, 42),(2009, 43);</cfquery>
	<cfquery dataSource="pool" name="np">select * from `np` where `year`=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_VARCHAR"/> and `week`=<cfqueryparam value="#session.week#" cfsqltype="CF_SQL_VARCHAR"/></cfquery>
</cfcatch>
</cftry>
<cfset nickPower = np.recordCount>

<cfquery dataSource="pool" name="wk0">select * from `dates` where `year`=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_VARCHAR"/></cfquery>
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
<cfif (template is "input.cfm" or template is "replace.cfm" or template is "week0.cfm") and not session.admin>
	<cflocation url="login.cfm?target=#urlencodedformat(GetFileFromPath(GetTemplatePath())&"?"&CGI.QUERY_STRING)#" addtoken="no">
	<cfabort>
</cfif>

<cfset ts=dateformat(now(),"dmy")&timeformat(now(),"hms")>

<script language="JavaScript">if(this!=top)	top.location="."</script>

<meta name="ROBOTS" content="NOINDEX, NOFOLLOW">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
