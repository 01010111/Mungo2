package obj;
import flixel.util.FlxTimer;
import obj.FX.TinyHeart;
import util.MSprite;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import obj.FX.TinyStar;
import states.PlayState;
import util.MSprite;
import zerolib.util.ZMath;
import flixel.math.FlxMath;

/**
 * ...
 * @author x01010111
 */
class Enemy extends MSprite
{
	public var is_vulnerable:Bool = true;
	public var is_friendly:Bool = false;
	
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
	}
	
	function make_invulnerable_for_time(_time:Float):Void
	{
		is_vulnerable = false;
		new FlxTimer().start(_time).onComplete = function(t:FlxTimer):Void
		{
			is_vulnerable = true;
		}
	}
	
}

/**
 * Crab!
 */
class Crab extends Enemy
{
	public var hurty:Bool = false;
	
	public function new(_p:FlxPoint) 
	{
		super(_p.x, _p.y);
		loadGraphic("assets/images/crab.png", true, 32, 32);
		animation.add("play", [0, 1, 2, 2, 3, 4, 5, 5], 16);
		animation.add("hurt", [6, 7], 8);
		make_anchored_hitbox(16, 16);
		immovable = true;
		animation.callback = callback;
	}
	
	function callback(_s:String, _f:Int, _i:Int):Void
	{
		if (_f == 2)
		{
			is_friendly ? PlayState.i.fx_fg.add(new TinyHeart(FlxPoint.get(getMidpoint().x + 8, getMidpoint().y - 16), false)) : PlayState.i.fx_fg.add(new TinyStar(FlxPoint.get(getMidpoint().x + 8, getMidpoint().y - 16), 0));
		}
		else if (_f == 6)
		{
			is_friendly ? PlayState.i.fx_fg.add(new TinyHeart(FlxPoint.get(getMidpoint().x - 8, getMidpoint().y - 16), true)) : PlayState.i.fx_fg.add(new TinyStar(FlxPoint.get(getMidpoint().x - 8, getMidpoint().y - 16), 3));
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (!PlayState.i.map.overlapsPoint(get_anchor())) y++;
		else {
			velocity.y = 0;
			
			if (facing == FlxObject.LEFT && !PlayState.i.map.overlapsPoint(FlxPoint.get(x - 2, y + 18)) || PlayState.i.map.overlapsPoint(FlxPoint.get(x - 2, y + 8))) facing = FlxObject.RIGHT;
			else if (facing == FlxObject.RIGHT && !PlayState.i.map.overlapsPoint(FlxPoint.get(x + 18, y + 18)) || PlayState.i.map.overlapsPoint(FlxPoint.get(x + 18, y + 8))) facing = FlxObject.LEFT;
			
			if (hurty) {
				velocity.x = 0;
				animation.play("hurt");
			} else {
				velocity.x = facing == FlxObject.LEFT ? -30 : 30;
				animation.play("play");
			}
		}
		FlxG.collide(this, PlayState.i.mungo);
		super.update(elapsed);
	}
	
	override public function hurt(Damage:Float):Void 
	{
		make_hurty(4);
		make_invulnerable_for_time(4);
	}
	
	function make_hurty(_time:Float):Void
	{
		hurty = true;
		new FlxTimer().start(_time).onComplete = function(t:FlxTimer):Void { hurty = false; }
		new FlxTimer().start(_time - _time / 4).onComplete = function(t:FlxTimer):Void { FlxSpriteUtil.flicker(this, _time / 4, 0.075); }
	}
	
}

/**
 * Spike!
 */
class Spike extends Enemy
{

	public function new(_p:FlxPoint) 
	{
		super(_p.x, _p.y + 5);
		loadGraphic("assets/images/spike.png", true, 16, 16);
		make_anchored_hitbox(16, 11);
		animation.add("play_even", [0, 0, 1, 2, 2, 1], 10);
		animation.add("play_odd", [2, 2, 1, 0, 0, 1], 10);
		FlxMath.isEven(Math.floor(x / 16)) ? animation.play("play_even") : animation.play("play_odd");
		allowCollisions = 0x0100;
		immovable = true;
		is_vulnerable = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		FlxG.collide(this, PlayState.i.mungo);
		super.update(elapsed);
	}
	
}