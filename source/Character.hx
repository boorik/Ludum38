package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPath;

/**
 * ...
 * @author vincent blanchet
 */
enum State {
	WAY_TO_VOTE;
	VOTED;
	DEAD;
}
class Character extends FlxSprite
{
	static inline var GRAVITY = 5000;
	
	public var keys:flixel.input.keyboard.FlxKeyboard;
	public var mouse:flixel.input.mouse.FlxMouse;
	public var emitter:FlxEmitter;
	
	public var ballotPaper:BallotPaper;
	private var replay:MyReplay;
	public var isHumanControlled:Bool;
	private var startingPoint:FlxPoint;
	public var maxAcceleration:FlxPoint;
	public var state:State = WAY_TO_VOTE;
	
	public function new(?X:Float=0, ?Y:Float=0, ?graphic:FlxGraphicAsset="assets/images/stickman.png") 
	{
		super(X, Y);
		
		startingPoint = new FlxPoint(X, Y);
		if (graphic != null)
		{
			trace("Graphic not null");
			loadGraphic(graphic, true, 32, 32);
			animation.add("idle", [4, 5, 6, 7]);
			animation.add("walk_right", [0, 1, 2, 3]);
			animation.add("walk_left", [0, 1, 2, 3], 30, true, true);
			animation.play("idle");
		}
		maxAcceleration = FlxPoint.get(0, GRAVITY);
		acceleration.y = maxAcceleration.y;	
		
		maxVelocity.x = 80;
		maxVelocity.y = 80;
		
		immovable = false;
	}
	
	public function enableHumanControl()
	{
		keys = FlxG.keys;
		mouse = FlxG.mouse;
		
		isHumanControlled = true;
	}
	
	public function setReplay(mReplay:MyReplay)
	{
		replay = mReplay;
		keys = new flixel.input.keyboard.FlxKeyboard();
		mouse = new MyMouse();
		replay.keys = keys;
		replay.mouse = mouse;
		replay.rewind();
	}
	
	public function goBackToStartingPoint(map:FlxTilemap)
	{
		acceleration.y = 0;
		startingPoint.add(width / 2, height / 2);
		var pathPoints:Array<FlxPoint> = null;
		try{
			pathPoints = map.findPath(FlxPoint.get(x + width / 2, y + height / 2), startingPoint);
		}catch (e:Dynamic){
			trace(e);
		}
		if (pathPoints != null)
		{
			path = new FlxPath();
			path.start(pathPoints);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		if (replay != null)
			replay.playNextFrame();
			
		if (emitter != null)
		{
			emitter.setPosition(this.x, this.y);	
		}
		if(keys != null)
			checkInputs();
			
		if (path != null && !path.active)
		{
			acceleration.y = maxAcceleration.y;
			path.destroy();
			path = null;
			this.immovable = false;
		}
			
		super.update(elapsed);
		animate();
	}
	
	function checkInputs() 
	{
		velocity.x = 0;
		velocity.y = 0;
		if (keys.pressed.LEFT)
		{
			velocity.x -= maxVelocity.x;
		}else if (keys.pressed.RIGHT)
		{
			velocity.x += maxVelocity.x;
		}
		if (keys.pressed.UP)
		{
			velocity.y -= maxVelocity.y;
		}else if (keys.pressed.DOWN)
		{
			velocity.y += maxVelocity.y;
		}
	}
	
	function animate() 
	{
		if (velocity.x > 0)
			animation.play("walk_right");
		else if(velocity.x < 0)
			animation.play("walk_left");
		else
			animation.play("idle");
	}
	/*
	override public function draw():Void
	{
		super.draw();
		if (path != null && !path.finished)
		{
			drawDebug();
		}
	}
	*/
	
}