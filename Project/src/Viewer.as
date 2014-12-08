package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author garymar
	 */
	public class Viewer 
	{
		private var asset:MainViewerClass;
		
		public function Viewer(container:Sprite) 
		{
			asset = new MainViewerClass();
			container.addChild(asset);
		}
		
		public function txtNearID():TextField
		{
			return asset.txtNearID;
		}
		
		public function txtFarID():TextField
		{
			return asset.txtFarID;
		}
		
		public function btnSubdcribe():SimpleButton
		{
			return asset.btnSubscribe;
		}
		
	}

}