<cfquery datasource="pool" name="weeks">select max(week) as w from games where year=#session.year#</cfquery>
<cfset maxWeek=iif(weeks.w is "",0,weeks.w)>
<cfquery datasource="pool" name="games">select * from games where week=#session.week# and year=#session.year#</cfquery>
<cfset res=structNew()>
<!--- initialise structure --->
<cfset ind=4><cfset r=1><cfset g=0><cfset c=32>
<cfloop index="i" from="1" to="63">
	<cfif i gt c>
		<cfset c=c+2^ind>
		<cfset ind=ind-1>
		<cfset r=r+1>
		<cfset g=0>
	</cfif>
	<cfset p=2-i mod 2>
	<cfset g=g+p mod 2>
	<cfset res[p&r&g]=structNew()>
	<cfset res[p&r&g].name="">
	<cfset res[p&r&g].buyback=0>
	<cfset res[p&r&g].result=0>
	<cfset res[p&r&g].balls="-">
</cfloop>
<!--- populate structure --->
<cfoutput query="games">
	<cfset res["#player##round##game#"].name=name>
	<cfset res["#player##round##game#"].buyback=buyback>
	<cfset res["#player##round##game#"].result=result>
	<cfif balls is not "">
		<cfset res["#player##round##game#"].balls=balls>
	</cfif>
</cfoutput>
<html>
<head>
<cfoutput>
<title>HPDP Pool Comp - Week #session.week#</title>
</cfoutput>
<link rel="stylesheet" type="text/css" href="style.css">
<script language="JavaScript">//<!--
W3C = (document.getElementById) ? 1 : 0;
IE4 = (document.all && !W3C) ? 1 : 0;
doc=W3C?document.getElementsByTagName('*'):(IE4?document.all:false)
function roll(cell,on){
	if(!doc) return
	cell.style.backgroundColor=on?"#eeeeee":"white"
}
//--></script>
</head>
<body topmargin="2">


<cfoutput>
<form action="sheet.cfm" method="get">
<table border=0 cellspacing=0 cellpadding=0 height="100%" width="100%">
<tr>
<td nowrap valign="top" width="130">
<a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
<cfif session.year lt 2003><br><br><br><nobr>not available for this year</nobr><br><br><br><a href="javascript:history.go(-1)" class="sm">back</a></td></tr></table></form></body></html><cfabort></cfif>

<p class="mid2">
<select name="week" onChange="this.form.submit()" class="weekSelect">
<option value="0"><cfif session.week is 0>-select a week-<cfelse>-summary-</cfif>
<cfloop index="wk" from="1" to="#maxWeek#"><option value="#wk#" <cfif wk is session.week>selected</cfif>>Week #wk#</option>
</cfloop>
</select><br>
<input type="hidden" name="#ts#" value="">
<cfif session.week gt 0 and games.recordCount gt 0>&nbsp;#dateformat(dateadd("ww",session.week,week0),"dd/mm/yy")#</cfif><br><br>
<br>

<cfinclude template="menu.cfm">

<br><br>
</cfoutput>
	<cfquery datasource="pool" name="scoring">select * from scoring where year=#session.year# and week=#session.week# order by week desc</cfquery>
	<cfoutput query="scoring">
		<div align="center"><br><br><br><br><br><br><br><br><br>
		<b class="sm3">scoring</b>
		<table cellpadding="0" cellspacing="0" border="1" bordercolor="slateGray" align="center">
		<tr><td class="sm3">&nbsp;<b>win</b></td><td class="sm3">#r6#</td></tr>
		<tr><td class="sm3">&nbsp;<b>final</b></td><td class="sm3">#r5#</td></tr>
		<tr><td class="sm3">&nbsp;<b>semi</b></td><td class="sm3">#r4#</td></tr>
		<tr><td class="sm3">&nbsp;<b>3rd</b></td><td class="sm3">#r3#</td></tr>
		<tr><td class="sm3">&nbsp;<b>2nd</b></td><td class="sm3">#r2#</td></tr>
		<tr><td class="sm3">&nbsp;<b>1st</b></td><td class="sm3">#r1#</td></tr>
		<tr><td class="sm3">&nbsp;<b title="multiplier applied to buy-backs">buyback</b>&nbsp;</td><td class="sm3">#bb#</td></tr>
		<tr><td class="sm3">&nbsp;<b title="multiplier applied to all">modifier</b>&nbsp;</td><td class="sm3">#modifier#</td></tr>
		</table>
		</div>
	</cfoutput>
</form>
</td>

<cfif games.recordCount is 0>
	<cfquery datasource="pool" name="winners">select * from games where year=#session.year# and (round=5 or round=4) order by week desc,round desc,result desc</cfquery>
	<cfif winners.recordCount is 0></tr></table></body></html><cfabort></cfif>
	<td valign="top"><blockquote><br><br>
	<table><tr><td align="right">
	<table border="1" bordercolor="slateGray" cellspacing="0" cellpadding="2">
	<tr bgcolor="#eeeeee"><td>&nbsp;&nbsp;</td><td><b>winner</b>&nbsp;</td><td><b>runner-up</b>&nbsp;</td><td colspan="2" align="center"><b>semi-finalists</b>&nbsp;</td></tr>
	<cfoutput query="winners" group="week">
		<a href="sheet.cfm?week=#week#&#ts#"><tr onClick="location='sheet.cfm?week=#week#&#ts#'" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" class="list"><td nowrap class="black"><a href="sheet.cfm?week=#week#&#ts#" class="black">Week #week# &nbsp; #dateformat(dateadd("ww",week,week0),"dd/mm/yy")#</td>
		</a><cfoutput><cfif round is 5 or result is 0><td nowrap>&nbsp;#name#&nbsp;</td></cfif></cfoutput>
		</tr></a>
	</cfoutput>
	</table>
	<div align="right" class="sm"><i>click for sheet</i></div>
	</td></tr></table>
	</blockquote>
	</td></tr>
	</table>
	<cfinclude template="footer.cfm">
	</body></html>
	<cfabort>
</cfif>

<td align="center">

<cfoutput>
<cfset rounds="Round 1,Round 2,Round 3,Semi Final,Final,Winner">
<table border="0" cellspacing="0" cellpadding="0">
<tr><cfloop from="1" to="6" index="i"><td height="1" align="center" class="sm"><img src="spacer.gif" border="0" height="1" width="100" hspace="0" vspace="0"><br><b>#listgetat(rounds,i)#</b></td><td colspan="2"></td></cfloop></tr>
<cfset n=32>
<cfloop from="#n#" to="1" step="-1" index="g">
	<tr>
	<cfset i=0>
	<cfloop condition="1">
		<cfset round  = i+1>
		<cfset game   = ceiling(((n-g)/(2^i)+1)/2)>
		<cfset player = ((n-g)/(2^i)) mod 2 + 1>
		<cfif round is not 1>
			<td align="right" rowspan="#evaluate(2^i)#" valign="middle" width="4"><img src="a.gif" width="1" height="#evaluate(8.5*2^(round-1))#"></td>
			<td align="right" rowspan="#evaluate(2^i)#" valign="middle"><img src="a.gif" width="5" height="1"></td>
		</cfif>
		<td align="left" rowspan="#evaluate(2^i)#" class="out" height="16">
		<cfif round is 1 and player is 1><img src="spacer.gif" border="0" height="1" width="1" hspace="0" vspace="0"><br></cfif>
		<table border="1" bordercolor="white" cellpadding=0 cellspacing=0 width="100%">
		<tr><a href="player.cfm?nm=#urlencodedformat(res["#player##round##game#"].name)#&#ts#"><td class="box" valign="top" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" nowrap>
		<cfif res["#player##round##game#"].buyback and res["#player##round##game#"].name is not ""><img src="a.gif" width="2" height="2" hspace="0" align="left"></cfif>
			&nbsp;<a href="player.cfm?nm=#urlencodedformat(res["#player##round##game#"].name)#&#ts#" class="black">#res["#player##round##game#"].name#</a>&nbsp;
		</td></a><cfif nickPower and round lt 6><td class="box" valign="top" width="15">#res["#player##round##game#"].balls#</td></cfif></tr>
		</table>
		<cfif round is 1 and player is 2><img src="spacer.gif" border="0" height="1" width="1" hspace="0" vspace="0"><br></cfif>
		</td>
		<cfif BitMaskRead(g,i,1) is 1><cfbreak></cfif>
		<cfset i=i+1>
	</cfloop>
	</tr>
</cfloop>
</table>

</td></tr>
</table>
</cfoutput>
<cfinclude template="footer.cfm">
</body>
</html>
