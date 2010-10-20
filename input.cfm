<cfprocessingdirective suppresswhitespace = "Yes">

<cfif isdefined("deleteWk")>
	<cflock name="pool" timeout="30">
	<cfquery datasource="pool">delete from games where week=#url.deleteWk# and year=#session.year#</cfquery>
	<cflocation url="input.cfm?week=#deleteWk#" addtoken="no">
	</cflock>
</cfif>
<cfif isdefined("form.week")>
	<cfparam name="form.set_nickpower" default="0">
	<cfif form.set_nickpower and not nickPower>
		<cfquery dataSource="pool">insert into `np`(`year`,`week`) values('#session.year#','#form.week#')</cfquery>
		<cfset nickPower=1>
	<cfelseif not form.set_nickpower and nickPower>
		<cfquery dataSource="pool">delete from `np` where `year`='#session.year#' and `week`='#form.week#'</cfquery>
		<cfset nickPower=0>
	</cfif>
	<cflock name="pool" timeout="30">
	<cfquery datasource="pool">delete from games where week=#form.week# and year=#session.year#</cfquery>
	<cfloop from="1" to="63" index="i">
		<cfif evaluate("balls#i#") is ""><cfset form["balls#i#"]="NULL"></cfif>
		<cfquery datasource="pool">insert into 
			games  (year,week,round,game,path,player,name,result,buyback,balls)
			values (#session.year#,#form.week#,#evaluate("round#i#")#,#evaluate("game#i#")#,#evaluate("path#i#")#,#evaluate("player#i#")#,'#ucase(evaluate("name#i#"))#',#evaluate("result#i#")#,#evaluate("buyback#i#")#,#evaluate("balls#i#")#)
		</cfquery>
	</cfloop>
	<!---update scoring--->
	<cfif isdefined("form.scoring") and isNumeric(modifier) and isNumeric(bb) and isNumeric(r1) and isNumeric(r2) and isNumeric(r3) and isNumeric(r4) and isNumeric(r5) and isNumeric(r6)>
		<cfquery datasource="pool">delete from scoring where week=#form.week# and year=#session.year#</cfquery>
		<cfquery datasource="pool">insert into scoring(year,week,r1,r2,r3,r4,r5,r6,bb,modifier) values(#session.year#,#form.week#,#form.r1#,#form.r2#,#form.r3#,#form.r4#,#form.r5#,#form.r6#,#form.bb#,#form.modifier#)</cfquery>
	</cfif>
	<cflocation url="input.cfm?week=#form.week#" addtoken="no">
	</cflock>
</cfif>

<cfif week0 is "">
	<cflocation url="week0.cfm" addToken="no">
</cfif>


<cfquery datasource="pool" name="weeks">select max(week) as w from games where year=#session.year#</cfquery>
<cfset maxWeek=iif(weeks.w is "",1,"#weeks.w#+1")>
<cfset week=iif(session.week is 0 or session.week gt maxWeek,maxWeek,session.week)>
<cfquery datasource="pool" name="games">select * from games where week=#week# and year=#session.year#</cfquery>
<cfquery datasource="pool" name="names">select distinct name from games where name<>'' and year=#session.year# order by name</cfquery>

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
	<cfset res[p&r&g].balls="">
</cfloop>
<!--- populate structure --->
<cfoutput query="games">
	<cfset res["#player##round##game#"].name=name>
	<cfset res["#player##round##game#"].buyback=buyback>
	<cfset res["#player##round##game#"].result=result>
	<cfset res["#player##round##game#"].balls=balls>
</cfoutput>
<html>
<head>
<cfoutput><title>HPDP Pool Comp Input - Week #week#</title></cfoutput>
<script language="JavaScript">var playerList = new Array(''<cfoutput query="names">,'#name#'</cfoutput>)</script>
<script language="JavaScript" src="input.js" type="text/javascript"></script>

<link rel="stylesheet" type="text/css" href="style.css">
<style type="text/css">.box { text-align:left; width:10em;}</style>
</head>
<body topmargin="2">
<cfoutput>
<form action="input.cfm?week=#week#&#ts#" method="post" onSubmit="prepForm(this)">
<table border="0" cellspacing="0" cellpadding="0" height="100%">
<tr><td valign="top">
	<a href="." class="h1">HPDP&nbsp;<br>Pool Comp<br>#session.year#</a>
	<cfif session.year is not year(now())><br><a href="#template#?#rereplace(cgi.QUERY_STRING,"year=[0-9]*","")#&year=#year(now())#" class="sm2">&raquo; #year(now())#</a></cfif>
<p>
<select name="weekSelect" onChange="location='input.cfm?#ts#&week='+this.value" class="weekSelect">
<cfloop index="wk" from="1" to="#maxWeek#"><option value="#wk#" <cfif wk is week>selected</cfif>>Week #wk#</option>
</cfloop>
</select><br>
<input type="hidden" name="week" value="#week#">
	&nbsp;#dateformat(dateadd("ww",week,week0),"dd/mm/yy")#
	<p><input type="checkbox" value="1" name="set_nickpower" id="nickp" onclick="prepForm(this.form); this.form.submit()" <cfif nickPower>checked="checked"</cfif>><label for="nickp" <cfif not nickPower>style="color:silver"</cfif>> nick power</label></p>
	<input type="submit" value="  Save  " class="button"><br>
	<input type="button" value="Delete Week #week#" class="button" onClick="if(confirm('Are you sure?\n\nYou are about to delete this week\'s results.')){location='input.cfm?deleteWk=#week#'}"><br>
	<br><br>
	<cfinclude template="menu.cfm">
<!---
	<div class="sm2">
	<a href="ladder.cfm?#ts#">ladder</a><br>
	<cfif session.year ge 2004><a href="ladder.cfm?top20=1&#ts#">top20</a><br></cfif>
	<a href="sheet.cfm?#ts#">sheet</a><br>
	<a href="photos.cfm?#ts#">photos</a><br>
	<a href="ladder.cfm?out=1&#ts#">logout</a><br>
	</div>
	<br>
	<cfinclude template="showpic.cfm">
--->
	<cfquery datasource="pool" name="scoring">select * from scoring where year=#session.year# and (week=#week# or week=-1) order by week desc</cfquery>
		<div align="center"><br><br><br>
		<table border="0" cellpadding="0" cellspacing="0">
		<tr><td><input type="checkbox" name="scoring" value="1" onClick="setScoring(this)" id="sc">&nbsp;</td>
		<td class="sm3"><b><label for="sc">scoring</label></b></td></tr>
		</table>
		<table cellpadding="0" cellspacing="0" border="1" bordercolor="slateGray" align="center">
		<tr><td class="sm3">&nbsp;<b>win</b></td><td><input type="text" name="r6" value="#scoring.r6#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b>final</b></td><td><input type="text" name="r5" value="#scoring.r5#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b>semi</b></td><td><input type="text" name="r4" value="#scoring.r4#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b>3rd</b></td><td><input type="text" name="r3" value="#scoring.r3#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b>2nd</b></td><td><input type="text" name="r2" value="#scoring.r2#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b>1st</b></td><td><input type="text" name="r1" value="#scoring.r1#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b title="multiplier applied to buy-backs">buyback</b>&nbsp;</td><td><input type="text" name="bb" value="#scoring.bb#" size="2" disabled></td></tr>
		<tr><td class="sm3">&nbsp;<b title="multiplier applied to all">modifier</b>&nbsp;</td><td><input type="text" name="modifier" value="#scoring.modifier#" size="2" disabled></td></tr>
		</table>
		</div>
	<br>
</td>
<td>

<table border="0" cellspacing="0" cellpadding="0">
<cfset n=32><cfset c=0>
<cfloop from="#n#" to="1" step="-1" index="g">
	<tr>
	<cfset i=0>
	<cfloop condition="1">
		<cfset round    = i+1>
		<cfset game   = ceiling(((n-g)/(2^i)+1)/2)>
		<cfset player = ((n-g)/(2^i)) mod 2 + 1>
		<cfset c = 64-2^(7-round) + (game-1)*2 + player>
		<cfif round is not 1>
			<td align="right" rowspan="#evaluate(2^i)#" valign="middle" style="width:0.8em"><img src="a.gif" width="1" height="#evaluate((nickPower+10)*2^(round-1))#"></td>
			<td align="right" rowspan="#evaluate(2^i)#" valign="middle"><img src="a.gif" width="5" height="1"></td>
		<cfelse>
			<td align="right" rowspan="#evaluate(2^i)#" height=18 width="30" class="out">#c#</td>
		</cfif>
		<!---<b>#c#</b> #round# #game# #player#--->
		<cfif round is 1><td><input type="checkbox" name="bb#c#" style="height:16px" value="1" onClick="this.form.buyback#c#.value=this.checked?1:0" <cfif res["#player##round##game#"].buyback>checked</cfif>></td></cfif>
		<td align="right" rowspan="#evaluate(2^i)#" height=18 class="out" nowrap>
		<select name="name#c#" class="box" tabindex="#evaluate(c*2)#" onChange="setPlayers(#c#); setPhoto(this<cfif round is 1>,1</cfif>);" onFocus="currentIndx=this.selectedIndex; setPhoto(this);">
		<cfif round le 2>
			<option>
			<cfloop query="names"><option <cfif name is res["#player##round##game#"].name>selected</cfif>>#name#
			</cfloop><option>-new player-
		<cfelse>
			<option>
			<option <cfif res["1#round_##game_#"].name is res["#player##round##game#"].name and res["1#round_##game_#"].name is not "">selected</cfif>>#res["1#round_##game_#"].name#
			<option <cfif res["2#round_##game_#"].name is res["#player##round##game#"].name and res["2#round_##game_#"].name is not "">selected</cfif>>#res["2#round_##game_#"].name#
		
		</cfif></select><cfif nickPower and round lt 6><input type="text" name="balls#c#" value="#res["#player##round##game#"].balls#" tabindex="#evaluate(c*2+1)#" size="1" maxlength="1" style="width:2em; border:1px solid grey;" vspace="0"><cfelse><input type="hidden" name="balls#c#" value="#res["#player##round##game#"].balls#"></cfif>
		<input type="hidden" name="path#c#" value="#c#">
		<input type="hidden" name="round#c#" value="#round#">
		<input type="hidden" name="game#c#" value="#game#">
		<input type="hidden" name="player#c#" value="#player#">
		<input type="hidden" name="buyback#c#" value="<cfif res["#player##round##game#"].buyback>1<cfelse>0</cfif>">
		<input type="hidden" name="result#c#" value="0">
		</td>
		<cfif BitMaskRead(g,i,1) is 1><cfbreak></cfif>
		<cfset i=i+1>
		<cfset game_=game>
		<cfset round_=round>
	</cfloop>
	</tr>
</cfloop>
</table>

</td></tr>
</table>
</form>
</cfoutput>
<cfinclude template="footer.cfm">
</body>
</html>
</cfprocessingdirective>
