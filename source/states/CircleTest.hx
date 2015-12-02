package states;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import zerolib.util.ZMath;
import flixel.FlxSprite;

/**
 * ...
 * @author x01010111
 */
class CircleTest extends FlxState
{
	var _numSprites = 4;
	var _speed = 1;
	
	override public function create():Void 
	{
		var c = new FlxSprite(FlxG.width * 0.5, FlxG.height * 0.5, "assets/images/wheel.png");
		//c.makeGraphic(128, 128, 0x00ffffff);
		//FlxSpriteUtil.drawCircle(c, -1, -1, -1, 0xff800000);
		c.offset.set(64, 64);
		FlxTween.tween(c, { angle:360 }, 360 / 60, { type:FlxTween.LOOPING } );
		add(c);
		var _p = FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5);
		for (i in 0..._numSprites)
		{
			add(new CircleySprite(_p, 64, i * (360 / _numSprites), _speed));
		}
		
		super.create();
	}
	
}

class CircleySprite extends FlxSprite
{
	var _origin:FlxPoint;
	var _radius:Float;
	var _angle:Float;
	var _speed:Float;
	var _framerate:Float = 60;
	var _text:FlxText;
	var _velo:Bool = true;
	
	public function new(_p:FlxPoint, _r:Float, _a:Float, _s:Float)
	{
		_origin = _p;
		_radius = _r;
		_angle = _a;
		_speed = _s;
		var _init = ZMath.placeOnCircle(_origin, _angle, _radius);
		super(_init.x, _init.y);
		loadGraphic("assets/images/circle_platform.png", true, 32, 32);
		animation.add("play", [3, 2, 1, 0], 4);
		animation.play("play");
		offset.set(16, 16);
		
		_text = new FlxText(10, 10, FlxG.width);
		FlxG.state.add(_text);
	}
	
	override public function update(elapsed:Float):Void 
	{
		_text.text = "Speed: " + _speed + "\n" + "Frame Rate: " + _framerate + "\n" + "Velocity: " + _velo;
		
		_angle += _speed;
		var _p = ZMath.placeOnCircle(_origin, _angle, _radius);
		var _d = ZMath.distance(FlxPoint.get(x, y), _p);
		var _a = ZMath.angleBetween(FlxPoint.get(x, y), _p);
		var _v = ZMath.velocityFromAngle(_a, _d * _framerate);
		_velo ? velocity.set(_v.x, _v.y) : acceleration.set(_v.x, _v.y);
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.R) FlxG.resetState();
		if (FlxG.keys.justPressed.UP) _speed++;
		if (FlxG.keys.justPressed.DOWN) _speed--;
		if (FlxG.keys.justPressed.LEFT) _framerate++;
		if (FlxG.keys.justPressed.RIGHT) _framerate--;
		if (FlxG.keys.justPressed.SPACE) _velo = _velo ? false : true;
	}
	
}