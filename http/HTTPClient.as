package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.HTTPStatusEvent;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestHeader;
  
  public class HTTPClient extends EventDispatcher {
    private var request:URLRequest;
    private var loader:URLLoader;
    private var root:String;
    private var _response:HTTPResponse;
    
    public function HTTPClient(host:String) {
      root = 'http://' + host;
      request = new URLRequest();
      loader = new URLLoader();
      _response = new HTTPResponse();
      bulkAddListener(loader);
    }
    public function get response():HTTPResponse {
      return _response;
    }
    public function perform(path:String = '', method:String = 'GET', param:Object = null):void {
      request.url = root + path;
      if(method == 'PUT' || method == 'DELETE') {
        addHeader('X-HTTP-Method-Override', method);
        request.method = 'POST';
      }else if(method == 'GET' || method == 'POST') {
        request.method = method;
      }
      request.data = param;
      loader.load(request);
    }
    public function addHeader(name:String, value:String):void {
      request.requestHeaders.push(new URLRequestHeader(name, value));
    }
    /** private method as below **/
    private function bulkAddListener(dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(Event.COMPLETE, completeHandler);
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
      dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
      dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }
    private function completeHandler(e:Event):void {
      _response.body = e.target.data;
      dispatchEvent(new Event(HTTPResponse.HTTP_OK));
    }
    private function progressHandler(e:ProgressEvent):void {
      _response.length = e.bytesLoaded;
    }
    private function httpStatusHandler(e:HTTPStatusEvent):void {
      _response.code = e.status;
    }    
    private function securityErrorHandler(e:SecurityErrorEvent):void {
      throw e;
    }
    private function ioErrorHandler(e:IOErrorEvent):void {
      var type:String = _response.code.toString();
      dispatchEvent(new Event(type));
    }
  }
}