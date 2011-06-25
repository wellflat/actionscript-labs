package {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.media.Video;
  
  // VTR Filter: scanning lines, ghost and gamma correction.
  public class VTR extends Video {
    private var _contrast:int;
    private var _thick:int;
    private var _ghost:int;
    private var gtbl:Vector.<uint>;
    private var frame:BitmapData;
    
    public function VTR(screen:Bitmap) {
      super(screen.width, screen.height);
      frame = screen.bitmapData;
      gtbl = new Vector.<uint>(256, true);
    }
    public function get _frame():BitmapData {
      return this.frame;
    }
    public function setCondition(contrast:int, ghost:int, thick:int,
                              gamma:Number):void {
      _contrast = contrast;
      _ghost = ghost;
      _thick = thick; // require 2^x
      for(var i:int=0; i<256; i++) {
        gtbl[i] = Math.pow(i/255.0, gamma)*255.0;
      }
    }
    public function start():void {
      addEventListener(Event.ENTER_FRAME, apply, false, 0, true);
    }
    /** main algorithm **/
    private function apply(e:Event):void {
      frame.draw(super);
      frame.lock();
      var data:Vector.<uint> = frame.getVector(frame.rect);
      var w:int = frame.width, h:int = frame.height;
      var r:uint = 0, g:uint = 0, b:uint = 0;
      var i:int = 0, j:int = 0, step:int = w;
      var f:int = 1;
      var len:int = data.length;
      for(var y:int = 0; y < h; y++, step += w) {
        f = (y & _thick - 1) << 1 < _thick ? 1 : 0;
        if(step + _ghost >= len) break;
        for(j = i + _ghost; i < step; i++, j++) {
          r = ((data[i] >> 16) & 0xff) + ((data[j] >> 16) & 0xff) >> 1;
          g = ((data[i] >> 8) & 0xff) + ((data[j] >> 16) & 0xff) >> 1;
          b = (data[i] & 0xff) + (data[j] & 0xff) >> 1;
          if(f && (r = g = b += _contrast) > 0xff) {
            r = g = b = 0xff;
          }
          data[i] = gtbl[r] << 16 | gtbl[g] << 8 | gtbl[b];
        }
      }
      frame.setVector(frame.rect, data);
      frame.unlock();
    }
  }
}