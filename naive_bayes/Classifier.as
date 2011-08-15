package {
  import flash.utils.Dictionary;

  public class Classifier {
    private var featureCount:Dictionary;
    private var categoryCount:Dictionary;
    protected var getFeatures:Function;
    
    public function Classifier(getFeatures:Function) {
      this.featureCount = new Dictionary();
      this.categoryCount = new Dictionary();
      this.getFeatures = getFeatures;
    }
    public function train(document:String, category:String):void {
      var features:Dictionary = getFeatures(document);
      for(var f:String in features) {
        incrFeatureCount(f, category);
      }
      incrCategoryCount(category);
    }    
    protected function getCategoryCount(category:String):Number {
      if(categoryCount[category]) {
        return categoryCount[category];
      }
      return 0.0;
    }
    protected function getFeatureCount(feature:String, category:String):Number {
      if(!featureCount[feature][category]) {
        return 0.0;
      }
      return Number(featureCount[feature][category]);
    }
    protected function getTotalCount():uint {
      var cnt:uint = 0;
      for each(var i:uint in categoryCount) {
        cnt += i;
      }
      return cnt;
    }
    protected function getCategories():Array {
      var categories:Array = [];
      for(var c:String in categoryCount) {
        categories.push(c);
      }
      return categories;
    }
    // P(feature|category)
    protected function getFeatureProb(feature:String, category:String):Number {
      if(getCategoryCount(category) == 0) {
        return 0.0;
      }
      return getFeatureCount(feature, category)/getCategoryCount(category);
    }
    protected function getWeightedFeatureProb(feature:String, category:String,
                                              weight:Number = 1.0, aprob:Number = 0.5):Number {
      var basicProb:Number = getFeatureProb(feature, category);
      var totals:Number = 0.0;
      getCategories().forEach(function(c:String, index:int, arr:Array):void {
        totals += getFeatureCount(feature, c);
      });
      return ((weight*aprob) + (totals*basicProb))/(weight + totals);
    }
    private function incrFeatureCount(feature:String, category:String):void {
      if(!featureCount[feature]) {
        featureCount[feature] = new Dictionary();
      }
      if(!featureCount[feature][category]) {
        featureCount[feature][category] = 0;
      }
      featureCount[feature][category]++;
    }
    private function incrCategoryCount(category:String):void {
      if(!categoryCount[category]) {
        categoryCount[category] = 0;
      }
      categoryCount[category]++;
    }

  }
}
