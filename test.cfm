<cfparam name="fltid" default="FFT663">

<cfobject component="info.flexination.cfcs.flight" name="objFltInfo">
<!--- invoke the getFlightDetails method from flight component/object --->
<cfscript>
	tmpdisplaythis = objFltInfo.getFlightDetails(fltid);
</cfscript>

<cfoutput>#tmpdisplaythis#</cfoutput>