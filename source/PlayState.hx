package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.replay.FlxReplay;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var player:Character;
	var walls:flixel.tile.FlxTilemap;
	var map:FlxOgmoLoader;
	var loveEmitters:FlxTypedGroup<FlxEmitter>;
	var goal:FlxSprite;
	var playables:FlxGroup;
	var hostileDecorations:FlxGroup;
	var explosionsEmitters:FlxTypedGroup<FlxEmitter>;
	var currentHeart:FlxObject;
	
	static var recording:Bool;
	static var records:Map<Int,MyReplay> = new Map<Int,MyReplay>();
	static var lives:Int = 3;
	static public var score:Int = 0;
	static var currentEntityId:Int = 0;
	static var entityIncarnationOrder:Array<Int> = [2,4,28,24,25,27,23,3,17,21,22,20,19,18,0,1
	];
	var scoreText:flixel.text.FlxText;
	
	static public function resetRecords()
	{
		recording = false;
		records = new Map<Int,MyReplay>();
		currentEntityId = 0;
		lives = 3;
		score = 0;
	}
	
	override public function create():Void
	{
		super.create();
		
		FlxG.sound.playMusic(AssetPaths.theme__ogg,.5);
		
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		
		map = new FlxOgmoLoader(AssetPaths.puddleLevel__oel);
		
		walls = map.loadTilemap(AssetPaths.tileset__png, 32, 32, "walls");
		walls.setTileProperties(2, FlxObject.NONE);
		walls.follow();
		add(walls);
		
		trace("create");
		playables = new FlxGroup();
		add(playables);
		
		hostileDecorations = new FlxGroup();
		add(hostileDecorations);
		
		
		map.loadEntities(placeEntity, "entities");
		
		loveEmitters = new FlxTypedGroup<FlxEmitter>();
		add(loveEmitters);
		
		//emitLove(player);
		explosionsEmitters = new FlxTypedGroup<FlxEmitter>();
		add(explosionsEmitters);
		
		createLiveHud();
		createScoreHud();
		
		if (!recording)
		{
			FlxG.vcr.startRecording(false);
			recording = true;
		}
	}
	
	function createLiveHud()
	{
		for (i in 0...lives)
		{
			currentHeart= new FlxSprite(10 + i * 35, 10, AssetPaths.heart__png);
			currentHeart.scrollFactor.set(0, 0);
			add(currentHeart);
		}
	}
	
	function createScoreHud()
	{
		scoreText = new flixel.text.FlxText(0, 0, 0, "SCORE\n" + StringTools.lpad(Std.string(score), "0", 5), 12);
		scoreText.scrollFactor.set(0, 0);
		scoreText.x = FlxG.width - scoreText.width - 5;
		add(scoreText);
	}
	
	function placeEntity(name:String, data:Xml):Void
	{
		var x:Int = Std.parseInt(data.get("x"));
		var y:Int = Std.parseInt(data.get("y"));
		var id:Int = Std.parseInt(data.get("id"));
		
		var current = entityIncarnationOrder[currentEntityId];
	
		trace(name.substr(0, 2));
		if (name.substr(0,2) == "pl")
		{
			trace("playable");
			var p:Character = null;
			if (name == "pl_player")
			{
				p = new Character();
				trace("player placed at " + x + "," + y);
				p.x = x;
				p.y = y;
			}else if (name == "pl_shrimp")
			{
				p = new Shrimp(x, y);

			}
			playables.add(p);
		
			
			if (id == current)
			{
				p.enableHumanControl();
				FlxG.camera.follow(p);
				player = p;
				add(new Pointer(x, y, player));
				
			}else{
				if (records.exists(id))
				{
					trace("RECORD FOUND FOR " + id);
					p.setReplay(records.get(id));
				}
			}
			
		}else if (name == "ballotbox")
		{
			var b  = new BallotBox(x, y);
			goal = b;
			add(b);
		}else if (name == "anemone")
		{
			var a  = new Anemone(x, y);
			hostileDecorations.add(a);
		}
	}
	
	function saveReplay()
	{
		recording = false;
		var record = FlxG.vcr.stopRecording(false);
		var current = entityIncarnationOrder[currentEntityId];
		var mr = new MyReplay();
		mr.load(record);
		trace("SAVING RECORD AT:" + current);
		records.set(current, mr);
	}
	
	function incarnateNextEntity()
	{
		trace("incarnateNextEntity");
		saveReplay();
		currentEntityId++;
		FlxG.resetState();
		//destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.overlap(playables, goal, onPlayableReachGoal);
		FlxG.overlap(player, hostileDecorations, onPlayableTouchHostile);
		FlxG.overlap(player, playables, onPlayableTouchHostile);
		FlxG.collide(playables, walls);
		checkInputs();
		
	}
	
	function onPlayableTouchHostile(playable:Character, g:FlxSprite)
	{
		die();
	}
	
	function onPlayableReachGoal(playable:Character,g:FlxSprite) 
	{
		if (playable.isHumanControlled)
		{
			/**
			 * check for win or incarnate next fish
			 */
			if (currentEntityId + 1 == entityIncarnationOrder.length)
			{
				trace("SUCCESS");
				stopRecording();
				success();
			}else{
				setScore(score+10);
				incarnateNextEntity();
			}
		}else{
			playable.goBackToStartingPoint(walls);
		}
	}
	
	function setScore(value:Int) 
	{
		score = value;
		scoreText.text = "SCORE\n" + StringTools.lpad(Std.string(score), "0", 5);
	}
	
	function stopRecording()
	{		
		FlxG.vcr.stopRecording(false);
		recording = false;
	}
	
	function success() 
	{
		FlxG.switchState(new WinState());
	}
	
	function checkInputs() 
	{
		if (FlxG.keys.pressed.R)
			incarnateNextEntity();
	}
	
	
	function die()
	{
		lives--;
		explode(player);
		explode(currentHeart);
		stopRecording();
		FlxG.camera.shake(0.05, .2);
		
		if (lives == 0)
		{
			//Gameover
			new FlxTimer().start(1, function(_)
			{
				FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
				{
					FlxG.switchState(new LoseState());
				});
			});
		}else
		{	
			new FlxTimer().start(1, function(_)
			{
				FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
				{
					FlxG.resetState();
				});
			});
		}
		
	}
	
	function explode(target:FlxObject)
	{
		var explosionEmitter:FlxEmitter = explosionsEmitters.getFirstAvailable(FlxEmitter);
		if (explosionEmitter == null)
		{
			explosionEmitter = new FlxEmitter();
			explosionEmitter.makeParticles(2, 2, FlxColor.RED);
			explosionEmitter.lifespan.set(0.1, 0.5);
			explosionEmitter.speed.set(300);
		}
		explosionEmitter.setPosition(target.x, target.y);
		explosionsEmitters.add(explosionEmitter);
		explosionEmitter.start();
		target.kill();
	}
	
	function emitLove(character:Character)
	{
		if (character.emitter == null)
		{
			var loveEmitter:FlxEmitter = loveEmitters.getFirstAvailable(FlxEmitter);
			if (loveEmitter == null)
			{
				loveEmitter = new FlxEmitter();
				loveEmitter.loadParticles(AssetPaths.heart__png);
				//loveEmitter.makeParticles(2, 2, FlxColor.BLACK);
				loveEmitter.lifespan.set(0.1, 0.3);
				loveEmitter.speed.set(100);
				loveEmitter.scale.set(0.1, 0.1, 0.1, 0.1, 1, 1, 1, 1);
			}
			character.emitter = loveEmitter;
		}
		character.emitter.setPosition(character.x, character.y);
		loveEmitters.add(character.emitter);
		character.emitter.start(false,0.1,0);
	}

}