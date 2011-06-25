package {
  public class HTTPResponse {
    public static const HTTP_OK:String = '200';
    public static const HTTP_BAD_REQUEST:String = '400';
    public static const HTTP_NOT_FOUND:String = '404';
    public static const HTTP_SERVER_ERROR:String = '500';
    private var _code:uint;
    private var _body:String;
    private var _length:uint;
    
    public function HTTPResponse() {
      _code = 0;
      _body = '';
      _length = 0;
    }
    public function get code():uint {
      return _code;
    }
    public function set code(value:uint):void {
      _code = value;
    }
    public function get body():String {
      return _body;
    }
    public function set body(value:String):void {
      _body = value;
    }
    public function get length():uint {
      return _length;
    }
    public function set length(value:uint):void {
      _length = value;
    }
  }
}