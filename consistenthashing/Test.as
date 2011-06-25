package {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFormat;
  
  [SWF(width="465", height="465", backgroundColor="#000000")]
  
  public class Test extends Sprite {
    private var nodes:Vector.<String>;
    private var hash:ConsistentHash;
    private var hist:Object;
    private var num:uint = 40;
    private var replicas:uint = 150;
    private var tf:TextField;
    
    public function Test():void {
      p("*** Consistent Hashing Implementation ***\n");
      nodes = new <String>['node_01', 'node_02', 'node_03', 'node_04'];
      hash = new ConsistentHash(nodes.slice(0, 3), replicas);
      hist = {'node_01':[], 'node_02':[], 'node_03':[], 'node_04':[]};
      p('numbers of replicas: ' + replicas);
      p('key: [1..' + num + "]\n");
      p('node list: ' + hash.toString());
      createHist();
      p("\nadd node: " + nodes[3]);
      hash.add(nodes[3]);
      p('node list: ' + hash.toString());
      createHist();
      p("\nremove node: " + nodes[0]);
      hash.remove(nodes[0]);
      p('node list: ' + hash.toString());
      createHist();
    }
    private function createHist():void {
      var text:String, len:uint;
      for each(var bin:Array in hist) {
        bin.length = 0;
      }
      for(var i:int = 0; i < num; i++) {
        hist[hash.get(i.toString())].push(i);
      }
      for each(var node:String in nodes) {
        len = hist[node].length;
        text = '  ' + node;
        if(0 < len && len < 10) {
          p(text + ' ( ' + len + ' keys): ' + hist[node]);
        }else if(len >= 10) {
          p(text + ' (' + len + ' keys): ' + hist[node]);
        }else {
          p(text + ' ( ' + len + ' keys): unknown node');
        }
      }
    }
    private function p(str:String):void {
      if(!tf) {
        tf = new TextField();
        tf.x = 10;
        tf.y = 20;
        tf.width = tf.height = 465;
        tf.defaultTextFormat = new TextFormat('Courier New', 12, 0x00ff66, true);
        addChild(tf);
      }
      tf.appendText(str + "\n");
    }
  }
}