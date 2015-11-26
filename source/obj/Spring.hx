package obj;
import flixel.FlxG;
import flixel.math.FlxPoint;
import states.PlayState;
import util.MSprite;

/**
 * ...
 * @author x01010111
 */
class Spring extends MSprite
{

	public function new(_p:FlxPoint) 
	{
		super(_p.x, _p.y + 4);
		loadGraphic("assets/images/spring.png", true, 16, 16);
		animation.add("play", [0, 1, 2, 3, 2, 3, 2, 3, 2, 3, 1, 0], 20, false);
		animation.add("idle", [0]);
		animation.play("idle");
		make_anchored_hitbox(16, 12);
		immovable = true;
		allowCollisions = 0x0100;
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (animation.finished) animation.play("idle");
		FlxG.collide(this, PlayState.i.mungo, mungo_bounce);
		super.update(elapsed);
	}
	
	function mungo_bounce(s:Spring, m:Mungo):Void
	{
		m.velocity.y = -500;
		s.animation.play("play");
	}
	
}