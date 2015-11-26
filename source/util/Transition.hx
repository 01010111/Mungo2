package util;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import effects.*;
import objects.*;
import particles.*;
import states.*;
import ui.*;
import util.*;
import zerolib.util.ZMath;

/**
 * ...
 * @author x01010111
 */
class Transition extends FlxSubState
{

	var dest_map:String;
	var dest_node:Int;
	var black:Int = 0xff090c0a;
	
	public function new(IN:Bool, MAP:String = "test", NODE:Int = 0) 
	{
		super();
		dest_map = MAP;
		dest_node = NODE;
		IN ? transIn() : transOut();
	}
	
	function exit(?t:FlxTimer):Void
	{
		FlxG.switchState(new PlayState(dest_map, dest_node));
	}
	
	/*
	 * TRANSITIONS IN
	 */
	
	function transIn():Void
	{
		var i = ZMath.randomRangeInt(0, 2);
		switch(i)
		{
			case 0: starIn();
			case 1: diamondIn();
			case 2: shadesIn();
		}
	}
	
	function starIn():Void
	{
		var s1:FlxSprite = new FlxSprite();
		var s2:FlxSprite = new FlxSprite();
		var s3:FlxSprite = new FlxSprite();
		var s4:FlxSprite = new FlxSprite();
		
		s1.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		s2.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		s3.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		s4.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		
		FlxSpriteUtil.fill(s1, 0x00ffffff);
		FlxSpriteUtil.fill(s2, 0x00ffffff);
		FlxSpriteUtil.fill(s3, 0x00ffffff);
		FlxSpriteUtil.fill(s4, 0x00ffffff);
		
		FlxSpriteUtil.drawPolygon(s1, [FlxPoint.get(0, 0), FlxPoint.get(s1.width, 0), FlxPoint.get(s1.width, s1.height * 0.25), FlxPoint.get(s1.width * 0.75, s1.height * 0.75), FlxPoint.get(s1.width * 0.25, s1.height), FlxPoint.get(0, s1.height)], black);
		FlxTween.tween(s1, { x: -FlxG.width, y: -FlxG.height }, 0.75);
		
		FlxSpriteUtil.drawPolygon(s2, [FlxPoint.get(0, 0), FlxPoint.get(s2.width, 0), FlxPoint.get(s2.width, s2.height * 0.25), FlxPoint.get(s2.width * 0.75, s2.height * 0.75), FlxPoint.get(s2.width * 0.25, s2.height), FlxPoint.get(0, s2.height)], black);
		s2.scale.x = -1;
		FlxTween.tween(s2, { x: FlxG.width, y: -FlxG.height }, 0.75);
		
		FlxSpriteUtil.drawPolygon(s3, [FlxPoint.get(0, 0), FlxPoint.get(s3.width, 0), FlxPoint.get(s3.width, s3.height * 0.25), FlxPoint.get(s3.width * 0.75, s3.height * 0.75), FlxPoint.get(s3.width * 0.25, s3.height), FlxPoint.get(0, s3.height)], black);
		s3.scale.y = -1;
		FlxTween.tween(s3, { x: -FlxG.width, y: FlxG.height }, 0.75);
		
		FlxSpriteUtil.drawPolygon(s4, [FlxPoint.get(0, 0), FlxPoint.get(s4.width, 0), FlxPoint.get(s4.width, s4.height * 0.25), FlxPoint.get(s4.width * 0.75, s4.height * 0.75), FlxPoint.get(s4.width * 0.25, s4.height), FlxPoint.get(0, s4.height)], black);
		s4.scale.set( -1, -1);
		FlxTween.tween(s4, { x: FlxG.width, y: FlxG.height }, 0.75);
		
		s1.scrollFactor.set();
		s2.scrollFactor.set();
		s3.scrollFactor.set();
		s4.scrollFactor.set();
		
		add(s1);
		add(s2);
		add(s3);
		add(s4);
		
		new FlxTimer().start(0.75).onComplete = function(t:FlxTimer):Void { close(); }
	}
	
	function diamondIn():Void
	{
		var dH = Math.round(FlxG.width / 40);
		var dV = Math.round(FlxG.height / 40);
		
		for (y in 0...dV)
		{
			for (x in 0...dH)
			{
				var s:FlxSprite = new FlxSprite(FlxG.width / dH * x, FlxG.height / dV * y);
				s.makeGraphic(Math.round(FlxG.width / dH), Math.round(FlxG.height / dV), black);
				s.angle = 45;
				s.scale.set(2, 2);
				s.scrollFactor.set();
				FlxTween.tween(s.scale, { x:0, y:0 }, 0.5);
				add(s);
			}
		}
		
		new FlxTimer().start(0.5).onComplete = function(t:FlxTimer):Void { close(); }
	}
	
	function shadesIn():Void
	{
		for (i in 0...8)
		{
			var s:FlxSprite = new FlxSprite(0, FlxG.height / 8 * i);
			s.makeGraphic(FlxG.width, Math.floor(FlxG.height / 8) + 2, black);
			s.scrollFactor.set();
			new FlxTimer().start(i * 0.05 + 0.05).onComplete = function(t:FlxTimer):Void
			{
				FlxTween.tween(s.scale, { y:0 }, 0.2);
			}
			add(s);
		}
		
		new FlxTimer().start(0.7).onComplete = function(t:FlxTimer):Void { close(); }
	}
	
	/*
	 * 	TRANSITIONS OUT
	 */
	
	function transOut():Void
	{
		var i = ZMath.randomRangeInt(0, 3);
		switch(i)
		{
			case 0: swirlOut();
			case 1: diamondOut();
			case 2: swipeOut();
			case 3: shadesOut();
		}
	}
	
	function swirlOut():Void
	{
		var s:FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		FlxSpriteUtil.fill(s, 0x00ffffff);
		s.scrollFactor.set();
		add(s);
		var t = 0.0;
		var w = 1.25 / FlxG.width;
		for (i in 0...Math.round(FlxG.width * 0.8))
		{
			var held = 1;
			if (i % held == 0)
			{
				new FlxTimer().start(i * w + 0.01).onComplete = function(t:FlxTimer):Void {
					var p = ZMath.placeOnCircle(FlxG.width * 0.5,  FlxG.height * 0.5, i * 5, FlxG.width * 0.8 - i);
					FlxSpriteUtil.drawCircle(s, p.x, p.y, 80, black);
				}
				t += w * held;
			}
		}
		
		new FlxTimer().start(t + 0.01, exit);
	}
	
	function diamondOut():Void
	{
		var dH = Math.round(FlxG.width / 40);
		var dV = Math.round(FlxG.height / 40);
		
		for (y in 0...dV)
		{
			for (x in 0...dH)
			{
				var s:FlxSprite = new FlxSprite(FlxG.width / dH * x, FlxG.height / dV * y);
				s.makeGraphic(Math.round(FlxG.width / dH), Math.round(FlxG.height / dV), black);
				s.angle = 45;
				s.scale.set(0, 0);
				s.scrollFactor.set();
				FlxTween.tween(s.scale, { x:2, y:2 }, 0.5);
				add(s);
			}
		}
		
		new FlxTimer().start(0.75).onComplete = function(t:FlxTimer):Void { exit(); }
	}
	
	function swipeOut():Void
	{
		var e = Math.floor(FlxG.width * 0.5);
		var s:FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.width + e, FlxG.height, 0x00ffffff);
		FlxSpriteUtil.fill(s, 0x00ffffff);
		FlxSpriteUtil.drawPolygon(s, [FlxPoint.get(0, 0), FlxPoint.get(FlxG.width, 0), FlxPoint.get(s.width, FlxG.height), FlxPoint.get(0, FlxG.height)], black);
		s.scrollFactor.set();
		if (PlayState.i.mungo.x < PlayState.i.map.width * 0.5)
		{
			s.scale.x = -1;
			s.x = FlxG.width;
			FlxTween.tween(s, { x: -e }, 0.3);
		}
		else
		{
			s.x = -s.width;
			FlxTween.tween(s, { x:0 }, 0.3);
		}
		add(s);
		
		new FlxTimer().start(0.4).onComplete = function(t:FlxTimer):Void { exit(); }
	}
	
	function shadesOut():Void
	{
		for (i in 0...8)
		{
			var s:FlxSprite = new FlxSprite(0, FlxG.height / 8 * i);
			s.makeGraphic(FlxG.width, Math.floor(FlxG.height / 8) + 2, black);
			s.scrollFactor.set();
			s.scale.set(1, 0);
			new FlxTimer().start(i * 0.05 + 0.05).onComplete = function(t:FlxTimer):Void
			{
				FlxTween.tween(s.scale, { y:1 }, 0.2);
			}
			add(s);
		}
		
		new FlxTimer().start(0.7).onComplete = function(t:FlxTimer):Void { exit(); }
	}
	
}