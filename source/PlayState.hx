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

class PlayState extends FlxState
{
	var player:Character;
	var walls:flixel.tile.FlxTilemap;
	var map:FlxOgmoLoader;
	var loveEmitters:FlxTypedGroup<FlxEmitter>;
	var goal:FlxSprite;
	var playables:flixel.group.FlxGroup;
	
	static var recording:Bool;
	static var records:Map<Int,MyReplay> = new Map<Int,MyReplay>();
	static var currentEntityId:Int = 0;
	static var entityIncarnationOrder:Array<Int> = [0,1,2,3,4
	];
	
	override public function create():Void
	{
		super.create();
		
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		
		map = new FlxOgmoLoader(AssetPaths.puddleLevel__oel);
		
		walls = map.loadTilemap(AssetPaths.tileset__png, 32, 32, "walls");
		walls.setTileProperties(2, FlxObject.NONE);
		walls.follow();
		add(walls);
		
		trace("create");
		playables = new FlxGroup();
		add(playables);
		map.loadEntities(placeEntity, "entities");
		
		loveEmitters = new FlxTypedGroup<FlxEmitter>();
		add(loveEmitters);
		
		//emitLove(player);
		
		if (!recording)
		{
			FlxG.vcr.startRecording(false);
			recording = true;
		}
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
		FlxG.collide(player, walls);
		checkInputs();
		
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
				FlxG.vcr.stopRecording(false);
				recording = false;
				success();
			}else
				incarnateNextEntity();
		}
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