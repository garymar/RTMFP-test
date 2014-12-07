package  
{
	import adobe.utils.CustomActions;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	/**
	 * ...
	 * @author garymar
	 */
	public class P2PSession 
	{
		private var nc:NetConnection;
		private const DEVKEY:String = "cd20304be2752241d4b744de-449e48f2a6aa";
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		
		public function P2PSession() 
		{
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
		}
		
		public function Connect(): void
		{
			nc.connect(SERVER, DEVKEY);
		}
		
		private function onStatusEvent(e:NetStatusEvent):void 
		{
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					trace(e.info.code);
					break;
				case "":
					break;
				default:
					break;
			}
		}
		
	}

}