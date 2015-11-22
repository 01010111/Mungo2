package obj;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import util.MSprite;

/**
 * ...
 * @author x01010111
 */
class Wrench extends MSprite
{
	var held:Bool = true;
	var wait:Bool = true;
	
	public function new() 
	{
		super(0, 0);
		loadGraphic("assets/images/wrench.png");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		y = PlayState.i.mungo.getMidpoint().y - height * 0.75;
		if (held)
		{
			facing = PlayState.i.mungo.facing;
			facing == FlxObject.LEFT ? angle = -45 : angle = 45;
			acceleration.x = 0;
			x = PlayState.i.mungo.getMidpoint().x - width * 0.5;
		}
		else if (!wait && Math.abs(getMidpoint().x - PlayState.i.mungo.getMidpoint().x) < 6) held = true;
		else 
		{
			var f = facing == FlxObject.LEFT ? -1 : 1;
			angle += 30 * f;
		}
	}
	
	public function toss(D:Int):Void
	{
		if (held)
		{
			wait = true;
			new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void { wait = false; }
			held = false;
			acceleration.x = 2000 * D * -1;
			velocity.x = 650 * D;
		}
	}
	
	public function rejoin():Void
	{
		velocity.x = PlayState.i.mungo.getMidpoint().x - getMidpoint().x * 50;
	}
	
}