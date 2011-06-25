package {
  public class FunctionUtils {
    // currying is the technique of transforming a function
    // that takes multiple arguments (or an n-tuple of arguments) in such a way
    // that it can be called as a chain of functions each with a single argument
    public function FunctionUtils()  {
    }
    // bind (== partial apply)
    public static function bind(f:Function, ...args):Function {
      return function(...rest):* {
        return f.apply(null, args.concat(rest));
      };
    }
    // currying
    public static function curry(f:Function, ...rest):Function {
      function currying(args:Array):* {
        if(args.length >= f.length) {
          return f.apply(null, args);
        }
        return function(...more):* {
          return currying(args.concat(more));
        };
      }
      return currying(rest);
    }
  }
}