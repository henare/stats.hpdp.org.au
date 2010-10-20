<cfquery datasource="pool" name="NP">select `week` as wk from `np` where `year`='#session.year#' order by week</cfquery>
<cfparam name="sortfield" default="points">
<cfparam name="dir" default="desc">
<cfparam name="type" default="numeric">
<html>
<head>
<cfoutput>
<title>HPDP Nick Power Cup</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript">
W3C = (document.getElementById) ? 1 : 0;
IE4 = (document.all && !W3C) ? 1 : 0;
doc=W3C?document.getElementsByTagName('*'):(IE4?document.all:false)
function roll(cell,on,ttl){
	if(!doc) return
	if(ttl)
		cell.style.color=on?"slateGray":"black"
	else
		cell.style.backgroundColor=on?"##eeeeee":"white"
}
function sortBy(f,d,t){
	location="NickPower.cfm?sortfield="+f+"&dir="+d+"&type="+t+"&#ts#"
}
</script>
</head>
<body topmargin="2">

<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td width="150" rowspan=32 nowrap valign="top"><a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
<p>
<cfif session.year lt 2004><br><br><br><nobr>not available for this year</nobr><br><br><br><a href="javascript:history.go(-1)" class="sm">back</a></td></tr></table></form></body></html><cfabort></cfif>
<cfif NP.recordCount is 0><br><br><br><nobr>not entered yet</nobr><br><br><br><a href="javascript:history.go(-1)" class="sm">back</a></td></tr></table></form></body></html><cfabort></cfif>
<div class="sm2">
<cfloop query="NP"><a href="sheet.cfm?week=#wk#&#ts#">week #currentRow#</a><br></cfloop>
</div>
<br><br><br>

<cfinclude template="menu.cfm">

</td>
<td valign="top">
<br><br>
</cfoutput>

<cfquery datasource="pool" name="results">
	select a.name,b.name as name2,a.balls as balls1,b.balls as balls2,a.week from games a,games b
	where 	(a.year=b.year and a.week=b.week and a.round=b.round and a.game=b.game and a.name<>b.name)
			and a.buyback=0 and a.balls is not null and a.year=#session.year# and a.week in (#valuelist(NP.wk)#)
	order by a.name,a.week
</cfquery>
<cfset ppl=structNew()>
<cfoutput query="results" group="name">
	<cfset ppl[name]=structNew()>
	<cfset ppl[name].name=name><cfset ppl[name].points=0><cfset ppl[name].diff=0>
	<cfloop query="NP"><cfset ppl[name]["w"&wk]=-1></cfloop>
	<cfoutput group="week">
		<cfset wk="w"&week>
		<cfset ppl[name][wk]=0>
		<cfoutput>
			<cfif balls2 is ""><cfset results.balls2=0></cfif>
			<cfset ppl[name][wk]=ppl[name][wk]+balls1>
			<cfset ppl[name].points=ppl[name].points+balls1>
			<cfset ppl[name].diff=ppl[name].diff+balls1-balls2>
		</cfoutput>
	</cfoutput>
</cfoutput>


<cfoutput>
<table width="100%">
<tr><td><b class="pgTitle">Nick Power Cup</b></td><td align="right" valign="bottom">#dateformat(dateadd("ww",NP.wk,week0),"dd/mm/yy")# - #dateformat(dateadd("ww",listlast(valuelist(NP.wk)),week0),"dd/mm/yy")#</td></tr>
<cfif session.year is 2004><tr><td colspan="2" align="center"><img src="pics/np2004.jpg" width="352" height="288" border="0"></td></tr></cfif>
</table>
<table border="1" bordercolor="slateGray" cellspacing="0" cellpadding="0">
<tr bgcolor="##eeeeee"><!-- <td>&nbsp;</td> -->
<td width="100">&nbsp;<a href="javascript:sortBy('name',<cfif sortfield is "name" and dir is "asc">'desc'<cfelse>'asc'</cfif>,'text')" class="title">name</a></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td width="70" align="center"><a href="javascript:sortBy('points',<cfif sortfield is "points" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">&nbsp;points&nbsp;</a></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<cfloop query="NP">
	<td align="center" width="70"><a href="javascript:sortBy('w#wk#',<cfif sortfield is "w#wk#" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">week&nbsp;#currentRow#</a></td>
</cfloop>
<!---<td align="center">
	<a href="javascript:sortBy('diff',<cfif sortfield is "diff" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">ball<br>difference</a>
</td>--->
</tr>

<cfset p=structSort(ppl,"#type#","#dir#","#sortfield#")>

<cfset c=0><cfset rank=1><cfset lastpoints=-1>
<cfloop list="#arraytolist(p)#" index="nm">
<cfif nm is not "BRIAN BUDD">
	<cfset c=c+1><cfif lastpoints neq ppl[nm].points><cfset rank=c></cfif>
	<cfset lastpoints=ppl[nm].points>
	<a href="player.cfm?nm=#urlencodedformat(nm)#&#ts#"><tr onClick="location='player.cfm?nm=#urlencodedformat(nm)#&#ts#'" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" class="list"><td nowrap>&nbsp;<a href="player.cfm?nm=#urlencodedformat(nm)#&#ts#" class="black">#nm#</a>&nbsp;</td>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<td align="center">#ppl[nm].points#</td>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<cfloop query="NP">
		<td align="center"><cfif ppl[nm]["w"&wk] ge 0>#ppl[nm]["w"&wk]#<cfelse>-</cfif></td>
	</cfloop>
	<!---<td align="center">#numberformat(ppl[nm].diff,"+0")#</td>--->
	</tr>
	</a>
</cfif>
</cfloop>
</table>

</cfoutput>

</td>
</tr>
</table>

</body>
</html>
