package {
  import flash.display.Sprite;
  import flash.text.TextField;
  
  public class Test extends Sprite {    
    public function Test() {
      var tf:TextField = new TextField();
      addChild(tf);
      var curriedSum:Function = FunctionUtils.curry(sum);
      
      var result1:int = curriedSum(1)(2,3)(4,5,6)(7,8,9,10);
      
      var result2:int = curriedSum(1)()()()()()()()()()
                                  ()(2)()()()()()()()()
                                  ()()(3)()()()()()()()
                                  ()()()(4)()()()()()()
                                  ()()()()(5)()()()()()
                                  ()()()()()(6)()()()()
                                  ()()()()()()(7)()()()
                                  ()()()()()()()(8)()()
                                  ()()()()()()()()(9)()
                                  ()()()()()()()()()(10);
                   
      tf.text = result1.toString() + ", " + result2.toString();
    }
    
    public function sum(a:int, b:int, c:int, d:int, e:int,
                        f:int, g:int, h:int, i:int, j:int):int {
      return a + b + c + d + e + f + g + h + i + j;
    } 
  }
}