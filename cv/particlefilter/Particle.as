package {
  public class Particle {
    public var x:Vector.<int>; // vector of state (x, y, u, v)
    public var w:Number; // weight
    
    public function Particle() {
      x = new Vector.<int>(4, true);
      w = 0.0;
    }
  }
}