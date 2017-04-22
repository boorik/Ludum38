package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitter;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author vincent blanchet
 */

class Character extends FlxSprite
{
	static inline var GRAVITY = 5000;
	
	public var keys:flixel.input.keyboard.FlxKeyboard;
	public var mouse:flixel.input.mouse.FlxMouse;
	public var emitter:FlxEmitter;
	
	private var replay:MyReplay;
	public var isHumanControlled:Bool;
	public function new(?X:Float=0, ?Y:Float=0, ?graphic:FlxGraphicAsset="assets/images/stickman.png") 
	{
		super(X, Y);
		
		loadGraphic(graphic, true, 32, 32);
		animation.add("idle", [4, 5, 6, 7]);
		animation.add("walk_right", [0, 1, 2, 3]);
		animation.add("walk_left", [0, 1, 2, 3], 30, true, true);
		animation.play("idle");
		acceleration.y = GRAVITY;	
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
		animate();
		super.update(elapsed);
	}
	
	function checkInputs() 
	{
		velocity.x = 0;
		velocity.y = 0;
		if (keys.pressed.LEFT)
		{
			velocity.x -= 80;
		}else if (keys.pressed.RIGHT)
		{
			velocity.x += 80;
		}
		if (keys.pressed.UP)
		{
			velocity.y -= 80;
		}else if (keys.pressed.DOWN)
		{
			velocity.y += 80;
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
	
}