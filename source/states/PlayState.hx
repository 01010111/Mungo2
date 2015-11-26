package states;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import obj.*;
import util.*;
import states.*;
import obj.Enemy.Crab;
import obj.Enemy.Spike;
import obj.TravelNode.DoorNode;

class PlayState extends MState
{
	public static var i:PlayState;
	public static var c:Control;
	
	public var fx_bg:FlxGroup;
	public var fx_fg:FlxGroup;
	public var obj_bg:FlxGroup;
	public var obj_fg:FlxGroup;
	public var nodes:FlxTypedGroup<TravelNode>;
	public var doors:FlxTypedGroup<DoorNode>;
	public var map:FlxTilemap;
	public var mungo:Mungo;
	public var enemies:FlxTypedGroup<Enemy>;
	public var platforms:FlxGroup;
	
	var _map:String;
	var _node:Int;
	
	public function new(state_map:String = "benten_4", entrance_node:Int = 0)
	{
		_map = state_map;
		_node = entrance_node;
		super();
	}
	
	override public function create():Void
	{
		i = this;
		c = new Control();
		add(c);
		
		super.create();
		
		fx_bg = new FlxGroup();
		obj_bg = new FlxGroup();
		enemies = new FlxTypedGroup();
		mungo = new Mungo(2, 4);
		obj_fg = new FlxGroup();
		fx_fg = new FlxGroup();
		nodes = new FlxTypedGroup();
		doors = new FlxTypedGroup();
		platforms = new FlxGroup();
		
		loadMap();
		
		add(map);
		add(fx_bg);
		add(obj_bg);
		add(enemies);
		add(mungo);
		add(obj_fg);
		obj_fg.add(mungo.wrench);
		add(fx_fg);
		add(nodes);
		
		FlxG.camera.follow(mungo, FlxCameraFollowStyle.PLATFORMER);
		FlxG.camera.setScrollBoundsRect(0, 0, map.width, map.height, true);
		
		openSubState(new Transition(true));
	}
	
	function loadMap():Void
	{
		var mapStr = "assets/data/" + _map + ".oel";
		var map_loader = new FlxOgmoLoader(mapStr);
		var tileAsset:String = "assets/images/" + map_loader.getProperty("tileset") + "_tiles.png";
		var tP:Array<Int> = new Array();
		switch(tileAsset)
		{
			case "assets/images/test_tiles.png": 
				tP = [
					0x0000, 0x0000, 0x0000, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111
				];
			case "assets/images/benten_tiles.png": 
				tP = [
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x1111, 0x0000, 0x0100, 0x0100, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0100, 0x1111, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x1111, 0x0000, 0x0000, 0x0000, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x1111, 0x1111, 0x1111, 0x1111, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x1111, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 
					0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000
				];
		}
		map = map_loader.loadTilemap(tileAsset, 16, 16, "map");
		for (i in 0...tP.length) map.setTileProperties(i, tP[i]);
		map_loader.loadEntities(place_objects, "objects");
		set_mungo();
	}
	
	function place_objects(entityName:String, entityData:Xml):Void
	{
		//FlxG.log.add(entityName);
		var p:FlxPoint = FlxPoint.get(Std.parseInt(entityData.get("x")), Std.parseInt(entityData.get("y")));
		switch(entityName)
		{
			case "travel_node":
				nodes.add(new TravelNode(p, entityData.get("dest_map"), Std.parseInt(entityData.get("dest_node")), Std.parseInt(entityData.get("node"))));
			case "door_node":
				var d = new DoorNode(p, entityData.get("dest_map"), Std.parseInt(entityData.get("dest_node")), Std.parseInt(entityData.get("node")));
				nodes.add(d);
				doors.add(d);
			case "crab":
				enemies.add(new Crab(p));
			case "spike":
				enemies.add(new Spike(p));
			case "platform":
				var e:Xml = entityData.firstElement();
				var plat = new Platform(p, FlxPoint.get(Std.parseInt(e.get("x")), Std.parseInt(e.get("y"))));
				obj_fg.add(plat);
				platforms.add(plat);
			case "spring":
				obj_bg.add(new Spring(p));
		}
	}
	
	function set_mungo():Void
	{
		for (i in 0...nodes.length)
		{
			if (nodes.members[i].node == _node)
			{
				mungo = new Mungo(nodes.members[i].x, nodes.members[i].y);
				return;
			}
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		check_collisions();
		if (FlxG.keys.justPressed.R) FlxG.resetState();
	}
	
	function check_collisions():Void
	{
		FlxG.collide(mungo, map);
		FlxG.collide(mungo, platforms);
		FlxG.collide(mungo.wrench, map);
		FlxG.overlap(mungo, doors, door_check);
	}
	
	function door_check(m:Mungo, d:DoorNode):Void
	{
		if (c.Y_JUST_PRESSED)
		{
			exit(d);
		}
	}
	
	public function exit(d:TravelNode):Void
	{
		openSubState(new Transition(false, d.dest_map, d.dest_node));
	}
	
}