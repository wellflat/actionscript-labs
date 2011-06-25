package {

  public class ParticleFilter {
    private var dim:int;
    private var num:int;
    private var w:int;
    private var h:int;
    private var upper:Vector.<int>;
    private var lower:Vector.<int>;
    private var noise:Vector.<int>;
    public var samples:Vector.<Particle>;
    
    public function ParticleFilter(num:int, w:int, h:int,
                                   upper:Vector.<int>,
                                   lower:Vector.<int>,
                                   noise:Vector.<int>) {
      this.dim = 4;                             
      this.num = num;
      this.w = w;
      this.h = h;
      this.upper = upper;
      this.lower = lower;
      this.noise = noise;
      this.samples = new Vector.<Particle>(num, true);
      // initializes the sample set.
      for(var i:int=0; i<num; i++) {
        var p:Particle = new Particle();
        for(var j:int=0; j<dim; j++) {
          var r:int = int(Math.random()*32767);
          p.x[j] = r%(upper[j] - lower[j]) + lower[j];
        }
        p.w = 1.0/num;
        samples[i] = p;
      }
    }
    /* returns the weighted mean as estimated result. */
    public function measure():Particle {
      var result:Particle = new Particle();
      var x:Vector.<Number> = new Vector.<Number>(dim, true);
      for(var i:int=0; i<num; i++) {
        x[0] += samples[i].x[0]*samples[i].w;
        x[1] += samples[i].x[1]*samples[i].w;
        x[2] += samples[i].x[2]*samples[i].w;
        x[3] += samples[i].x[3]*samples[i].w;        
      }
      for(var k:int=0; k<dim; k++) {
        result.x[k] = int(x[k]);
      }
      return result;
    }
    /**
     * estimates the subsequent model state,
     * based on linear uniform motion.
     */
    public function predict():void {
      for(var i:int=0; i<num; i++) {
        // update random noise
        var n:Vector.<int> = new Vector.<int>(dim, true);
        var max:Number = 32367;
        n[0] = int(Math.random()*max%(noise[0]*2) - noise[0]);
        n[1] = int(Math.random()*max%(noise[1]*2) - noise[1]);
        n[2] = int(Math.random()*max%(noise[2]*2) - noise[2]);
        n[3] = int(Math.random()*max%(noise[3]*2) - noise[3]);
        // update state
        var v:Vector.<int> = samples[i].x;
        v[0] += v[2] + n[0];
        v[1] += v[3] + n[1];
        v[2] = n[2];
        v[3] = n[3];
        if(v[0] < lower[0]) v[0] = lower[0];
        if(v[1] < lower[1]) v[1] = lower[1];
        if(v[2] < lower[2]) v[2] = lower[2];
        if(v[3] < lower[3]) v[3] = lower[3];
        if(v[0] >= upper[0]) v[0] = upper[0];
        if(v[1] >= upper[1]) v[1] = upper[1];
        if(v[2] >= upper[2]) v[2] = upper[2];
        if(v[3] >= upper[3]) v[3] = upper[3];
      }
    }
    /* resampling based on sample's weight. */
    public function resample():void {
      // accumulate weight
      var w:Vector.<Number> = new Vector.<Number>(num, true);
      w[0] = samples[0].w;
      for(var i:int=1; i<num; i++) {
        w[i] = w[i - 1] + samples[i].w;
      }
      var pre:Vector.<Particle> = Vector.<Particle>(samples);
      for(var j:int=0; j<num; j++) {
        var darts:Number = (Math.random()*32767%10000)/10000.0;
        for(var k:int=0; k<num; k++) {
          if(darts>w[k]) {
            continue;
          }else {
            // resampling
            samples[j].x[0] = pre[k].x[0];
            samples[j].x[1] = pre[k].x[1];
            samples[j].x[2] = pre[k].x[2];
            samples[j].x[3] = pre[k].x[3];
            samples[j].w = 0.0;
            break;
          }
        }
      }
    }
    /* calculates the likelifood for each sample. */
    public function weight(img:Vector.<uint>):void {
      var sum:Number = 0.0;
      for(var i:int=0; i<num; i++) {
        var x:int = samples[i].x[0];
        var y:int = samples[i].x[1];
        var pos:int = y*w + x;
        if(pos < w*h) {
          samples[i].w = likelifood(img[pos]);
        }else {
          samples[i].w = 0.0001;
        }
        sum += samples[i].w;
      }
      // normalize
      for(var j:int=0; j<num; j++) {
        samples[j].w /= sum;
      }
    }
    private function likelifood(value:uint):Number {
      var sigma:Number = 50.0;
      var r:uint = value >> 16 & 0xff;
      var g:uint = value >> 8 & 0xff;
      var b:uint = value & 0xff;
      var dist:Number = Math.sqrt((255 - r)*(255 - r) + g*g + b*b);
      return 1.0/(Math.sqrt(2.0*Math.PI)*sigma)*Math.exp(-dist*dist/(2.0*sigma*sigma));
    }
  }
}