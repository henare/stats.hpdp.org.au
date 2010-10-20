<div class="sm2">
<cfoutput>
<cfif template is not "ladder.cfm">
	<a href="ladder.cfm?#ts#">ladder</a><br>
	<cfif session.year ge 2004><a href="ladder.cfm?top20=1&#ts#">top20</a><br></cfif>
<cfelseif top20><a href="ladder.cfm?#ts#">ladder</a><br>
<cfelseif session.year ge 2004><a href="ladder.cfm?top20=1&#ts#">top20</a><br>
</cfif>
<cfif template is not "sheet.cfm"><a href="sheet.cfm?#ts#">sheets</a><br></cfif>
<cfif template is not "player.cfm"><a href="player.cfm?#ts#">players</a><br></cfif>
<cfif template is not "NickPower.cfm" and session.year ge 2004 and session.year is not 2006><a href="NickPower.cfm?#ts#">nick power</a><br></cfif>
<br>
<cfif session.admin>
	<a href="input.cfm?#cgi.query_string#&#ts#">admin</a><br>
	<a href="ladder.cfm?out=1&#ts#">logout</a><br>
</cfif>

<cfif template is not "input.cfm">
	<cfloop index="y" from="#year(now())#" to="2002" step="-1">
		<cfif session.year is not y>
			<br><a href="#template#?#rereplace(cgi.QUERY_STRING,"&?year=[0-9]*","")#&year=#y#" class="sm2">#y#</a>
		</cfif>
	</cfloop>
	<br><br>
</cfif>
</cfoutput>
</div>
