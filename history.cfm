<cfset gm=arrayNew(1)><cfset bb=arrayNew(1)><cfset hiRound=structNew()>
<cfset rounds="Round 1,Round 2,Round 3,Semi Final,Final">
<table border="0">
<cfoutput query="history" group="week">
<cfset hiRound[0]=0><cfset hiRound[1]=0>
<cfsavecontent variable="out">
	<cfoutput group="path">
		<cfoutput>
			<cfif result>
				<cfset gm[1] = name><cfset gm[2]=name2>
				<cfset bb[1] = buyback><cfset bb[2]=buyback2>
				<cfset hiRound[buyback]=round+1>
			<cfelse>
				<cfset gm[2] = name><cfset gm[1]=name2>
				<cfset bb[2] = buyback><cfset bb[1]=buyback2>
				<cfset hiRound[buyback]=round>
			</cfif>
			<td align="center">
				<b>#listgetat(rounds,round)#</b><br>
				<table border="1" bordercolor="white" cellpadding=0 cellspacing=0><tr>
				<a href="javascript:player('#htmleditformat(gm[1])#')"><td width="80" align="center" class="box" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" nowrap>
				<cfif bb[1]><img src="a.gif" width="2" height="2" hspace="0" align="left"></cfif>
				&nbsp;<a href="javascript:player('#htmleditformat(gm[1])#')" class="black">#gm[1]#</a>&nbsp;
				</td></a>
				</tr></table>
				def
				<table border="1" bordercolor="white" cellpadding=0 cellspacing=0><tr>
				<a href="javascript:player('#htmleditformat(gm[2])#')"><td width="80" align="center" class="box" onMouseOver="roll(this,1)" onMouseOut="roll(this,0)" nowrap>
				<cfif bb[2]><img src="a.gif" width="2" height="2" hspace="0" align="left"></cfif>
				&nbsp;<a href="javascript:player('#htmleditformat(gm[2])#')" class="black">#gm[2]#</a>&nbsp;
				</td></a>
				</tr></table>
			</td>
		</cfoutput>
		</tr><tr><td>&nbsp;</td>
	</cfoutput>
	<cfif hiRound[0] ge hiRound[1]>
		<cfset score=sc[week]['r'&hiRound[0]]*sc[week].modifier>
	<cfelse>
		<cfset score=sc[week]['r'&hiRound[1]]*sc[week].bb*sc[week].modifier>
	</cfif>
	</tr>
</cfsavecontent>

<tr>
<td valign="top" width="70" class="black" align="center">
	<b><a href="sheet.cfm?#ts#&week=#week#" class="black">Week #week#</a></b><br>
	#dateformat(dateadd("ww",week,week0),"d/mm/yy")#<br><br>
	<cfif histType is "overall"><i>#score# pt<cfif score neq 1>s</cfif></i></cfif>
</td>
#out#
</cfoutput>
</table>

