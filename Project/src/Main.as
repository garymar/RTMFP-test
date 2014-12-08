package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author garymar
	 */
	public class Main extends Sprite 
	{
		private var session:P2PSession;
		private var viewer:Viewer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			Log.init(stage);
			
			viewer = new Viewer(this);
			
			session = new P2PSession(viewer);
			session.Connect();
			
			viewer.btnSubdcribe().addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			if (viewer.txtFarID().text != "")
			{
				session.receiving(viewer.txtFarID().text);
			}
		}
		
	}
	
}