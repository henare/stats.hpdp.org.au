<cfparam name="sortfield" default="points">
<cfparam name="dir" default="desc">
<cfparam name="type" default="numeric">
<cfparam name="top20" default="0">
<cfif not isBoolean(top20)><cfset top20=0></cfif>

<cfquery datasource="pool" name="weeks">select max(week) as maxweek from games where year=#session.year#</cfquery>
<cfparam name="wk" default="#weeks.maxweek#">
<cfif not isnumeric(wk)><cfset wk=weeks.maxweek></cfif>
<cfif not isnumeric(wk)><cfset wk=100></cfif>

<html>
<head>
<cfoutput>
<title>HPDP Pool Comp - Players' Ladder</title>
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
	with(document.forms[0]){
		sortfield.value=f;
		dir.value=d;
		type.value=t;
		submit()
	}
//	location="ladder.cfm?sort="+field+"&dir="+dir+"&type="+type+"&#ts#"
}
</script>
</head>
<body topmargin="2" <cfif isdefined("url.wk") and wk is not weeks.maxweek and session.year ge 2004>onload="document.forms[0].wk.focus()"</cfif>>

<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td rowspan=32 nowrap valign="top"><a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
<p>
<cfif top20><b class="pgTitle" style="color:red"><i>Top20</i></b>
<cfelse><b class="pgTitle">Ladder</b>
</cfif>
<br><br><br>
<br><br>

<cfinclude template="menu.cfm">


<form action="ladder.cfm" method="get" class="sm2">
<cfif session.year ge 2004 and isNumeric(weeks.maxweek)>
	<span class="sm3">
	standings at<br>
	<select name="wk" onChange="this.form.submit()" class="sm3">
	<cfloop from="#weeks.maxweek#" to="1" step="-1" index="w">
	<option value="#w#" <cfif wk is w>selected</cfif>>week #w#</option>
	</cfloop>
	</select><br>
	&nbsp;#dateformat(dateadd("ww",wk,week0),"dd/mm/yy")#
	</span>
</cfif>
<input type="hidden" name="sortfield" value="#sortfield#">
<input type="hidden" name="dir" value="#dir#">
<input type="hidden" name="type" value="#type#">
<input type="hidden" name="top20" value="#top20#">
<input type="hidden" name="#ts#" value="0">
</form>

</td>
<td valign="top">
<br>
</cfoutput>

<cfset sc=structNew()>
<cfquery datasource="pool" name="scoring">select * from scoring where year=#session.year#</cfquery>
<cfoutput query="scoring">
	<cfset sc[week]=structNew()>
	<cfset sc[week].bb=bb>
	<cfset sc[week].modifier=modifier>
	<cfloop index="i" from="1" to="6">
		<cfset sc[week]['r'&i] = evaluate("r#i#")>
	</cfloop>
</cfoutput>
<cfloop from="1" to="#wk#" index="i">
	<cfif not structKeyExists(sc,i)><cfset sc[i] = sc[-1]></cfif>
</cfloop>

<cfif top20>
	<cfquery datasource="pool" name="results">select * from games where year=#session.year# and week<=#wk# and buyback=0 and result=0 order by name,round desc,week</cfquery>
<cfelse>
	<cfquery datasource="pool" name="results">select * from games where year=#session.year# and week<=#wk# order by name,week,round desc,buyback,path</cfquery>
</cfif>

<cfset ppl=structNew()>
<cfoutput query="results" group="name">
	<cfset ppl[name]=structNew()>
	<cfloop from="1" to="6" index="i"><cfset ppl[name]['r'&i]=0></cfloop>
	<cfset ppl[name].name=name>
	<cfset ppl[name].bb=0>
	<cfset ppl[name].bbs=arrayNew(1)>
	<cfset ppl[name].points=0>
	<cfset ppl[name].weeks=0>
	<cfset ppl[name].played=0>
	<cfset ppl[name].won=0>
	<cfset ppl[name].av=0>
	<cfset ppl[name].weekList="">
	<cfoutput group="week">
		<cfif top20 and ppl[name].weeks ge 20>
			<cfset ppl[name].weeks=ppl[name].weeks+1>
		<cfelse>
			<cfset ppl[name].weekList=listappend(ppl[name].weekList,week)>
			<cfset ppl[name].points = ppl[name].points+sc[week]['r'&round]*iif(buyback,de(sc[week].bb),de(1))*sc[week].modifier>
			<cfset ppl[name]['r'&round]=ppl[name]['r'&round]+1>
			<cfset ppl[name].weeks=ppl[name].weeks+1>
			<cfset ppl[name].av=ppl[name].av+round>
			<cfset tmp=arraySet(ppl[name].bbs,1,32,0)>
			<cfoutput>
				<cfset ppl[name].bbs[path]=buyback>
				<!---<cfif round is 1><cfset ppl[name].bb=ppl[name].bb+buyback></cfif>--->
				<cfif round lt 6>
					<cfset ppl[name].played=ppl[name].played+1>
					<cfset ppl[name].won=ppl[name].won+result>
				</cfif>
			</cfoutput>
			<cfset ppl[name].bb=ppl[name].bb+arraySum(ppl[name].bbs)>
		</cfif>
	</cfoutput>
	<cfset ppl[name].av=numberformat(ppl[name].av/ppl[name].weeks,"__._")>
	<cfif not top20><cfset ppl[name].ratio=numberformat(ppl[name].won/ppl[name].played,"_.__")>
	<cfelse><cfset ppl[name].ratio="-">
	</cfif>
</cfoutput>

<cfset p=structSort(ppl,"#type#","#dir#","#sortfield#")>
<cfset rounds="1st<br>Round,2nd<br>Round,3rd<br>Round,Semi<br>Final,2nd<br>Place,Win">


<blockquote>
<cfoutput>
<cfif top20><b class="pgTitle" style="color:red"><i>Top20</i></b><span class="sm"> - 20 best results for the year (no buy backs)</span></cfif>
<table><tr><td>
<table border="1" bordercolor="slateGray" cellspacing="0" cellpadding="0">
<tr bgcolor="##eeeeee"><cfif sortfield is "points" and dir is "desc"><td>&nbsp;</td></cfif>
	<td width="100">&nbsp;<a href="javascript:sortBy('name',<cfif sortfield is "name" and dir is "asc">'desc'<cfelse>'asc'</cfif>,'text')" class="title">name</a></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td width="45" align="center"><a href="javascript:sortBy('points',<cfif sortfield is "points" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">&nbsp;points</a><a href="##points" class="title">*</a></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<cfloop from="6" to="1" step="-1" index="i">
	<td align="center" width="45"><a href="javascript:sortBy('r#i#',<cfif sortfield is "r#i#" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">#listgetat(rounds,i)#</a></td>
</cfloop>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td align="center" width="45">
	<a href="javascript:sortBy('weeks',<cfif sortfield is "weeks" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">weeks<br>played</a>
</td>
<td align="center" width="45">
	<a href="javascript:sortBy('av',<cfif sortfield is "av" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">avg<br>round</a>
</td>
<cfif not top20>
	<td align="center" width="45">
		<a href="javascript:sortBy('played',<cfif sortfield is "played" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">games<br>played</a>
	</td>
	<td align="center" width="45">
		<a href="javascript:sortBy('won',<cfif sortfield is "won" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">games<br>won</a>
	</td>
	<td align="center" width="45">
		<a href="javascript:sortBy('ratio',<cfif sortfield is "ratio" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">win<br>ratio</a>
	</td>
	<td align="center" width="45">
		<a href="javascript:sortBy('bb',<cfif sortfield is "bb" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">buy<br>backs</a>
	</td>
</cfif>
</tr>

<cfset c=0><cfset rank=1><cfset lastpoints=-1>
<cfloop list="#arraytolist(p)#" index="nm">
  <cfif not top20 or ppl[nm].weeks ge 20>
	<cfset c=c+1><cfif lastpoints neq ppl[nm].points><cfset rank=c></cfif>
	<cfset lastpoints=ppl[nm].points>
	<a href="player.cfm?nm=#urlencodedformat(nm)#<cfif top20>&top20=1</cfif>&#ts#"><tr onClick="location='player.cfm?nm=#urlencodedformat(nm)#<cfif top20>&top20=1</cfif>&#ts#'" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" class="list">
	<cfif sortfield is "points" and dir is "desc"><td align="right" class="sm3">&nbsp;#rank#&nbsp;</td></cfif>
	<td nowrap>&nbsp;<a href="player.cfm?nm=#urlencodedformat(nm)#<cfif top20>&top20=1</cfif>&#ts#" class="black">#nm#</a>&nbsp;</td>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<td align="center">#ppl[nm].points#</td>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<cfloop from="6" to="1" step="-1" index="i"><td align="center"><cfif ppl[nm]['r'&i] gt 0>#ppl[nm]['r'&i]#<cfelse>-</cfif></td></cfloop>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<td align="center">#ppl[nm].weeks#</td>
	<td align="center">#ppl[nm].av#</td>
	<cfif not top20>
		<td align="center">#ppl[nm].played#</td>
		<td align="center">#ppl[nm].won#</td>
		<td align="center">#replace(ppl[nm].ratio,"0.",".")#</td>
		<td align="center"><cfif ppl[nm].bb gt 0>#ppl[nm].bb#<cfelse>-</cfif></td>
	</cfif>
	</tr>
	</a>
  </cfif>
</cfloop>
</table>
</td></tr></table>
<div align="right" class="sm"><i>click for player profile&nbsp;</i></div>
<div align="center"><br><a name="points"><br></a>
<table cellspacing="0" cellpadding="0" border="1" bordercolor="silver">
<tr><td colspan="2"><b>* #session.year# Points System &nbsp;</b></td></tr>
<cfloop from="6" to="1" step="-1" index="i"><tr><td nowrap>#replace(listgetat(rounds,i),"<br>"," ")#</td><td align="center">#sc[-1]['r'&i]#</td></tr></cfloop>
<tr><td><i>buyback penalty</i></td><td align="center"><i><cfif sc[-1].bb is 1>none<cfelse>x#sc[-1].bb#</cfif></i></td></tr>
</table>
</div>
</blockquote>
</cfoutput>
</td></tr>
</table>

<cfinclude template="footer.cfm">
</body>
</html>
