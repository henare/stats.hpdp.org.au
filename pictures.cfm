<cfparam name="nm" default="">
<cfparam name="load" default="0">
<cfquery datasource="pool" name="img">select * from pics where name='#nm#' order by picID desc</cfquery>

<div style="position:absolute">
<cfoutput query="img">
	<a href="pics/#pic#"><img src="pics/#pic#" onMouseOver="zoom(this)" onMouseOut="time=setTimeout('zoom(0)',500)" id="img#picID#" style="height:80; border-color:white" align="left" border="1"></a>
	<cfif load>
		<a href="pics/#pic#" onMouseOver="clearTimeout(time)">view</a><br>
		<a href="javascript:if(confirm('Are you sure?')){location='photos.cfm?nm=#nm#&del=#picID#&#ts#'}" onMouseOver="clearTimeout(time)">delete</a><br>
	</cfif><br clear="all">
</cfoutput>
<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
</div>

<script language="JavaScript">
var time=0
function zoom(pic){
	<cfif load>//return</cfif>
	if(pic==0){
		for(i=0;i<document.images.length;i++){
			if(document.images[i].id.substr(0,3)!='img')	break
			document.images[i].style.height='80'
		}
		return
	}
	clearTimeout(time)
	pic.style.height='288'
	for(i=0;i<document.images.length;i++){
		if(document.images[i].id.substr(0,3)!='img')	break
		if(pic!=document.images[i])
			document.images[i].style.height='80'
	}
}
</script>

