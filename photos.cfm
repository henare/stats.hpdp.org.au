<cfparam name="nm" default="">

<cfif isdefined("url.del") and session.admin>
	<cfquery datasource="pool">delete from pics where picID=#url.del#</cfquery>
	<cflocation url="photos.cfm?nm=#nm#&#ts#" addtoken="no">
<cfelseif isdefined("form.imageFile")>
	<cffile action="upload" filefield="imageFile" accept="image/jpeg,image/pjpeg,image/gif" destination="#ExpandPath('pics')#" nameconflict="makeunique"><cfmodule template="/cgi-bin/check_file.cfm" file="#cffile#">
<!---	<cfexecute name="C:\Perl\ImageMagick-5.5.7-Q16\convert.exe" 
		arguments="#ExpandPath('pics')#\#cffile.serverFile# -resize 1000x80 #ExpandPath('pics')#\tn_#cffile.serverFile#" 
		timeout="2"></cfexecute>--->
	<cfquery datasource="pool">insert into pics(name,pic) values(<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/>,<cfqueryparam value="#cffile.serverFile#" cfsqltype="CF_SQL_VARCHAR"/>)</cfquery>
	<cflocation url="photos.cfm?nm=#nm#&#ts#" addtoken="no">
</cfif>
<html>
<head>
<cfoutput>
<title>HPDP Load Photos - #nm#</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript">
function valid(form){
	type=form.imageFile.value.substr(form.imageFile.value.length-4,4)
	return (type==".gif"||type==".jpg")
}
</script>
</head>
<body topmargin="2">

<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td width="150" rowspan=32 nowrap valign="top"><a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
<cfif session.year is not year(now())><br><a href="#template#?#rereplace(cgi.QUERY_STRING,"year=[0-9]*","")#&year=#year(now())#" class="sm2">#year(now())#</a></cfif>
<p>
<b class="pgTitle">Photos</b>
<cfif session.year lt 2003><br><br><br><nobr>not available for this year</nobr><br><br><br><a href="javascript:history.go(-1)" class="sm">back</a></td></tr></table></form></body></html><cfabort></cfif>
<br><br>
<cfquery datasource="pool" name="names">select distinct name from games where name<>'' and year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> order by name</cfquery>
<form action="photos.cfm" method="get">
<select name="nm" onChange="this.form.submit()" class="weekSelect">
<cfif nm is ""><option>-select player-</cfif>
<cfloop query="names"><option <cfif name is nm>selected</cfif>>#name#</option></cfloop>
</select>
<input type="hidden" name="#ts#" value="">
<br><br>
<div class="sm2">
<cfif session.admin>
<a href="input.cfm?#ts#">input</a><br>
<a href="photos.cfm?#ts#">photos</a><br>
<a href="player.cfm?nm=#urlencodedformat(nm)#&#ts#">player</a><br><br>
<a href="login.cfm?out=1&#ts#">logout</a><br>
<cfelse>
<a href="player.cfm?nm=#urlencodedformat(nm)#&#ts#">player</a><br><br>
</cfif>
</div>
</form>
</td>
<cfif nm is "">
	</tr></table></body></html><cfabort>
</cfif>
<td valign="top" width="280">
<br><br><br>
<form action="photos.cfm?nm=#nm#&#ts#" method="post" enctype="multipart/form-data" onSubmit="return valid(this)">
<b>Upload Photo</b><br>
<input type="file" name="imageFile" accept="image/jpeg,image/pjpeg,image/gif"><br>
<input type="submit" value="    OK    " style="font-size:8pt; font-weight:bold">
</form>
</td>
<td valign="top">
<cfset load=session.admin>
<cfinclude template="pictures.cfm">
</td></tr>
</table>
</cfoutput>

</body>
</html>
