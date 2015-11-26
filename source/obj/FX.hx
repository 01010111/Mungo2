package obj;
import flixel.math.FlxPoint;
import states.PlayState;
import util.MSprite;
import zerolib.util.ZMath;

/**
 * ...
 * @author x01010111
 */
class FX
{

	public function new() 
	{
		
	}
	
}

class WrenchGet extends MSprite
{
	
	/**
	 * Cool BOOM and ~STARS~
	 * @param	P	Origin
	 */
	public function new(P:FlxPoint)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_wrench_get.png", true, 32, 32);
		animation.add("play", [0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 8, 9, 9, 9, 10, 10, 10, 10, 11], 30, false);
		animation.play("play");
		make_and_center_hitbox(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
	
}

class TinyStar extends MSprite
{
	
	/**
	 * A cute tiny star
	 * @param	P	Origin
	 * @param	A	A * 90 = angle, shoots up and to the right with 0
	 */
	public function new(P:FlxPoint, A:Float)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_tiny_star.png", true, 32, 32);
		animation.add("play", [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 9], 30, false);
		animation.play("play");
		make_and_center_hitbox(0, 0);
		angle = A * 90;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
	
}

class TinyHeart extends MSprite
{
	
	/**
	 * A cute tiny heart
	 * @param	P	Origin
	 * @param	Dir_Left	Left?
	 */
	public function new(P:FlxPoint, Dir_Left:Bool)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_tiny_heart.png", true, 32, 32);
		animation.add("play_r", [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 9], 30, false);
		animation.add("play_l", [10, 11, 12, 13, 14, 15, 15, 16, 16, 17, 17, 17, 18, 18, 18, 18, 19], 30, false);
		Dir_Left ? animation.play("play_l") : animation.play("play_r");
		make_and_center_hitbox(0, 0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
	
}

class FootStep extends MSprite
{
	
	/**
	 * A little POOF
	 * @param	P 	Origin
	 * @param	V	Velocity
	 */
	public function new(P:FlxPoint, ?V:FlxPoint)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_foot_step.png", true, 8, 8);
		animation.add("play", [0, 1, 2, 3, 3, 4, 4, 4, 5], 15, false);
		animation.play("play");
		make_and_center_hitbox(0, 0);
		V != null ? velocity.set(V.x, V.y) : velocity.set(ZMath.randomRange( -10, 10), ZMath.randomRange( -5, -15));
		angle = 90 * ZMath.randomRangeInt(0, 3);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
}

class LandPuff extends MSprite
{
	
	/**
	 * A big Poof for landing
	 * @param	P	Origin
	 */
	public function new(P:FlxPoint)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_land_puff.png", true, 32, 24);
		animation.add("play", [0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7], 20, false);
		animation.play("play");
		make_anchored_hitbox(0, 0);
		scale.x = Math.random() > 0.5 ? 1 : -1;
		PlayState.i.fx_bg.add(new FootStep(P, FlxPoint.get(-15, -8)));
		PlayState.i.fx_bg.add(new FootStep(P, FlxPoint.get(20, -12)));
		PlayState.i.fx_fg.add(new FootStep(P, FlxPoint.get(4, -15)));
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
}

class Slash extends MSprite
{
	/**
	 * TODO: This is shitty and unusable
	 * @param	P
	 */
	public function new(P:FlxPoint)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_slash.png", true, 32, 32);
		animation.add("play", [0, 1, 2, 3, 4, 5, 6, 7, 7], 30, false);
		animation.play("play");
		make_anchored_hitbox(0, 0);
		scale.x = Math.random() > 0.5 ? 1 : -1;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
}

class Explosion extends MSprite
{
	
	/**
	 * A big POOF for explosions
	 * @param	P	Origin
	 */
	public function new(P:FlxPoint, S:Int = 1)
	{
		super(P.x, P.y);
		loadGraphic("assets/images/fx_explosion.png", true, 16, 16);
		animation.add("play", [0, 1, 2, 3, 4, 5, 5, 6, 6, 7, 7, 7], 20, false);
		animation.play("play");
		make_and_center_hitbox(0, 0);
		angle = 90 * ZMath.randomRangeInt(0, 3);
		scale.set(S, S);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) kill();
		super.update(elapsed);
	}
}