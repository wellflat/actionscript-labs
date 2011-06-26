package {
  import flash.geom.Rectangle;

  internal interface IState {
    function get maxIters():int;
    function get minDisparity():int;
    function get numberOfDisparities():int;
    function get occlusionCost():int;
    function get textureThreshold():int;
    function get windowSize():int;
    function get roi():Rectangle;
    function set numberOfDisparities(nDisparity:int):void;
    function set windowSize(wSize:int):void;
  }
}