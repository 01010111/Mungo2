package obj;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import obj.*;
import obj.FX.Explosion;
import obj.FX.FootStep;
import obj.FX.Slash;
import obj.FX.WrenchGet;
import obj.FX.LandPuff;
import obj.Mungo.Wrench;
import util.*;
import states.*;
import zerolib.util.ZMath;

/**
 * ...
 * @author x01010111
 */
class Mungo extends MSprite
{
	var _speed:Float = 150;
	var _holding:Bool = true;
	var _throwing:Bool = false;
	
	public var wrench:Wrench;
	
	public function new(X:Float, Y:Float) 
	{
		super(X + 2, Y - 8);
		loadGraphic("assets/images/mungo.png", true, 40, 32);
		animation.add("idle", [0]);
		animation.add("hurt", [1]);
		animation.add("jump", [3]);
		animation.add("fall", [6]);
		animation.add("run", [2, 3, 3, 4, 5, 6, 6, 7], 20);
		animation.add("hold_idle", [8]);
		animation.add("hold_hurt", [9]);
		animation.add("hold_jump", [11]);
		animation.add("hold_fall", [14]);
		animation.add("hold_run", [10, 11, 11, 12, 13, 14, 14, 15], 20);
		animation.add("throw", [16, 17, 18, 18], 20, false);
		acceleration.y = 1200;
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		make_anchored_hitbox(12, 24);
		health = 3;
		animation.callback = callback;
		maxVelocity.set(_speed, _speed * 4);
		
		wrench = new Wrench();
	}
	
	function callback(_s:String, _f:Int, _i:Int):Void
	{
		if (_i == 18 && _holding)
		{
			_holding = false;
			var t = facing == FlxObject.LEFT ? -1 : 1;
			wrench.toss(t, getMidpoint());
		}
		else if (_i == 4 || _i == 7 || _i == 12 || _i == 15)
		{
			PlayState.i.fx_fg.add(new FootStep(FlxPoint.get(getMidpoint().x, y + height)));
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (justTouched(FlxObject.FLOOR)) {
			//FlxG.sound.play("Land", 0.2);
			PlayState.i.fx_fg.add(new LandPuff(get_anchor()));
		}
		if (animation.finished) _throwing = false;
		move();
		if (FlxSpriteUtil.isFlickering(this)) {
			_holding ? animation.play("hold_hurt") : animation.play("hurt");
		}
		else if (_throwing) animation.play("throw");
		else {
			controls();
			if (velocity.y < 0 && !isTouching(FlxObject.FLOOR)) _holding ? animation.play("hold_jump") : animation.play("jump");
			else if (velocity.y > 0&& !isTouching(FlxObject.FLOOR)) _holding ? animation.play("hold_fall") : animation.play("fall");
			else if (velocity.x != 0) _holding ? animation.play("hold_run") : animation.play("run");
			else _holding ? animation.play("hold_idle") : animation.play("idle");
		}
		if (velocity.x > 0) facing = FlxObject.RIGHT;
		else if (velocity.x < 0) facing = FlxObject.LEFT;
		
		wrench_stuff();
		bounds();
		super.update(elapsed);
	}
	
	function bounds():Void
	{
		var _p = getMidpoint();
		if (_p.x < 0 || _p.x > PlayState.i.map.width || _p.y < 0 || _p.y > PlayState.i.map.height)
		{
			var d = 1920.0;
			var n:TravelNode = null;
			for (i in 0...PlayState.i.nodes.length)
			{
				var d2 = ZMath.distance(PlayState.i.nodes.members[i].getMidpoint(), getMidpoint());
				if (d2 < d)
				{
					n = PlayState.i.nodes.members[i];
					d = d2;
				}
			}
			if (n != null) 
			{
				PlayState.i.exit(n);
			}
		}
	}
	
	function wrench_stuff():Void
	{
		if (wrench.exists)
		{
			wrench.velocity.y = (getMidpoint().y - 6 - wrench.y) * 5;
			if (!wrench._wait) FlxG.overlap(wrench, this, kill_wrench);
		}
	}
	
	function kill_wrench(w:Wrench, m:Mungo):Void
	{
		w.setPosition( -64, -64);
		w.exists = false;
		_holding = true;
		PlayState.i.fx_fg.add(new WrenchGet(getMidpoint()));
	}
	
	function move():Void
	{
		velocity.x = PlayState.c.ANALOG.x * _speed;
		if (PlayState.c.A_JUST_PRESSED && isTouching(FlxObject.FLOOR)) jump();
	}
	
	function controls():Void
	{
		if (PlayState.c.B_JUST_PRESSED && _holding) toss();
	}
	
	function jump():Void
	{
		//FlxG.sound.play("Jump", 0.1);
		velocity.y = -400;
	}
	
	function toss():Void
	{
		_throwing = true;
	}
	
}

/**
 * 		W	R	E	N	C	H
 */
class Wrench extends MSprite
{
	public var _wait:Bool;
	
	var _trail:FlxTrail;
	
	var _acceleration_factor:Float = 20;
	var _toss_strength:Float = 400;
	
	public function new():Void
	{
		super(-64, -64);
		loadGraphic("assets/images/wrench.png", true, 32, 24);
		make_and_center_hitbox(8, 8);
		animation.add("spin", [0, 1, 2, 3], 30);
		animation.add("idle", [4]);
		exists = false;
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		maxVelocity.x = _toss_strength;
		elasticity = 0.8;
		
		_trail = new FlxTrail(this, null, 4, 4, 0.2);
		PlayState.i.fx_bg.add(_trail);
	}
	
	public function toss(D:Int, P:FlxPoint):Void
	{
		_wait = true;
		new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void { _wait = false; }
		setPosition(P.x + 8 * D, P.y);
		velocity.set(_toss_strength * D, -20);
		facing = D == 1 ? FlxObject.RIGHT : FlxObject.LEFT;
		exists = true;
		animation.play("spin");
	}
	
	override public function update(elapsed:Float):Void 
	{
		acceleration.x = (PlayState.i.mungo.getMidpoint().x - getMidpoint().x) * _acceleration_factor;
		FlxG.overlap(this, PlayState.i.enemies, check_enemy_hit);
		super.update(elapsed);
	}
	
	function check_enemy_hit(w:Wrench, e:Enemy):Void
	{
		if (e.is_vulnerable && !e.is_friendly)
		{
			PlayState.i.fx_fg.add(new Explosion(ZMath.getMidPoint(w.getMidpoint(), e.getMidpoint()), 2));
			w.pause_timer = e.pause_timer = 8;
			e.hurt(0);
		}
	}
	
}