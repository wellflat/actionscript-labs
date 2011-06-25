package {
  /*
   * Fast Fourier Transform implementation in pure AS3
   */
  public class FFT {
    private var n:int;
    private var bitrev:Vector.<int>;
    private var cstb:Vector.<Number>;
    public static const HPF:String = "high";
    public static const LPF:String = "low";
    public static const BPF:String = "band"

    public function FFT(n:int) {
      if(n != 0 && (n & (n-1)) == 0) {
        this.n = n;
        this.cstb = new Vector.<Number>(n + (n>>2), true);
        this.bitrev = new Vector.<int>(n, true);
        makeCstb();
        makeBitrev();
      }  
    }
    // 1D-FFT
    public function fft(re:Vector.<Number>, im:Vector.<Number>, inv:Boolean=false):void {
      if(!inv) {
        fftCore(re, im, 1);
      }else {
        fftCore(re, im, -1);
        for(var i:int=0; i<n; i++) { 
          re[i] /= n;
          im[i] /= n;
        }
      }
    }
    // 2D-FFT
    public function fft2d(re:Vector.<Number>, im:Vector.<Number>, inv:Boolean=false):void {
      var tre:Vector.<Number> = new Vector.<Number>(re.length, true);
      var tim:Vector.<Number> = new Vector.<Number>(im.length, true);
      var i:uint;
      if(inv) swapQuadrant(re, im);
      // x-axis
      for(var y:int=0; y<n; y++) {
        i = y*n;
        for(var x1:int=0; x1<n; x1++) {
          tre[x1] = re[x1 + i];
          tim[x1] = im[x1 + i];
        }
        if(!inv) fft(tre, tim);
        else fft(tre, tim, true);
        for(var x2:int=0; x2<n; x2++) {
          re[x2 + i] = tre[x2];
          im[x2 + i] = tim[x2];
        }
      }
      // y-axis
      for(var x:int=0; x<n; x++) {
        for(var y1:int=0; y1<n; y1++) {
          i = x + y1*n;
          tre[y1] = re[i];
          tim[y1] = im[i];
        }
        if(!inv) fft(tre, tim);
        else fft(tre, tim, true);
        for(var y2:int=0; y2<n; y2++) {
          i = x + y2*n;
          re[i] = tre[y2];
          im[i] = tim[y2];
        }
      }
      if(!inv) swapQuadrant(re, im);
    }
    // windowing function using hamming window.
    public function windowing(data:Vector.<Number>, inv:int):void {
      var len:int = data.length;
      var pi:Number = Math.PI;
      for(var i:int=0; i<len; i++) {
        if(inv == 1) data[i] *= 0.54 - 0.46*Math.cos(2*pi*i/(len - 1));
        else data[i] /= 0.54 - 0.46*Math.cos(2*pi*i/(len -1));
      }
    }
    // spatial frequency filtering.
    public function applyFilter(re:Vector.<Number>, im:Vector.<Number>, rad:uint, type:String, bandWidth:uint = 0):void {
      var r:int = 0; // radius
      var n2:int = n>>1;
      var i:int, ptr:int;
      for(var y:int=-n2; y<n2; y++) {
        i = n2 + (y + n2)*n;
        for(var x:int=-n2; x<n2; x++) {
          r = Math.sqrt(x*x + y*y);
          ptr = x + i;
          if((type == HPF && r < rad) || (type == LPF && r > rad) ||
             (type == BPF && (r < rad || r > (rad + bandWidth)))) {
              re[ptr] = im[ptr] = 0;
          }
        }
      }
    }
    // Fast Fourier Transform core operation.
    private function fftCore(re:Vector.<Number>, im:Vector.<Number>, sign:int):void {
      var h:int, d:int, wr:Number, wi:Number, ik:int, xr:Number, xi:Number, m:int, tmp:Number;
      // bit reversal
      for(var l:int=0; l<n; l++) {
        m = bitrev[l];
        if(l<m) {
          tmp = re[l]; re[l] = re[m]; re[m] = tmp;
          tmp = im[l]; im[l] = im[m]; im[m] = tmp;
        }
      }
      // butterfly operation
      for(var k:int=1; k<n; k<<=1) {
        h = 0;
        d = n/(k<<1);
        for(var j:int=0; j<k; j++) {
          wr = cstb[h + (n>>2)];
          wi = sign*cstb[h];
          for(var i:int=j; i<n; i+=(k<<1)) {
            ik = i+k;
            xr = wr*re[ik] + wi*im[ik]
            xi = wr*im[ik] - wi*re[ik];
            re[ik] = re[i] - xr;
            re[i] += xr;
            im[ik] = im[i] - xi;
            im[i] += xi;
          }
          h += d;
        }
      }
    }
    // swap quadrant.
    private function swapQuadrant(re:Vector.<Number>, im:Vector.<Number>):void {
      var tmp:Number, xn:int, yn:int, i:int, j:int, k:int, l:int;
      var len:int = n>>1;
      for(var y:int=0; y<len; y++) {
        yn = y + len;
        for(var x:int=0; x<len; x++) {
          xn = x + len;
          i = x + y*n; j = xn + yn*n;
          k = x + yn*n; l = xn + y*n;
          tmp = re[i]; re[i] = re[j]; re[j] = tmp;
          tmp = re[k]; re[k] = re[l]; re[l] = tmp;
          tmp = im[i]; im[i] = im[j]; im[j] = tmp;
          tmp = im[k]; im[k] = im[l]; im[l] = tmp;
        }
      }
    }
    // make table of trigonometric function.
    private function makeCstb():void {
      var n2:int = n>>1, n4:int = n>>2, n8:int = n>>3;
      var t:Number = Math.sin(Math.PI/n);
      var dc:Number = 2*t*t;
      var ds:Number = Math.sqrt(dc*(2 - dc));
      var c:Number = cstb[n4] = 1;
      var s:Number = cstb[0] = 0;
      t = 2*dc;
      for(var i:int=1; i<n8; i++) {
        c -= dc;
        dc += t*c;
        s += ds;
        ds -= t*s;
        cstb[i] = s;
        cstb[n4 - i] = c;
      }
      if(n8 != 0) cstb[n8] = Math.sqrt(0.5);
      for(var j:int=0; j<n4; j++) cstb[n2 - j] = cstb[j];
      for(var k:int=0; k<(n2 + n4); k++) cstb[k + n2] = -cstb[k];
    }
    // make table of bit reversal.
    private function makeBitrev():void {
      var i:int = 0, j:int = 0, k:int = 0;
      bitrev[0] = 0;
      while(++i<n) {
        k = n >> 1;
        while(k<=j) {
          j -= k;
          k >>= 1;
        }
        j += k;
        bitrev[i] = j;
      }
    }
  }
}