package  
{
	import adobe.utils.CustomActions;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author garymar
	 */
	public class P2PSession 
	{
		private const DEVKEY:String = "cd20304be2752241d4b744de-449e48f2a6aa";
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		
		private var nc:NetConnection;
		private var sendStream:NetStream;
		private var recvStream:NetStream;
		private var viewer:Viewer;
		
		public function P2PSession(viewer:Viewer)
		{
			this.viewer = viewer;
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		}
		
		public function Connect(): void
		{
			nc.connect(SERVER, DEVKEY);
		}
		
		private function onStatusEvent(e:NetStatusEvent):void 
		{
			Log.view(e.info.code);
			
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					Log.view(nc.nearID);
					viewer.txtNearID().text = nc.nearID;
					publishing();
					break;
				case "NetGroup.Connect.Success":
					
					break;
					
				default:
					break;
			}
		}
		
		private function publishing():void 
		{
			sendStream = new NetStream(nc, NetStream.DIRECT_CONNECTIONS);
			sendStream.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
			sendStream.publish("media");
			
			var sendStreamClient:Object = new Object();
			sendStreamClient.onPeerConnect = function(callerns:NetStream):Boolean
			{
				Log.view("dsdsdsdsdsdsdsd "+callerns.farID);
				return true;
			}
			sendStream.client = sendStreamClient;
		}
		
		public function receiving(farID:String = ""):void
		{
			recvStream = new NetStream(nc, farID);
			recvStream.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
			recvStream.play("media");
			recvStream.client = this;
		}
		
	}

}