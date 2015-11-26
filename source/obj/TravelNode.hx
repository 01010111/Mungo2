package obj;
import flixel.FlxObject;
import flixel.math.FlxPoint;

/**
 * ...
 * @author x01010111
 */
class TravelNode extends FlxObject
{
	public var dest_map:String;
	public var dest_node:Int;
	public var node:Int;
	
	public function new(_p:FlxPoint, _dest_map:String, _dest_node:Int, _node:Int) 
	{
		super(_p.x, _p.y, 16, 16);
		dest_map = _dest_map;
		dest_node = _dest_node;
		node = _node;
	}
	
}

class DoorNode extends TravelNode
{
	public function new(_p:FlxPoint, _dest_map:String, _dest_node:Int, _node:Int)
	{
		super(_p, _dest_map, _dest_node, _node);
	}
}