<!---
<div style="position:absolute"><img src="spacer.gif" height="80" id="player" border="2" style="height:80; border-color:white"></div>
--->
<!--- set picture array --->
<!---<cfquery datasource="pool" name="pics">select * from pics order by name,picID desc</cfquery>
<script language="JavaScript">
	var pic=new Array()
	a = new Image(); a.src = "a.gif";
	spacer = new Image(); spacer.src = "spacer.gif";
	<cfoutput query="pics" group="name"><cfset n = "p_#replace(name," ","_","all")#">
	#n# = new Image(); #n#.src="pics/#pic#";
	</cfoutput>
	function setPhoto(p,r){
		if(!document.getElementById) return
		nm = p.options[p.selectedIndex].text
		photo = eval("window.p_"+nm.replace(/ /g,'_'))
		document.getElementById("player").src=photo?photo.src:spacer.src
	}
</script>
--->

<script language="JavaScript">
	function setPhoto(p,r){
		return
	}
</script>
