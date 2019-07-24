package info.airapps.actionscripts
{
	// imports needed for this AS Class
	import flash.events.NetStatusEvent;
	import flash.system.System;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import mx.managers.CursorManager;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import mx.core.Application;

	public class ConnectionStatus
	{
		// embed images and declare persistent image classes
		[Embed(source="../../../assets/images/smile.png")]
		[Bindable] public var imgConnected:Class;
		[Embed(source="../../../assets/images/frown.png")]
		[Bindable] public var imgDisconnected:Class;
		[Bindable] public var iStatus:int;
		
		// checks the connectivity by accessing the URL, http://labs.insideflex.com
		public function checkConnection():void {
			// triggers the display of a watch glass or busy cursor
			CursorManager.setBusyCursor();
			// declare a URLRequest variable
		    var headRequest:URLRequest = new URLRequest();
		    // set the URLRequest method to HEAD
		    headRequest.method = "HEAD";
		    // set the URL
		    headRequest.url = "http://labs.insideflex.com";
		    // declare a URLLoader variable and pass the URLRequest
			var response:URLLoader = new URLLoader(headRequest);
			/* add a HTTP_STATUS event listener: Listens for the HTTP_STATUS; 
			statusChanged() function is called when the listener event occurs */
		    response.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusChanged);
			/* add a IO_ERROR event listener: Listens for an I/O connectivity issue; 
			onError() function is called if the listener event occurs */
		    response.addEventListener(IOErrorEvent.IO_ERROR, onError); 
		}

		// handler function for HTTPStatusEvent events
		public function statusChanged(status:HTTPStatusEvent):void {
			// remove the watch glass or busy cursor
			CursorManager.removeBusyCursor();
			// conditional to check the status
			if (status.status == 0) {
				iStatus = 0;
			} else {
				iStatus = 1;
			}
			//Alert.show(iStatus.toString());
		}
		// handler function for IOErrorEvent events
		public function onError(error:IOErrorEvent):void {
			// remove the watch glass or busy cursor
			CursorManager.removeBusyCursor();
			iStatus = 0;
		}

		// handler function for networkChangeEvent events
		public function onConnectionChange(networkChangeEvent:Event):void {
			// check the connection
		    checkConnection();
		}
	}
}			