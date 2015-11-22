package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import obj.Mungo;
import obj.Wrench;
import util.Control;

class PlayState extends FlxState
{
	public static var i:PlayState;
	public static var c:Control;
	
	var walls:Array<Array<Int>> = [
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
	];
	public var map:FlxTilemap;
	public var mungo:Mungo;
	public var wrench:Wrench;
	
	override public function create():Void
	{
		i = this;
		c = new Control();
		add(c);
		
		super.create();
		
		map = new FlxTilemap();
		map.loadMapFrom2DArray(walls, "assets/images/auto_tiles.png", 16, 16, FlxTilemapAutoTiling.AUTO);
		add(map);
		
		wrench = new Wrench();
		add(wrench);
		
		mungo = new Mungo(2, 4);
		add(mungo);
	}
	
	override public function update(elapsed:Float):Void 
	{
		check_collisions();
		if (FlxG.keys.justPressed.R) FlxG.resetState();
		super.update(elapsed);
	}
	
	function check_collisions():Void
	{
		FlxG.collide(mungo, map);
		//FlxG.overlap(wrench, map, returnWrench);
	}
	
	function returnWrench(w:Wrench, m:FlxTilemap):Void
	{
		w.rejoin();
	}
	
}