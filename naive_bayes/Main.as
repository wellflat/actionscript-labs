package {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.utils.Dictionary;
  
  [SWF(width="465", height="465", backgroundColor="#000000")]
  
  public class Main extends Sprite {
    private var nb:NaiveBayes;
    private var tf:TextField;
    
    public function Main():void {
      p("*** Document Classification using Naive Bayes ***\n");
      nb = new NaiveBayes(getFeatures);
      sampleTrain(nb); // training
      p("P(quick fox|good) = " + nb.getProb("quick fox", "good").toString());
      p("P(quick fox|bad) = " + nb.getProb("quick fox", "bad").toString());
      p("class 'quick fox': " + nb.classify("quick fox"));
      p("");
      p("P(quick money|good) = " + nb.getProb("quick money", "good").toString());
      p("P(quick money|bad) = " + nb.getProb("quick money", "bad").toString());
      p("class 'quick money': " + nb.classify("quick money"));
      p("");
      p("P(HTML5|good) = " + nb.getProb("HTML5", "good").toString());
      p("P(HTML5|bad) = " + nb.getProb("HTML5", "bad").toString());
      p("class 'HTML5': " + nb.classify("HTML5"));
      p("");
      nb.setThreshold("bad", 3.0);
      p("P(HTML5 Flash|good) = " + nb.getProb("HTML5 Flash", "good").toString());
      p("P(HTML5 Flash|bad) = " + nb.getProb("HTML5 Flash", "bad").toString());
      p("class 'HTML5 Flash': " + nb.classify("HTML5 Flash"));
      p("");
      for(var i:int=0; i<10; i++) { // more training
        sampleTrain(nb);
      }
      p("P(HTML5 Flash|good) = " + nb.getProb("HTML5 Flash", "good").toString());
      p("P(HTML5 Flash|bad) = " + nb.getProb("HTML5 Flash", "bad").toString());
      p("class 'HTML5 Flash': " + nb.classify("HTML5 Flash"));
    }
    // sample training set below
    private function sampleTrain(classifier:Classifier):void {
      classifier.train("Hello how are you?", "good");
      classifier.train("make quick money to live a good life", "bad");
      classifier.train("the quick brown fox jumps", "good");
      classifier.train("Dive into HTML5", "good");
      classifier.train("HTML5 vs. Flash comparison", "bad");
    }
    // make features(bug-of-words) from document
    private function getFeatures(doc:String):Dictionary {
      var delimiter:RegExp = /\W+/;
      var words:Array = [];
      var features:Dictionary = new Dictionary();
      for each(var s:String in doc.split(delimiter)) {
        if(s.length > 2) {
          words.push(s.toLowerCase());  
        }
      }
      for each(var w:String in words) {
        features[w] = 1;
      }
      return features;
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