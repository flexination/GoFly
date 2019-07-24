<cfcomponent displayname="flight" hint="This component contains the functions that handles the Flex data requirements" output="false">
	<cffunction name="getFlightDetails" displayname="getFlightDetails" hint="This function cfhttp's a page and scapes out the data for an flight's details" access="remote" output="false" returntype="String">
		<cfargument name="flightnumber" type="string" required="true">
			<cfsetting 	enableCFoutputOnly="yes" showDebugOutput="no">
			<cftry>
				<cfhttp url="http://flightaware.com/live/flight/#arguments.flightnumber#" method="GET" resolveurl="Yes"/>
			<cfcatch type="Any">
				<cfscript>
					data = "GoFly couldn't find Flight " & arguments.flightnumber & " just yet.";
				</cfscript>
				<cfthrow message="getFlightDetails Error: #cfcatch.message# #cfcatch.detail#">
				<cflog log="getFlightDetails" application="false" text="#cfcatch.message# #cfcatch.detail#">
			</cfcatch>
			</cftry>
			<!--- two second delay to allow cfhttp to complete --->
			<cfset createObject("java", "java.lang.Thread").sleep(JavaCast("int", 2000))>
			<cftry>
				<cfscript>
					searchforstart = '<div id="bodyHeader">';
					searchforend = '<table width="100%" style="background-color: ##002F5D;">';
					charsbefore = #Find(searchforstart,  cfhttp.fileContent ,  1)#;
					tmpdisplaythis = #RemoveChars(cfhttp.fileContent, 1, (charsbefore-1))#;
					charsafter = #Find(searchforend,  tmpdisplaythis ,  1)#;
					data = #RemoveChars(tmpdisplaythis, charsafter, len(tmpdisplaythis) - len(charsafter))#;
					data = "<div align='left'>" & data & "</div>";
					DBwrite = writeFlightDetails(data, flightnumber);
				</cfscript>
			<cfcatch type="Any">
				<cfscript>
					data = "GoFly couldn't find Flight " & arguments.flightnumber & " just yet.";
				</cfscript>
				<cfthrow message="getFlightDetails Error: #cfcatch.message# #cfcatch.detail#">
				<cflog log="getFlightDetails" application="false" text="#cfcatch.message# #cfcatch.detail#">
			</cfcatch>
			</cftry>
			
		<cfreturn data/>
	</cffunction>

	<cffunction name="writeFlightDetails" displayname="writeFlightDetails" hint="This function writes out the html data to a database for an flight's details" access="remote" output="false" returntype="boolean">
		<cfargument name="html" type="string" required="true">
		<cfargument name="flightnumber" type="string" required="true">
		<cfscript>
			var qInsert = "";
			var timestamp = "";
			var blnSuccess = false;
			timestamp = DateFormat(Now(), "mm-dd-yyyy") & " " & TimeFormat(Now(), "HH:mm:ss");
			userip = getVisitorIP();
		</cfscript>
		
		<cftry>
			<cfquery name="qInsert" datasource="gofly"> 
				INSERT INTO tblflightinfo (flightnum, flightdetails, flightlookuptimestamp, userip, bActive) VALUES(<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.flightnumber#" />, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.html#" />, <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#timestamp#" />, <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userip#" />, 1)
			</cfquery>
			<cfset blnSuccess = true> 
		<cfcatch type="Any">
			<cfthrow message="writeFlightDetails Error: #cfcatch.message# #cfcatch.detail#">
			<cflog log="writeFlightDetails" application="false" text="#cfcatch.message# #cfcatch.detail#">
		</cfcatch>
		</cftry>
		   
   		<cfreturn blnSuccess/>
	</cffunction>
	
	<cffunction name="getArchivedFlights" displayname="getArchivedFlights" hint="This function retrieves a User's flight searches" access="remote" output="false" returntype="query">
		<cfargument name="flightnumber" type="string" required="true">
		<cfscript>
			var qSelect = "";
			userip = getVisitorIP();
		</cfscript>
		
		<cftry>
			<cfquery name="qSelect" datasource="gofly"> 
				SELECT flightid, flightnum, flightdetails, flightlookuptimestamp FROM tblflightinfo 
				WHERE userip = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userip#" />
				AND flightnum = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.flightnumber#" />
				ORDER BY flightlookuptimestamp ASC
			</cfquery>
			<cfset blnSuccess = true> 
		<cfcatch type="Any">
			<cfthrow message="writeFlightDetails Error: #cfcatch.message# #cfcatch.detail#">
			<cflog log="writeFlightDetails" application="false" text="#cfcatch.message# #cfcatch.detail#">
		</cfcatch>
		</cftry>
		   
   		<cfreturn qSelect/>
	</cffunction>

	<cffunction name="getArchivedFlightDetails" displayname="getArchivedFlights" hint="This function retrieves a flight's details" access="remote" output="false" returntype="query">
		<cfargument name="flightnumber" type="string" required="true">
		<cfargument name="flightid" type="string" required="true">
		<cfscript>
			var qSelect = "";
			userip = getVisitorIP();
		</cfscript>
		
		<cftry>
			<cfquery name="qSelect" datasource="gofly"> 
				SELECT * FROM tblflightinfo 
				WHERE userip = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userip#" />
				AND flightnum = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.flightnumber#" />
				AND flightid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.flightid#" />
			</cfquery>
			<cfset blnSuccess = true> 
		<cfcatch type="Any">
			<cfthrow message="writeFlightDetails Error: #cfcatch.message# #cfcatch.detail#">
			<cflog log="writeFlightDetails" application="false" text="#cfcatch.message# #cfcatch.detail#">
		</cfcatch>
		</cftry>
		   
   		<cfreturn qSelect/>
	</cffunction>

	<cffunction name="getVisitorIP" displayname="Get IP Address" hint="Returns Visitor's' IP address" access="remote" output="false" returntype="string">
		<cfset sIP = "#CGI.Remote_Addr#">
		
		<cfreturn sIP />
	</cffunction>
	
</cfcomponent>