package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.ByteArray;
  
  public class StereoMatcher extends EventDispatcher {
    public static const BM:int = 0;
    public static const SGBM:int = 1; // not used currentry
    public static const GC:int = 2;   // not used currentry
    public static const MATCH_COMPLETE:String = 'match_complete';
    private const STATES:Array = [StateBM];
    private var _pair:StereoPair;
    private var _disparity:ByteArray;
    private var dataPair:Vector.<ByteArray>;
    
    public function StereoMatcher(pair:StereoPair) {
      this._pair = pair;
      this._disparity = new ByteArray();
      this.dataPair = _pair.serialize();
    }
    public function get pair():StereoPair {
      return _pair;
    }
    public function get disparity():ByteArray {
      return _disparity;
    }
    public function find(type:int = BM, wSize:int = 5, nDisparity:int = 20):void {
      var state:IState = new STATES[type](_pair.width);
      state.windowSize = wSize;
      state.numberOfDisparities = nDisparity;
      _disparity = new ByteArray();
      computeDisparity(state);
      dispatchEvent(new Event(MATCH_COMPLETE));
    }
    /**
     * triangurate
     */
    public function triangulate():void {
      var tri:Triangulation = new Triangulation(_pair, 1, 55);
      tri.computeDistance(_disparity);
    }
    /**
     * computes the disparity for the rectified stereo pair,
     * without using dynamic programming.
     */
    private function computeDisparity(state:IState):void {
      try {
        var w:int = _pair.width;
        var h:int = _pair.height;
        var step:int = _pair.widthStep;
        var winSize:int = state.windowSize;
        var threshold:int = state.textureThreshold;
        var minDisparity:int = state.minDisparity;
        var maxDisparity:int = state.numberOfDisparities - minDisparity;
        var maxDiff:int = 255*winSize*winSize;
        var localMin:int = maxDiff;
        var sad:int = 0, diff:int;
        var cur:int, ptr:int;
        var y:int, x:int, i:int, j:int, d:int, ly:int, lx:int;
        for(y=0, cur=step; y<h-1; y++, cur+=step) {
          for(x=0, i=cur+1; x<w; x++, i+=4) {
            for(d=minDisparity, ptr=i; d<maxDisparity; d++, ptr-=4) {
              if(ptr < cur) continue;
              for(ly=0; ly<winSize; ly++) {
                if(sad > threshold || y + ly > h) break;
                for(lx=0, j=ly*step; lx<winSize; lx++, j+=4) {
                  if(x + lx > w) break;
                  diff = dataPair[0][i + j] - dataPair[1][ptr + j];
                  sad += (diff ^ (diff>>31)) - (diff>>31);
                }
              }
              if(localMin > sad) {
                localMin = sad;
                _disparity[i - 1] = 0xff;
                _disparity[i] = _disparity[i + 1] = _disparity[i + 2] = d<<4;
              }
              sad = 0;
            }
            localMin = maxDiff;
          }
        }
      }catch(e:Error) {
        throw e;
      }
    }
  }
}