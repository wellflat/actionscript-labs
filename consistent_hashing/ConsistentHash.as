package {
  import com.adobe.crypto.MD5;
  import flash.utils.Dictionary;

  public class ConsistentHash {
    private var ring:Dictionary;
    private var nodes:Vector.<String>;
    private var keys:Vector.<String>;
    private var replicas:uint; // indicates how many virtual points should be used per node
    
    public function ConsistentHash(nodes:Vector.<String>, replicas:uint = 160) {
      this.ring = new Dictionary();
      this.nodes = new Vector.<String>();
      this.keys = new Vector.<String>();
      this.replicas = replicas;
      for each(var node:String in nodes) {
        add(node);
      }
    }
    public function toString():String {
      return '[' + nodes.join(', ') + ']';
    }
    // Gets the node in the Hash Ring for this key.
    public function get(key:String):String {
      if(nodes.length == 0) return null;
      var i:uint = search(keys, MD5.hash(key));
      return ring[keys[i]];
    }
    // Adds the node to the Hash Ring (including a number of replicas).
    public function add(node:String):void {
      nodes.push(node);
      for(var i:int = 0; i < replicas; i++) {
        var key:String = MD5.hash(node + ':' + i);
        ring[key] = node;
        keys.push(key);
      }
      keys.sort(compare);
    }
    // Removes the node from the Hash Ring.
    public function remove(node:String):void {
      nodes = nodes.filter(
        function(item:String, i:uint, v:Vector.<String>):Boolean {
          return item != node;
        }
      );
      for(var i:int = 0; i < replicas; i++) {
        var key:String = MD5.hash(node + ':' + i);
        delete ring[key];
        keys = keys.filter(
          function(item:String, i:uint, v:Vector.<String>):Boolean {
            return item != key;  
          }
        );
        keys.sort(compare);
      }
    }
    // Finds the closest index in the Hash Ring with value <= the given value
    // using Binary Search algorithm O(logn) .
    private function search(nodes:Vector.<String>, value:String):uint {
      var head:int = 0, tail:int = nodes.length - 1;
      while(head <= tail) {
        var i:int = int((head + tail)/2);
        var c:int = compare(nodes[i], value);
        if(c == 0)     return i;
        else if(c > 0) tail = i - 1;
        else           head = i + 1;
      }
      if(tail < 0) tail = nodes.length - 1;
      return tail;
    }
    private function compare(a:String, b:String):int {
      return a > b ? 1 : a < b ? -1 : 0;
    }
  }
}