package {
  import flash.utils.Dictionary;

  public class NaiveBayes extends Classifier {
    private var thresholds:Dictionary;
    
    public function NaiveBayes(getFeatures:Function) {
      super(getFeatures);
      thresholds = new Dictionary();
    }
    public function getThreshold(category:String):Number {
      for(var c:String in thresholds) {
        if(c == category) {
          return thresholds[category];
        }
      }
      return 1.0;
    }
    public function setThreshold(category:String, threshold:Number):void {
      thresholds[category] = threshold;
    }
    // classify document into category
    public function classify(document:String):String {
      var probs:Dictionary = new Dictionary();
      var max:Number = 0.0;
      var best:String = null;
      getCategories().forEach(function(c:String, index:int, arr:Array):void {
        probs[c] = getProb(document, c);
        if(probs[c] > max) {
          max = probs[c];
          best = c;
        }
      });
      for(var c:String in probs) {
        var second:Number = probs[c]*getThreshold(best);
        if(c === best) continue;
        if(second > probs[best]) return "unknown";
      }
      return best;
    }
    // Bayes' theorem 
    // P(category|document) = P(document|category)P(category)/P(document)
    //
    public function getProb(document:String, category:String):Number {
      // P(category)
      var categoryProb:Number = getCategoryCount(category)/getTotalCount();
      // P(document|category)
      var documentProb:Number = getDocumentProb(document, category);
      return documentProb*categoryProb;  // ignore P(document)
    }
    // P(document|category)
    private function getDocumentProb(document:String, category:String):Number {
      var features:Dictionary = getFeatures(document);
      var prob:Number = 1.0;
      for(var f:String in features) {
        prob *= getWeightedFeatureProb(f, category);
      }
      return prob;
    }
  }
}