<cfparam name="nm" default="">
<cfparam name="nm2" default=""><cfif nm2 is nm><cfset nm2=""></cfif>
<cfparam name="sortfield" default="played">
<cfparam name="dir" default="desc">
<cfparam name="type" default="numeric">
<cfparam name="top20" default="0">
<cfparam name="weeklist" default="">

<html>
<head>
<cfoutput>
<title>HPDP Pool Comp - #nm#</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript">
W3C = (document.getElementById) ? 1 : 0;
IE4 = (document.all && !W3C) ? 1 : 0;
doc = W3C?document.getElementsByTagName('*'):(IE4?document.all:false)
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
}
function opponent(opp){
	with(document.forms[0]){
		nm2.value=opp;
		submit()
	}
}
function player(pname){
	i=0
	with(document.forms[0]){
		while(nm.options[i].text!=pname)
			{i++}
		nm.selectedIndex=i
		submit()
	}
}
</script>
</head>
<body topmargin="2">

<table border=0 cellspacing=0 cellpadding=0>
<tr>
<td width="150" rowspan=32 nowrap valign="top"><a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
<p>
<b class="pgTitle">Player Profile</b>
<cfif session.year lt 2003><br><br><br><nobr>not available for this year</nobr><br><br><br><a href="javascript:history.go(-1)" class="sm">back</a></td></tr></table></form></body></html><cfabort></cfif>
<br><br>
<cfquery datasource="pool" name="names">select distinct name from games where name<>'' and year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> order by name</cfquery>
<form action="player.cfm" method="get">
<select name="nm" onChange="this.form.submit()" class="weekSelect">
<cfif nm is ""><option>-select player-</cfif>
<cfloop query="names"><option <cfif name is nm>selected</cfif>>#name#</option></cfloop>
</select>
<input type="hidden" name="nm2" value="#htmleditformat(nm2)#">
<input type="hidden" name="sortfield" value="#sortfield#">
<input type="hidden" name="dir" value="#dir#">
<input type="hidden" name="type" value="#type#">
<input type="hidden" name="top20" value="#top20#">
<input type="hidden" name="#ts#" value="">
<br><br>

<cfinclude template="menu.cfm">

<!---<br>
<a href="photos.cfm?nm=#urlencodedformat(nm)#&#ts#">add pic</a><br><br>

<cfinclude template="pictures.cfm">--->
</div>
</form>
</td>
</cfoutput>
<cfif nm is "">
	</tr></table></body></html><cfabort>
</cfif>
<td valign="top">
<br>

<!--- STATS --->
<cfset sc=structNew()>
<cfquery datasource="pool" name="scoring">select * from scoring where year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/></cfquery>
<cfoutput query="scoring">
	<cfset sc[week]=structNew()>
	<cfset sc[week].bb=bb>
	<cfset sc[week].modifier=modifier>
	<cfloop index="i" from="1" to="6">
		<cfset sc[week]['r'&i] = evaluate("r#i#")>
	</cfloop>
</cfoutput>
<cfquery datasource="pool" name="scoring">select * from scoring where year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/></cfquery>
<cfquery datasource="pool" name="weeks">select max(week) as maxweek from games where year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/></cfquery>
<cfif weeks.maxweek is ""><cfset weeks.maxweek=0></cfif>
<cfloop from="1" to="#weeks.maxweek#" index="i">
	<cfif not structKeyExists(sc,i)><cfset sc[i] = sc[-1]></cfif>
</cfloop>

<cfquery datasource="pool" name="top20results">select week from games where name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/> and year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> and buyback=0 and result=0 order by round desc,week LIMIT 20</cfquery>
<cfset weeklist=valuelist(top20results.week)>

<cfquery datasource="pool" name="results">select * from games where name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/> and year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> <cfif top20>and buyback=0 and week in (<cfqueryparam value="#weeklist#" cfsqltype="CF_SQL_INTEGER" list="true"/>)</cfif> order by name,week,round desc,buyback</cfquery>

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
	<cfoutput group="week">
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
	</cfoutput>
	<cfset ppl[name].ratio=numberformat(ppl[name].won/ppl[name].played,"_.00")>
	<cfset ppl[name].av=numberformat(ppl[name].av/ppl[name].weeks,"__._")>
</cfoutput>
<cfparam name="type" default="text">
<cfset p=structSort(ppl,"#type#","#dir#","#sortfield#")>
<cfset rounds="1st<br>Round,2nd<br>Round,3rd<br>Round,Semi<br>Final,2nd<br>Place,Win">

<cfoutput>
<cfif top20><b class="pgTitle" style="color:red"><i>Top20</i></b><span class="sm"> - 20 best results for the year (no buy backs)</span></cfif>
<table border="1" bordercolor="slateGray" cellspacing="0" cellpadding="0">
<tr bgcolor="##eeeeee"><!-- <td>&nbsp;</td> -->
<td rowspan="2" bgcolor="white" align="center" nowrap><h3>&nbsp;#nm#&nbsp;</h3><br><img src="spacer.gif" width="100" height="1"></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td width="45" align="center"><b>points</b></td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<cfloop from="6" to="1" step="-1" index="i">
	<td align="center" width="45"><b>#listgetat(rounds,i)#</b></td>
</cfloop>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td align="center" width="45"><b>weeks<br>played</b></td>
<td align="center" width="45"><b>avg<br>round</b></td>
<cfif not top20>
	<td align="center" width="45"><b>games<br>played</b></td>
	<td align="center" width="45"><b>games<br>won</b></td>
	<td align="center" width="45"><b>win<br>ratio</b></td>
	<td align="center" width="45"><b>buy<br>backs</b></td>
</cfif>
</tr>
<cfloop list="#arraytolist(p)#" index="n">
<tr>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td align="center" class="mid">#ppl[n].points#</td>
<td width="1"><img src="spacer.gif" width="1" height="1"></td>
<cfloop from="6" to="1" step="-1" index="i"><td align="center" class="mid"><cfif ppl[n]['r'&i] gt 0>#ppl[n]['r'&i]#<cfelse>-</cfif></td></cfloop>
 <td width="1"><img src="spacer.gif" width="1" height="1"></td>
<td align="center" class="mid">#ppl[n].weeks#</td>
<td align="center" class="mid">#ppl[nm].av#</td>
<cfif not top20>
	<td align="center" class="mid">#ppl[n].played#</td>
	<td align="center" class="mid">#ppl[n].won#</td>
	<td align="center" class="mid">#ppl[n].ratio#</td>
	<td align="center" class="mid"><cfif ppl[n].bb gt 0>#ppl[n].bb#<cfelse>-</cfif></td>
</cfif>
</tr>
</cfloop>
</table>
</cfoutput>
<p>
<cfflush>

<cfif not top20>
	<!--- OPPONENTS --->
	<h3>OPPONENTS</h3>
	<cfquery datasource="pool" name="history">select * from games g1,games g2 where (g1.week=g2.week and g1.round=g2.round and g1.game=g2.game) and (g1.name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/> or g2.name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/>) and g1.round<6 and g1.year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> and g2.year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> <cfif top20>and g1.buyback=0 and g1.week in (<cfqueryparam value="#weeklist#" cfsqltype="CF_SQL_INTEGER" list="true"/>)</cfif> order by g1.week desc,g1.round,g1.game,g1.result desc</cfquery>
	<cfset opp=structNew()>
	<cfoutput query="history" group="round">
		<cfoutput group="game">
			<cfoutput>
				<cfif name is ""><cfset n="-"><cfelse><cfset n=name></cfif>
				<cfif n is not nm>
					<cfset opp[n]=structNew()>
					<cfloop from="1" to="6" index="i"><cfset opp[n]['r'&i]=0></cfloop>
					<cfset opp[n].name=n>
					<cfset opp[n].played=0>
					<cfset opp[n].won=0>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	<cfoutput query="history" group="round">
		<cfoutput group="game">
			<cfoutput>
				<cfif name is ""><cfset n="-"><cfelse><cfset n=name></cfif>
				<cfif n is not nm>
					<cfset opp[n]['r'&round]=opp[n]['r'&round]+1>
					<cfset opp[n].played=opp[n].played+1>
					<cfset opp[n].won=opp[n].won+1-result>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cfoutput>
	<cfloop collection="#opp#" item="o"><cfset opp[o].ratio = numberformat(opp[o].won/opp[o].played,"_.00")></cfloop>
	<cfset p=structSort(opp,"#type#","#dir#","#sortfield#")>
	<cfoutput>
	<table><tr><td rowspan="2" width="70"></td><td valign="top" rowspan="2">
	<br>
	
	<table border="1" bordercolor="slateGray" cellspacing="0" cellpadding="0">
	<tr bgcolor="##eeeeee"><!-- <td>&nbsp;</td> -->
	<td width="100" rowspan="2">&nbsp;<a href="javascript:sortBy('name',<cfif sortfield is "name" and dir is "asc">'desc'<cfelse>'asc'</cfif>,'text')" class="title">opponent</a></td>
	<td width="1" rowspan="2"><img src="spacer.gif" width="1" height="1"></td>
	<td align="center" width="45" rowspan="2">
		<a href="javascript:sortBy('played',<cfif sortfield is "played" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">games<br>played</a>
	</td>
	<td align="center" width="45" rowspan="2">
		<a href="javascript:sortBy('won',<cfif sortfield is "won" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">games<br>won</a>
	</td>
	<td align="center" width="45" rowspan="2">
		<a href="javascript:sortBy('ratio',<cfif sortfield is "ratio" and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">win<br>ratio</a>
	</td>
	<cfif session.year ge 2004>
		<td width="1" rowspan="2"><img src="spacer.gif" width="1" height="1"></td>
		<td align="center" colspan="5"><b>round</b></td>
		</tr>
		<tr bgcolor="##eeeeee">
		<cfloop from="1" to="5" index="r">
			<td align="center" width="20"><a href="javascript:sortBy('r#r#',<cfif sortfield is 'r'&r and dir is "desc">'asc'<cfelse>'desc'</cfif>,'numeric')" class="title">#r#</a></td>
		</cfloop>
		</tr>
	<cfelse>
		</tr>
		<tr></tr>
	</cfif>
	
	<cfloop list="#arraytolist(p)#" index="o">
	<a href="javascript:opponent('#htmleditformat(o)#')"><tr onClick="opponent('#htmleditformat(o)#')" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" class="list">
	<td nowrap>&nbsp;<a href="javascript:opponent('#htmleditformat(o)#')" class="black">#o#</a>&nbsp;</td>
	<td width="1"><img src="spacer.gif" width="1" height="1"></td>
	<td align="center">#opp[o].played#</td>
	<td align="center">#opp[o].won#</td>
	<td align="center">#opp[o].ratio#</td>
	<cfif session.year ge 2004>
		<td width="1"><img src="spacer.gif" width="1" height="1"></td>
		<cfloop from="1" to="5" index="r">
			<td align="center"><cfif opp[o]['r'&r] is 0>-<cfelse>#opp[o]['r'&r]#</cfif></td>
		</cfloop>
	</cfif>
	</tr>
	</a>
	</cfloop>
	</table>
	<div align="right" class="sm"><i>click for opponent history</i></div>
	<br>
	</cfoutput>
	</td>
	<td valign="top" colspan="2">
	<!--- OPPONENT HISTORY --->
	<cfif nm2 is "">
		</td></tr><tr><td>
	<cfelse>
		<cfoutput>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <b>#nm# vs #nm2#</b></cfoutput>
		</td></tr>
		<tr><td width="100"></td><td valign="top">
		<cfquery datasource="pool" name="history">
			select g1.*,g2.name as name2,g2.buyback as buyback2 from games g1,games g2 
			where 	(g1.year=g2.year and g1.week=g2.week and g1.round=g2.round and g1.game=g2.game) 
				and g1.name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/> and g2.name=<cfqueryparam value="#nm2#" cfsqltype="CF_SQL_VARCHAR"/> 
				and g1.round<6 and g1.year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> 
				<cfif top20>and g1.buyback=0 and g1.week in (<cfqueryparam value="#weeklist#" cfsqltype="CF_SQL_INTEGER" list="true"/>)</cfif>
			order by g1.week desc,g1.buyback,g1.path,g1.round,g1.game
		</cfquery>
		<cfset histType="opponent">
		<cfinclude template="history.cfm">
	</td></tr></cfif>
	</table>
</cfif>	
<cfflush>

<!--- HISTORY --->

<h3>HISTORY</h3>
<cfquery datasource="pool" name="history">
	select g1.*,g2.name as name2,g2.buyback as buyback2 from games g1,games g2 
	where 	(g1.year=g2.year and g1.week=g2.week and g1.round=g2.round and g1.game=g2.game) 
		and g1.name=<cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/> and g2.name<><cfqueryparam value="#nm#" cfsqltype="CF_SQL_VARCHAR"/>
		and g1.round<6 and g1.year=<cfqueryparam value="#session.year#" cfsqltype="CF_SQL_INTEGER"/> 
		<cfif top20>and g1.buyback=0 and g1.week in (<cfqueryparam value="#weeklist#" cfsqltype="CF_SQL_INTEGER" list="true"/>)</cfif>
	order by g1.week desc,g1.buyback,g1.path,g1.round,g1.game
</cfquery>
<cfset histType="overall">
<cfinclude template="history.cfm">

</td></tr>
</table>

<cfinclude template="footer.cfm">
</body>
</html>
