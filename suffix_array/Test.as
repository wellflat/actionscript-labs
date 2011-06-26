package {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFormat;
  
  [SWF(width="465", height="465", backgroundColor="#000000")]
  
  public class Test extends Sprite {
    private var sa:SuffixArray;
    private var tf:TextField;
    
    public function Test() {
      sa = new SuffixArray();
      tf = new TextField();
      tf.width = 465;
      tf.height = 465;
      tf.defaultTextFormat = new TextFormat('Courier New', 12, 0x00ff66, true);
      addChild(tf);
      var source:String = "SuffixArrayExample";
      var target:String = "fi";
      sa.addEventListener(SuffixArray.BUILD_COMPLETE, function():void {
        tf.text = "Source String: " + source +
          "\n\n----- Suffix Array -----\n";
        tf.appendText(sa.toString());
        tf.appendText("\n------------------------\n" + 
          "Target Substring: " + target +
          "\nIndex: " + sa.search(target).toString());
      }, false, 0, true);
      sa.build(source);
    }
  }
}