package obj;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxPath;
import obj.FX.FootStep;
import states.PlayState;
import util.MSprite;
import zerolib.util.ZMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author x01010111
 */
class Platform extends MSprite
{

	public function new(_p:FlxPoint, _w:FlxPoint) 
	{
		super(_p.x, _p.y);
		loadGraphic("assets/images/platform.png", true, 64, 32);
		animation.add("play_fwd", [0, 1, 2, 3], 10);
		animation.add("play_rev", [3, 2, 1, 0], 10);
		allowCollisions = 0x0100;
		immovable = true;
		new FlxTimer().start(2).onComplete = function(t:FlxTimer):Void
		{
			move(FlxPoint.get(_p.x + width * 0.5, _p.y + height * 0.5), FlxPoint.get(_w.x + width * 0.5, _w.y + height * 0.5));
		}
		animation.callback = callback;
	}
	
	function callback(_s:String, _f:Int, _i:Int):Void
	{
		if (_f == 3)
		{
			PlayState.i.fx_bg.add(new FootStep(FlxPoint.get(ZMath.randomRange(x, x + width), y + 25), FlxPoint.get(0, ZMath.randomRange(4, 8))));
		}
	}
	
	function move(_p1:FlxPoint, _p2:FlxPoint):Void
	{
		animation.play("play_fwd");
		new FlxPath().start(this, [_p1, _p2], 40).onComplete = function(p:FlxPath):Void
		{
			stop();
			new FlxTimer().start(2).onComplete = function(t:FlxTimer):Void
			{
				animation.play("play_rev");
				new FlxPath().start(this, [_p2, _p1], 40).onComplete = function(p:FlxPath):Void
				{
					stop();
					new FlxTimer().start(2).onComplete = function(t:FlxTimer):Void { move(_p1, _p2); }
				}
			}
		}
	}
	
	function stop():Void
	{
		velocity.set();
		var puff_amt = 4;
		var wander_amt = 6;
		for (i in 0...puff_amt)
		{
			PlayState.i.fx_fg.add(new FootStep(FlxPoint.get(x + i * (width / (puff_amt - 1)) + ZMath.randomRange(-wander_amt, wander_amt), y), FlxPoint.get(0, ZMath.randomRange(0, 5))));
		}
		animation.pause();
	}
	
}