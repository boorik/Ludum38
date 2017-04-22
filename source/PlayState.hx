package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.particles.FlxEmitter;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.replay.FlxReplay;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

typedef EntityId = {
	var name:String;
	var id:Int;
}
class PlayState extends FlxState
{
	var player:Character;
	var walls:flixel.tile.FlxTilemap;
	var map:FlxOgmoLoader;
	var loveEmitters:FlxTypedGroup<FlxEmitter>;
	
	
	static var recording:Bool;
	static var records:Map<String,MyReplay> = new Map<String,MyReplay>();
	static var currentEntityId:Int = 0;
	static var entityIncarnationOrder:Array<EntityId> = [
		{name:"player", id:0},
		{name:"player",id:2},
		{name:"player",id:1},
		{name:"player",id:3}	
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
		var p:Character = new Character();
		if (name == "player")
		{
			trace("player placed at " + x + "," + y);
			p.x = x;
			p.y = y;
			add(p);
		}
		
		if (name == current.name && id == current.id)
		{
			p.enableHumanControl();
			FlxG.camera.follow(p);
		}else{
			if (records.exists(name+id))
			{
				trace("RECORD FOUND FOR " + name+id);
				p.setReplay(records.get(name+id));
			}
		}
		
	}
	
	function saveReplay()
	{
		recording = false;
		var record = FlxG.vcr.stopRecording(false);
		var current = entityIncarnationOrder[currentEntityId];
		var mr = new MyReplay();
		mr.load(record);
		trace("SAVING RECORD AT:" + current.name+current.id);
		records.set(current.name+current.id, mr);
	}
	
	function incarnateNextEntity()
	{
		saveReplay();
		currentEntityId++;
		FlxG.resetState();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(player, walls);
		checkInputs();
		
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