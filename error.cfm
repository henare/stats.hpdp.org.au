<cfset emails="bhspiers@gmail.com">

<cfset loc = "http://"&cgi.SERVER_NAME&CGI.SCRIPT_NAME>
<cfset tmp = loc>

<cfoutput>

<cfsavecontent variable="errorInfo">
	<style type="text/css"><!--
	BODY,FONT,TD,P	{	font-family : sans-serif; font-size : 10pt;}
	--></style>
	<p><b>#Error.Template#</b></p>
	<p>#Error.Diagnostics#</p>
	<cfif isArray(error.TagContext)>
		<p style="font-family:monospace">
		<cfloop from="1" to="1" index="i"><!--- #arraylen(error.TagContext)# --->
			<cffile action="read" variable="sourcecode" file="#error.TagContext[i].template#">
			<cfset src = listtoarray(sourcecode,chr(10))>
			<cfloop index="j" from="#max(1,error.TagContext[i].line-2)#" to="#min(arraylen(src),error.TagContext[i].line+2)#">
				<cfif j is error.TagContext[i].line><b></cfif>#rjustify(j,3)# : #htmleditformat(src[j])#<cfif j is error.TagContext[i].line></b></cfif><br>
			</cfloop>
		</cfloop>
		</p>
	</cfif>
	<table>
	<tr><td class=a>Template:</td><td class=a><a href="http://#cgi.SERVER_NAME##Error.Template#?#Error.QueryString#">http://#cgi.SERVER_NAME##Error.Template#?#Error.QueryString#</a></td></tr>
	<tr><td class=a>Referer:</td><td class=a><a href="#Error.HTTPReferer#">#Error.HTTPReferer#</a></td></tr>
	<tr><td class=a>Date/Time:</td><td class=a>#Error.DateTime#</td></tr>
	<tr><td class=a>Browser:</td><td class=a>#Error.Browser#</td></tr>
	<tr><td class=a>IP:</td><td class=a>#Error.RemoteAddress#</td></tr>
	<tr><td class=a>QueryString:</td><td class=a>#Error.QueryString#</td></tr>
	<cfif loc is not tmp><tr><td class=a>redirected to:</td><td class=a><a href="#tmp#">#tmp#</a></td></tr></cfif>
	</table><br>

	<cfdump var="#form#" label="form">

	<cfif isdefined("session")><cfdump var="#session#" label="session"></cfif>

	<cfdump var="#cgi#" label="cgi">

</cfsavecontent>

<!DOCTYPE html>
<html>
<head>
<title>Error!</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<div style="text-align:left; background:white; color:black; width:540px; margin:0 auto; padding:2em;">
	<br><br><br>
		<b>Beep. Error.</b>
		<p>
	<br><br><br>
	<p class="sm noline">
	<a href="javascript:location.reload()" class="noline">try again</a> /
	<a href="javascript:history.go(-1)" class="noline">back...</a>
	</p>
	<br><br>
	</div>
	
	<!--- <cfmail to="#emails#" subject="ERROR - #error.template#" from="bhspiers@gmail.com" type="HTML">#errorInfo#</cfmail>. --->

<br>
</body>
</cfoutput>


</html>

