package;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author vincent blanchet
 */
class GreyFish extends Character
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.greyFish__png, true, 64, 32);
		animation.add("idle", [4, 5, 6, 7],5);
		animation.add("walk_right", [0, 1, 2, 3]);
		animation.add("walk_left", [0, 1, 2, 3], 30, true, true);
		animation.play("idle");
		
		setSize(48, 22);
		offset.set(16, 5);
		
		maxAcceleration.y = 0;
		acceleration.y = maxAcceleration.y;
		
		maxVelocity.x = 120;
		maxVelocity.y = 120;
		
	}
	
}