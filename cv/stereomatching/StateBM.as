package {
  import flash.geom.Rectangle;
  
  /* The structure for block matching stereo correspondence algorithm */
  internal class StateBM implements IState {
    public static const BASIC:int = 1;
    public static const FISH_EYE:int = 2; // not used currentry
    public static const NARROW:int = 3;   // not used currentry
    
    private var _minDisparity:int;
    private var _numberOfDisparities:int;
    private var _SADWindowSize:int;
    private var _textureThreshold:int;
    private var _roi:Rectangle; // not used currentry
    
    public function StateBM(imageWidth:int, preset:int = BASIC) {
      setParameters(imageWidth, preset);
    }
    // getter
    public function get maxIters():int {
      return 0; // not used
    }
    public function get minDisparity():int {
      return _minDisparity;
    }
    public function get numberOfDisparities():int {
      return _numberOfDisparities;
    }
    public function get occlusionCost():int {
      return 0; // not used
    }
    public function get textureThreshold():int {
      return _textureThreshold;
    }
    public function get windowSize():int {
      return _SADWindowSize;
    }
    public function get roi():Rectangle {
      return _roi;
    }
    // setter.
    public function set windowSize(wSize:int):void {
      _SADWindowSize = wSize;
    }
    public function set numberOfDisparities(nDisparity:int):void {
      _numberOfDisparities = nDisparity;
    }
    private function setParameters(imageWidth:int, type:int):void {
      switch(type) {
        case BASIC:
        case FISH_EYE:
        case NARROW:
          _minDisparity = 0;
          _numberOfDisparities = imageWidth/8;
          _SADWindowSize = 7;
          _textureThreshold = 1500;
          _roi = new Rectangle();
        break;
        default:
        break;
      }
    }
  }
}