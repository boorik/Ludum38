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
	static var entityIncarnationOrder:Array<Int> = [
	];
	static var incarnationOrderInited:Bool;
	static public var remainingTime:Float;
	var scoreText:flixel.text.FlxText;
	var timerText:flixel.text.FlxText;
	var votedText:flixel.text.FlxText;
	var dead:Bool;
	
	static public function resetRecords()
	{
		recording = false;
		records = new Map<Int,MyReplay>();
		currentEntityId = 0;
		lives = 3;
		score = 0;
		remainingTime = 540;
	}
	
	override public function create():Void
	{
		super.create();
		
		FlxG.sound.playMusic(AssetPaths.theme__ogg,.5);
		
		FlxG.worldBounds.set(0, 0, 2000, 2000);
		
		map = new FlxOgmoLoader(AssetPaths.puddleLevel__oel);
		
		walls = map.loadTilemap(AssetPaths.tileset__png, 32, 32, "walls");
		walls.setTileProperties(2, FlxObject.NONE);
		for (t in 5...25)
			walls.setTileProperties(t, FlxObject.NONE);
		walls.follow();
		add(walls);
		
		trace("create");
		playables = new FlxGroup();
		add(playables);
		
		hostileDecorations = new FlxGroup();
		add(hostileDecorations);
		
		
		map.loadEntities(placeEntity, "entities");
		incarnationOrderInited = true;
		loveEmitters = new FlxTypedGroup<FlxEmitter>();
		add(loveEmitters);
		
		//emitLove(player);
		explosionsEmitters = new FlxTypedGroup<FlxEmitter>();
		add(explosionsEmitters);
		
		createLiveHud();
		createScoreHud();
		createTimerHud();
		createVotedHud();
		
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
			currentHeart= new BallotPaper(10 + i * 35, 10,null);
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
	
	function createTimerHud()
	{
		timerText = new flixel.text.FlxText(0, 0, 0, "TIME : " + Std.int(remainingTime), 12);
		timerText.scrollFactor.set(0, 0);
		timerText.x = (FlxG.width-timerText.width)/2;
		add(timerText);
	}
	
	function createVotedHud()
	{
		votedText = new flixel.text.FlxText(10, 47, 0, "VOTED : " +currentEntityId+" / "+entityIncarnationOrder.length, 12);
		votedText.scrollFactor.set(0, 0);
		add(votedText);
	}
	
	function placeEntity(name:String, data:Xml):Void
	{
		var x:Int = Std.parseInt(data.get("x"));
		var y:Int = Std.parseInt(data.get("y"));
		var id:Int = Std.parseInt(data.get("id"));
		
		
	
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

			}else if (name == "pl_crab")
			{
				p = new Crab(x, y);
			}else if (name == "pl_crabKing")
			{
				p = new CrabKing(x, y);
			}else if (name == "pl_greyFish")
			{
				p = new GreyFish(x, y);
			}
			p.ballotPaper = new BallotPaper(p.x, p.y, p);
			add(p.ballotPaper);
			playables.add(p);
		
			if (!incarnationOrderInited)
				entityIncarnationOrder.push(id);
				
			var current = entityIncarnationOrder[currentEntityId];
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
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		remainingTime -= elapsed;
		timerText.text = "TIME : " + Std.int(remainingTime);
		
		if (remainingTime <= 0)
			gameover("time is up!");
		
		FlxG.overlap(playables, goal, onPlayableReachGoal);
		FlxG.overlap(player, hostileDecorations, onPlayableTouchHostile);
		FlxG.overlap(player, playables, onPlayableTouchHostile);
		FlxG.collide(playables, walls);
		
		if (FlxG.keys.pressed.R)
			FlxG.switchState(new WinState());
		
	}
	
	function onPlayableTouchHostile(playable:Character, g:FlxSprite)
	{
		if(playable.state == Character.State.WAY_TO_VOTE)
			die();
	}
	
	function onPlayableReachGoal(playable:Character,g:FlxSprite) 
	{
		if (playable.state == Character.State.WAY_TO_VOTE && !dead)
		{
			playable.ballotPaper.validate();
			playable.state =Character.State.VOTED;
			
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
					new FlxTimer().start(1, function(_)
					{
						FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
						{
							incarnateNextEntity();
						});
					});
				}
			}else{
				playable.goBackToStartingPoint(walls);
			}
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
	
	
	function die()
	{
		if (dead)
			return;
			
		dead = true;
		lives--;
		FlxG.sound.play(AssetPaths.explosion__ogg);
		explode(player.ballotPaper);
		explode(currentHeart);
		stopRecording();
		FlxG.camera.shake(0.05, .2);
		
		if (lives == 0)
		{
			gameover();
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
	
	function gameover(reason:String = "no ballot paper remaining")
	{
		LoseState.reason = reason;
		new FlxTimer().start(1, function(_)
		{
			FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
			{
				FlxG.switchState(new LoseState());
			});
		});
	}
	
	function explode(target:FlxObject)
	{
		var explosionEmitter:FlxEmitter = explosionsEmitters.getFirstAvailable(FlxEmitter);
		if (explosionEmitter == null)
		{
			explosionEmitter = new FlxEmitter();
			explosionEmitter.makeParticles(2, 2, FlxColor.WHITE);
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