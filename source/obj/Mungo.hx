package obj;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import util.MSprite;

/**
 * ...
 * @author x01010111
 */
class Mungo extends MSprite
{
	var _speed:Float = 150;
	
	public function new(X:Int, Y:Int) 
	{
		super(X * 16 + 2, Y * 16 - 8);
		loadGraphic("assets/images/mungo.png", true, 32, 32);
		animation.add("idle", [0]);
		animation.add("hurt", [1]);
		animation.add("jump", [3]);
		animation.add("fall", [6]);
		animation.add("run", [2, 3, 3, 4, 5, 6, 6, 7], 20);
		animation.add("throw", [9, 10, 11, 11], 20, false);
		acceleration.y = 1200;
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		width = 12;
		height = 24;
		offset.x = 10;
		offset.y = 8;
		health = 3;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (justTouched(FlxObject.FLOOR)) {
			//FlxG.sound.play("Land", 0.2);
		}
		//if (animation.finished) throwing = false;
		controls();
		if (FlxSpriteUtil.isFlickering(this)) {
			animation.play("hurt");
		}
		//else if (throwing) animation.play("throw");
		else {
			
			if (velocity.y < 0 && !isTouching(FlxObject.FLOOR)) animation.play("jump");
			else if (velocity.y > 0&& !isTouching(FlxObject.FLOOR)) animation.play("fall");
			else if (velocity.x != 0) animation.play("run");
			else animation.play("idle");
		}
		if (velocity.x > 0) facing = FlxObject.RIGHT;
		else if (velocity.x < 0) facing = FlxObject.LEFT;
		super.update(elapsed);
		/*if (y > 16 * 64) {
			reLoad();
		}*/
	}
	
	function controls():Void
	{
		velocity.x = PlayState.c.ANALOG.x * _speed;
		if (PlayState.c.A_JUST_PRESSED && isTouching(FlxObject.FLOOR)) jump();
		if (PlayState.c.B_JUST_PRESSED) toss();
	}
	
	function jump():Void
	{
		//FlxG.sound.play("Jump", 0.1);
		velocity.y = -400;
	}
	
	function toss():Void
	{
		var t = facing == FlxObject.LEFT ? -1 : 1;
		PlayState.i.wrench.toss(t);
	}
	
}