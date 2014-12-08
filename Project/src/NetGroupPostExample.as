package  {

    import flash.display.Sprite;
    import flash.events.TextEvent;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import fl.events.ComponentEvent;
    import fl.controls.Label;
    import fl.controls.Button;
    import fl.controls.TextInput;
    import fl.controls.TextArea;
    import flash.text.TextFieldAutoSize;
    import flash.net.*;

    public class NetGroupPostExample extends Sprite{

        private var connectButton:Button;
        private var disconnectButton:Button;
        private var groupNameText:TextInput;
        private var userNameText:TextInput;
        private var chatText:TextInput;
        private var statusLog:TextArea;
        private var groupLabel:Label;
        private var userLabel:Label;

        private var netConnection:NetConnection = null;
        private var netGroup:NetGroup = null;
        private var sequenceNumber:uint = 0;
        private var connected:Boolean = false;
        private var joinedGroup:Boolean = false;

        private const SERVER:String = "rtmfp://fms.example.com/someapp";

        public function NetGroupPostExample() {
            DoUI();
        }

        // Writes messages to the TextArea.
        private function StatusMessage(msg:Object):void{
            statusLog.text += msg;
            statusLog.verticalScrollPosition = statusLog.textHeight;
            statusLog.validateNow();
        }

        // Handles all NetStatusEvents for the NetConnection and the NetGroup.
        // This code includes cases it doesn't handle so you can see the cases
        // and their info objects for learning purposes.
        private function NetStatusHandler(e:NetStatusEvent):void{
            StatusMessage(e.info.code + "\n");
            switch(e.info.code){
                case "NetConnection.Connect.Success":
                    connectButton.enabled = false;
                    disconnectButton.enabled = true;
                    OnConnect();
                    break;

                case "NetConnection.Connect.Closed":
                    OnDisconnect();
                    break;

                case "NetGroup.Connect.Success": // e.info.group
                    OnNetGroupConnect();
                    break;

                case "NetGroup.Connect.Rejected": // e.info.group
                case "NetGroup.Connect.Failed": // e.info.group
                    break;

                case "NetGroup.Posting.Notify": // e.info.message, e.info.messageID
                    OnPosting(e.info.message);
                    break;

                case "NetStream.MulticastStream.Reset":
                case "NetStream.Buffer.Full":
                    break;

                case "NetGroup.SendTo.Notify": // e.info.message, e.info.from, e.info.fromLocal
                case "NetGroup.LocalCoverage.Notify": //
                case "NetGroup.Neighbor.Connect": // e.info.neighbor
                case "NetGroup.Neighbor.Disconnect": // e.info.neighbor
                case "NetGroup.MulticastStream.PublishNotify": // e.info.name
                case "NetGroup.MulticastStream.UnpublishNotify": // e.info.name
                case "NetGroup.Replication.Fetch.SendNotify": // e.info.index
                case "NetGroup.Replication.Fetch.Failed": // e.info.index
                case "NetGroup.Replication.Fetch.Result": // e.info.index, e.info.object
                case "NetGroup.Replication.Request": // e.info.index, e.info.requestID
                default:
                    break;
                }
            }
        // Creates a NetConnection to Flash Media Server if the app isn't already connected
        // and if there's a group name in the TextInput field.
        private function DoConnect(e:MouseEvent):void{
            if(!connected && (groupNameText.length > 0)){
                StatusMessage("Connecting to \"" + SERVER + "\" ...\n");
                netConnection = new NetConnection();
                netConnection.addEventListener(NetStatusEvent.NET_STATUS, NetStatusHandler);
                // To connect to Flash Media Server, pass the server name.
                netConnection.connect(SERVER);
            }
            else
            {
                StatusMessage("Enter a group name");
            }
        }

        // Called in the "NetConnection.Connect.Success" case in the NetStatusEvent handler.
        private function OnConnect():void{

            StatusMessage("Connected\n");
            connected = true;

            // Create a GroupSpecifier object to pass to the NetGroup constructor.
            // The GroupSpecifier determines the properties of the group
            var groupSpecifier:GroupSpecifier;
            groupSpecifier = new GroupSpecifier("aslrexample/" + groupNameText.text);
            groupSpecifier.postingEnabled = true;
            groupSpecifier.serverChannelEnabled = true;

            netGroup = new NetGroup(netConnection, groupSpecifier.groupspecWithAuthorizations());
            netGroup.addEventListener(NetStatusEvent.NET_STATUS, NetStatusHandler);

            StatusMessage("Join \"" + groupSpecifier.groupspecWithAuthorizations() + "\"\n");

        }

        private function OnNetGroupConnect():void{
            joinedGroup = true;
        }

        private function DoDisconnect(e:MouseEvent):void{
            if(netConnection){
                netConnection.close();
            }
        }

        private function OnDisconnect():void{
            StatusMessage("Disconnected\n");
            netConnection = null;
            netGroup = null;
            connected = false;
            joinedGroup = false;
            connectButton.enabled = true;
            disconnectButton.enabled = false;
        }

        private function ClearChatText():void{
            chatText.text = "";
        }

        // Called when you the chatText field has focus and you press Enter.
        private function DoPost(e:ComponentEvent):void{
            if(joinedGroup){
                var message:Object = new Object;
                message.user = userNameText.text;
                message.text = chatText.text;
                message.sequence = sequenceNumber++;
                message.sender = netConnection.nearID;

                netGroup.post(message);
                StatusMessage("==> " + chatText.text + "\n");
            } else {
                StatusMessage("Click Connect before sending a chat message");
            }
            ClearChatText();
        }

        private function OnPosting(message:Object):void{
            StatusMessage("<" + message.user + "> " + message.text + "\n");
        }

        private function DoUI():void {

            groupLabel = new Label();
            groupLabel.move(20, 10);
            groupLabel.autoSize = TextFieldAutoSize.LEFT
            groupLabel.text = "Group name:"
            addChild(groupLabel);

            groupNameText = new TextInput();
            groupNameText.move(90, 10);
            groupNameText.text = "channel" + (int(Math.random() * 899) + 101);
            addChild(groupNameText);

            connectButton = new Button();
            connectButton.addEventListener(MouseEvent.CLICK, DoConnect);
            connectButton.move(205, 10);
            connectButton.label = "Connect";
            addChild(connectButton);

            disconnectButton = new Button();
            disconnectButton.addEventListener(MouseEvent.CLICK, DoDisconnect);
            disconnectButton.move(310, 10);
            disconnectButton.label = "Disconnect";
            disconnectButton.enabled = false;
            addChild(disconnectButton);

            statusLog = new TextArea();
            statusLog.move(30, 38);
            statusLog.width = 360;
            statusLog.height = 215;
            statusLog.editable = false;
            addChild(statusLog);

            userLabel = new Label();
            userLabel.move(20, 270);
            userLabel.autoSize = TextFieldAutoSize.LEFT
            userLabel.text = "User name:"
            addChild(userLabel);

            userNameText = new TextInput();
            userNameText.move(80, 270);
            userNameText.text = "user " + int(Math.random() * 65536);
            addChild(userNameText);

            chatText = new TextInput();
            chatText.addEventListener(ComponentEvent.ENTER, DoPost);
            chatText.move(185, 270);
            chatText.maxChars = 255;
            chatText.width = 215;
            addChild(chatText);

        }

        public function onPlayStatus(info:Object):void {}
        public function onMetaData(info:Object):void {}
        public function onCuePoint(info:Object):void {}
        public function onTextData(info:Object):void {}

    }

}