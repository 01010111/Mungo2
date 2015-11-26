package util;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import obj.*;
import util.*;
import states.*;

/**
 * ...
 * @author x01010111
 */
class MSprite extends FlxSprite
{

	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
	}
	
	function make_and_center_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height * 0.5 - _height * 0.5);
		setSize(_width, _height);
	}
	
	function make_anchored_hitbox(_width:Float, _height:Float):Void
	{
		offset.set(width * 0.5 - _width * 0.5, height - _height);
		setSize(_width, _height);
	}
	
	function get_anchor():FlxPoint
	{
		return FlxPoint.get(x + width * 0.5, y + height);
	}
	
	public var pause_timer:Int = 0;
	
	override public function update(elapsed:Float):Void 
	{
		if (pause_timer == 0)
		{
			super.update(elapsed);
		}
		else pause_timer--;
	}
	
}