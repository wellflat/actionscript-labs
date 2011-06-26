package {
  import flash.display.Bitmap;
  import flash.utils.ByteArray;
  
  /* Stereo Pair Bitmap */
  public class StereoPair {
    private var _left:Bitmap;
    private var _right:Bitmap;
    
    public function StereoPair(left:Bitmap, right:Bitmap) {
      validate(left, right);
      _left = left;
      _right = right;
    }
    internal function serialize():Vector.<ByteArray> {
      return new <ByteArray>[
        _left.bitmapData.getPixels(_left.getRect(_left)),
        _right.bitmapData.getPixels(_right.getRect(_right))
      ];
    }
    internal function serialize_v():Vector.<Vector.<uint>> {
      return new <Vector.<uint>>[
        _left.bitmapData.getVector(_left.getRect(_left)),
        _right.bitmapData.getVector(_right.getRect(_right))
      ];
    }
    internal function get width():int {
      return _left.width;
    }
    internal function get height():int {
      return _left.height;
    }
    internal function get widthStep():int {
      return _left.width<<2;
    }
    private function validate(l:Bitmap, r:Bitmap):void {
      var check:Boolean = (l.width == r.width && l.height == r.height);
      if(!check) throw new TypeError('Invalid images, required stereo pair');
    }
  }
}