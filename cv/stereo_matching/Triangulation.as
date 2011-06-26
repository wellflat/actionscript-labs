package {
  import flash.utils.ByteArray;

  internal class Triangulation {
    public static const COMPLETE:String = 'complete';
    private var pair:StereoPair;
    private var baseLine:int = 0.0;
    private var focalLength:Number = 0.0;
    private var distanceMap:ByteArray;
    
    public function Triangulation(stereoPair:StereoPair,
                                  baseLine:uint, fieldOfView:uint) {
      this.pair = stereoPair;
      this.baseLine = baseLine;
      this.focalLength = pair.width*0.5*(1/Math.tan(fieldOfView*0.5*Math.PI/180));
    }
    internal function computeDistance(disparity:ByteArray):ByteArray {
      var w:int = pair.width;
      var h:int = pair.height;
      var step:int = pair.widthStep;
      var pos:int = 0;
      var i:int = 0;
      distanceMap = new Vector.<Number>(disparity.length, true);
      for(var y:int=0; y<h; y++) {
        pos = y*step;
        for(var x:int=0; x<w; x++) {
          i = pos + (x<<2) + 1;
          distanceMap[i] = focalLength*baseLine/disparity[i];
        }
      }
      return distanceMap;
    }
  }
}