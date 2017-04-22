package;

import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author vincent blanchet
 */
class Shrimp extends Character
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, AssetPaths.shrimp__png);
		setSize(20, 10);
		offset.set(6, 11);
	}
	
}