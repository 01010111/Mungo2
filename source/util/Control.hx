package util;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

/**
 * ...
 * @author x01010111
 */
class Control extends FlxObject
{

	public function new() 
	{
		super();
		ANALOG = FlxPoint.get();
	}
	
	public var A_PRESSED : Bool;
	public var B_PRESSED : Bool;
	public var X_PRESSED : Bool;
	public var Y_PRESSED : Bool;
	public var LB_PRESSED : Bool;
	public var RB_PRESSED : Bool;
	public var LT_PRESSED : Bool;
	public var RT_PRESSED : Bool;
	public var START_PRESSED : Bool;
	public var SELECT_PRESSED:Bool;
	
	public var A_JUST_PRESSED : Bool;
	public var B_JUST_PRESSED : Bool;
	public var X_JUST_PRESSED : Bool;
	public var Y_JUST_PRESSED : Bool;
	public var LB_JUST_PRESSED : Bool;
	public var RB_JUST_PRESSED : Bool;
	public var LT_JUST_PRESSED : Bool;
	public var RT_JUST_PRESSED : Bool;
	public var START_JUST_PRESSED : Bool;
	public var SELECT_JUST_PRESSED : Bool;
	
	public var ANALOG : FlxPoint;
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		A_PRESSED		= FlxG.keys.pressed.X;
		B_PRESSED		= FlxG.keys.pressed.C;
		X_PRESSED		= FlxG.keys.pressed.V;
		Y_PRESSED		= FlxG.keys.pressed.B;
		LB_PRESSED		= FlxG.keys.pressed.SHIFT;
		RB_PRESSED		= FlxG.keys.pressed.Z;
		START_PRESSED	= FlxG.keys.pressed.ENTER;
		
		A_JUST_PRESSED		= FlxG.keys.justPressed.X;
		B_JUST_PRESSED		= FlxG.keys.justPressed.C;
		X_JUST_PRESSED		= FlxG.keys.justPressed.V;
		Y_JUST_PRESSED		= FlxG.keys.justPressed.B;
		LB_JUST_PRESSED		= FlxG.keys.justPressed.SHIFT;
		RB_JUST_PRESSED		= FlxG.keys.justPressed.Z;
		START_JUST_PRESSED	= FlxG.keys.justPressed.ENTER;
		
		var _x = 0.0; var _y = 0.0;
		if (FlxG.keys.anyPressed([FlxKey.UP, FlxKey.W])) _y--;
		if (FlxG.keys.anyPressed([FlxKey.DOWN, FlxKey.S])) _y++;
		if (FlxG.keys.anyPressed([FlxKey.LEFT, FlxKey.A])) _x--;
		if (FlxG.keys.anyPressed([FlxKey.RIGHT, FlxKey.D])) _x++;
		ANALOG = FlxPoint.get(_x, _y);
	}
	
}