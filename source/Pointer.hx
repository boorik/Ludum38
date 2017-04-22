package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author vincent blanchet
 */
class Pointer extends FlxSprite
{
	var target:flixel.FlxObject;
	public function new(?X:Float=0, ?Y:Float=0, target:flixel.FlxObject) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.pointer__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3],10);
		animation.play("idle");
		this.target = target;
	}
	
	override public function update(elapsed:Float)
	{
		this.x = target.x + (target.width - width) / 2;
		this.y = target.y - height;
		super.update(elapsed);
	}
	
}