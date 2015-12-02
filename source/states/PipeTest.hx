package states;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import zerolib.util.ZMath;

/**
 * ...
 * @author x01010111
 */
class PipeTest extends FlxState
{
	public static var i:PipeTest;
	
	var tilemapArray:Array<Array<Int>> = [
		[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
		[10, 11, 10, 10, 12, 08, 09, 08, 13, 10, 10, 11, 10],
		[10, 10, 10, 10, 08, 09, 08, 09, 08, 10, 11, 10, 10],
		[10, 10, 10, 10, 09, 08, 09, 08, 09, 10, 10, 10, 10],
		[10, 10, 10, 10, 08, 09, 08, 09, 08, 10, 10, 10, 10],
		[10, 10, 11, 10, 15, 08, 09, 08, 14, 10, 10, 11, 10],
		[10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
	];
	
	var selection:FlxSprite;
	var selection_pos:FlxPoint;
	var puzzle_offset:FlxPoint;
	
	var pipes:Array<Array<PipeSprite>> = [
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null],
		[null, null, null, null, null]
	];
	
	var _level:Int;
	var _difficulty:Int = 0;

	override public function create():Void 
	{
		super.create();
		
		i = this;
		
		_level = _difficulty * 6 + ZMath.randomRangeInt(0, 5);
		
		puzzle_offset = FlxPoint.get(FlxG.width * 0.5 - 40 * 2.5, FlxG.height * 0.5 - 40 * 2.5);
		selection_pos = FlxPoint.get(2, 2);
		
		var map = new FlxTilemap();
		map.loadMapFrom2DArray(tilemapArray, "assets/images/minigame_pipe.png", 40, 40);
		add(map);
		map.setPosition( -20, -4);
		
		selection = new FlxSprite(puzzle_offset.x + selection_pos.x * 40, puzzle_offset.y + selection_pos.y * 40);
		selection.loadGraphic("assets/images/minigame_pipe.png", true, 40, 40);
		selection.animation.add("play", [4, 5, 6, 5], 10);
		selection.animation.play("play");
		add(selection);
		
		for (i in 0...PipeLevels.levelBools[_level][0].length)
		{
			if (PipeLevels.levelBools[_level][0][i])
			{
				var p:FlxSprite = new FlxSprite(puzzle_offset.x - 40, puzzle_offset.y + i * 40);
				p.loadGraphic("assets/images/minigame_pipe.png", true, 40, 40);
				p.animation.frameIndex = 7;
				add(p);
			}
		}
		
		for (i in 0...PipeLevels.levelBools[_level][1].length)
		{
			if (PipeLevels.levelBools[_level][1][i])
			{
				var p:FlxSprite = new FlxSprite(puzzle_offset.x + 5 * 40, puzzle_offset.y + i * 40);
				p.loadGraphic("assets/images/minigame_pipe.png", true, 40, 40);
				p.animation.frameIndex = 7;
				p.angle = 180;
				add(p);
			}
		}
		
		for (y in 0...PipeLevels.levelArrays[_level].length)
		{
			for (x in 0...PipeLevels.levelArrays[_level][y].length)
			{
				if (PipeLevels.levelArrays[_level][y][x] != 0)
				{
					pipes[y][x] = new PipeSprite(puzzle_offset.x + x * 40, puzzle_offset.y + y * 40, PipeLevels.levelArrays[_level][y][x] - 1);
					add(pipes[y][x]);
				}
			}
		}
	}
	
	var can_move:Bool = true;
	var _time:Float = 0.15;
	
	override public function update(elapsed:Float):Void 
	{
		if (can_move)
		{
			if (FlxG.keys.justPressed.UP && selection_pos.y > 0)
			{
				selection_pos.y--;
				can_move = false; FlxTween.tween(selection, { y:selection.y - 40 }, _time).onComplete = function(t:FlxTween):Void { can_move = true; }
			}
			if (FlxG.keys.justPressed.DOWN && selection_pos.y < 4)
			{
				selection_pos.y++;
				can_move = false; FlxTween.tween(selection, { y:selection.y + 40 }, _time).onComplete = function(t:FlxTween):Void { can_move = true; }
			}
			if (FlxG.keys.justPressed.LEFT && selection_pos.x > 0)
			{
				selection_pos.x--;
				can_move = false; FlxTween.tween(selection, { x:selection.x - 40 }, _time).onComplete = function(t:FlxTween):Void { can_move = true; }
			}
			if (FlxG.keys.justPressed.RIGHT && selection_pos.x < 4)
			{
				selection_pos.x++;
				can_move = false; FlxTween.tween(selection, { x:selection.x + 40 }, _time).onComplete = function(t:FlxTween):Void { can_move = true; }
			}
			
			var _px = Std.int(selection_pos.x);
			var _py = Std.int(selection_pos.y);
			
			if (FlxG.keys.justPressed.C && pipes[_py][_px] != null)
			{
				if (pipes[_py][_px].flippable) pipes[_py][_px].flip();
			}
			if (FlxG.keys.justPressed.X && pipes[_py][_px] != null)
			{
				if (pipes[_py][_px].flippable) pipes[_py][_px].flip(false);
			}
			
			if (FlxG.keys.justPressed.R) FlxG.resetState();
		}
		
		super.update(elapsed);
	}
	
	public function check():Void
	{
		var _ok:Bool = true;
		for (y in 0...pipes.length)
		{
			for (x in 0...pipes[y].length)
			{
				if (pipes[y][x] != null)
				{
					if (pipes[y][x].directions[0] == true)
					{
						if (y == 0) _ok = false;
						else 
						{
							if (pipes[y - 1][x] == null || pipes[y - 1][x].directions[2] == false) _ok = false;
						}
					}
					if (pipes[y][x].directions[1] == true)
					{
						if (x == 4)
						{
							if (PipeLevels.levelBools[_level][1][y] == false) _ok = false;
						}
						else
						{
							if (pipes[y][x + 1] == null || pipes[y][x + 1].directions[3] == false)_ok = false;
						}
					}
					if (pipes[y][x].directions[2] == true)
					{
						if (y == 4) _ok = false;
						else
						{
							if (pipes[y + 1][x] == null || pipes[y + 1][x].directions[0] == false)_ok = false;
						}
					}
					if (pipes[y][x].directions[3] == true)
					{
						if (x == 0)
						{
							if (PipeLevels.levelBools[_level][0][y] == false)_ok = false;
						}
						else
						{
							if (pipes[y][x - 1] == null || pipes[y][x - 1].directions[1] == false)_ok = false;
						}
					}
				}
			}
		}
		
		if (_ok) FlxG.camera.flash(0xff00ffff, 0.5);
	}
	
}

class PipeSprite extends FlxSprite
{
	public var flippable:Bool = true;
	public var directions:Array<Bool>;
	
	public function new(X:Float, Y:Float, F:Int):Void
	{
		super(X, Y);
		loadGraphic("assets/images/minigame_pipe.png", true, 40, 40);
		animation.frameIndex = F;
		switch(F)
		{
			case 0: directions = [false,  true, false,  true];
			case 1: directions = [false, false,  true,  true];
			case 2: directions = [false,  true,  true,  true];
			case 3: directions = [ true,  true,  true,  true];
		}
		for (i in 0...ZMath.randomRangeInt(0, 3)) 
		{
			flip_directions();
			angle += 90;
		}
	}
	
	var _scale_down:Float = 0.8;
	var _time:Float = 0.1;
	
	public function flip(_clockwise:Bool = true):Void
	{
		flippable = false;
		
		var _a = _clockwise ? angle + 90 : angle - 90;
		
		FlxTween.tween(scale, { x:_scale_down, y:_scale_down }, _time * 0.25, { ease:FlxEase.quintIn } ).onComplete = function(t:FlxTween):Void
		{
			FlxTween.tween(this, { angle:_a }, _time * 0.5).onComplete = function(t:FlxTween):Void
			{
				FlxTween.tween(scale, { x:1, y:1 }, _time * 0.25, { ease:FlxEase.quintOut } ).onComplete = function(t:FlxTween):Void
				{
					flippable = true;
					
					if (_clockwise)
					{
						flip_directions();
					}
					else
					{
						flip_directions();
						flip_directions();
						flip_directions();
					}
					PipeTest.i.check();
				}
			}
		}
	}
	
	function flip_directions():Void
	{
		directions.unshift(directions.pop());
	}
	
}

class PipeLevels
{
	public static var levelArrays:Array<Array<Array<Int>>> = [
		//	E	A	S	Y
		[
			[0, 0, 0, 2, 1],
			[1, 2, 0, 1, 0],
			[0, 3, 2, 1, 2],
			[0, 1, 2, 3, 2],
			[1, 2, 0, 0, 0]
		],
		[
			[0, 0, 2, 1, 2],
			[0, 0, 3, 2, 2],
			[2, 0, 1, 2, 2],
			[3, 2, 2, 0, 1],
			[2, 2, 0, 0, 2]
		],
		[
			[0, 0, 0, 2, 2],
			[0, 0, 0, 1, 2],
			[2, 2, 0, 1, 0],
			[2, 1, 2, 3, 1],
			[1, 3, 2, 0, 0]
		],
		[
			[1, 2, 0, 0, 0],
			[0, 1, 0, 2, 3],
			[2, 2, 0, 1, 2],
			[2, 1, 3, 2, 0],
			[1, 1, 2, 0, 0]
		],
		[
			[0, 0, 2, 1, 2],
			[0, 0, 1, 0, 2],
			[1, 3, 3, 1, 2],
			[2, 2, 2, 0, 2],
			[2, 1, 2, 0, 0]
		],
		[
			[0, 2, 3, 2, 2],
			[1, 2, 1, 2, 2],
			[1, 2, 1, 0, 0],
			[0, 3, 2, 0, 0],
			[0, 2, 1, 1, 1]
		],
		//	M	E	D	I	U	M
		[
			[0, 2, 1, 3, 1],
			[1, 2, 0, 1, 2],
			[2, 1, 1, 4, 2],
			[2, 0, 2, 3, 1],
			[1, 1, 2, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		//	H	A	R	D
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		],
		[
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0]
		]
	];
	
	public static var levelBools:Array<Array<Array<Bool>>> = [
		//	E	A	S	Y
		[
			[false, true, false, false, true],
			[true, false, true, false, false]
		],
		[
			[false, false, true, true, false],
			[false, true, false, false, true]
		],
		[
			[false, false, false, true, true],
			[false, true, false, true, false]
		],
		[
			[true, false, false, false, true],
			[false, true, true, false, false]
		],
		[
			[false, false, true, true, false],
			[false, true, false, true, false]
		],
		[
			[false, true, true, false, false],
			[true, false, false, false, true]
		],
		//	M	E	D	I	U	M
		[
			[false, true, false, true, true],
			[true, true, false, true, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		//	H	A	R	D
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		],
		[
			[false, false, false, false, false],
			[false, false, false, false, false]
		]
	];
}