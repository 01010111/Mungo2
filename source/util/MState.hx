package util;
import flixel.FlxG;
import flixel.FlxState;
import obj.*;
import util.*;
import states.*;

/**
 * ...
 * @author x01010111
 */
class MState extends FlxState
{

	public function new() 
	{
		FlxG.mouse.visible = false;
		super();
	}
	
	override public function create():Void 
	{
		FlxG.camera.bgColor = 0xff090c0a;
		super.create();
	}
	
}