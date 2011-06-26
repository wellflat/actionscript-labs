package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.getTimer;
  
  public class SuffixArray extends EventDispatcher {  
    public static const BUILD_COMPLETE:String = "build_complete";
    private var suffixes:Vector.<String>;
    private var len:int;
    private var _time:Number;
  
    public override function toString():String {
      return suffixes.join("\n");
    }
    /**
     * search substring, using binary search O(mlogn)
     */
    public function search(substring:String):int {
      if(len == 0) return substring.length == 0 ? 0 : -1;
      var low:int = 0, high:int = suffixes.length - 1;
      while(low < high) {
        var middle:int = low + (high - low)/2;
        if(suffixes[middle] >= substring) high = middle;
        else low = middle + 1;
      }
      if(suffixes[high].indexOf(substring, 0) == 0) {
        return len - suffixes[high].length;
      }
      return -1;
    }
    /**
     * build Suffix Array, O(n^2logn)
     */
    public function build(str:String):void {
      _time = getTimer();
      len = str.length;
      suffixes = new Vector.<String>(len, true);
      for(var i:int = 0; i < len; i++) {
        suffixes[i] = str.substring(i);
      }
      suffixes.sort(
        function(x:String, y:String):int {
          return x > y ? 1 : x < y ? -1 : 0;
        }
      );
      _time = getTimer() - _time;
      dispatchEvent(new Event(BUILD_COMPLETE));
    }
    public function get time():Number {
      return _time;
    }
  }
}