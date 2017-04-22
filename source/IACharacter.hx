package;

import flixel.addons.util.FlxFSM;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author vincent blanchet
 */
class IACharacter extends Character
{
	public var fsm:FlxFSM<flixel.FlxSprite>;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		fsm = new FlxFSM<flixel.FlxSprite>(this);
	}
	
	override public function update(elapsed:Float):Void
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}
	
	override public function destroy():Void
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
	
}