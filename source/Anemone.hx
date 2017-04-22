package;

/**
 * ...
 * @author vincent blanchet
 */
class Anemone extends flixel.FlxSprite
{

	public function new(X:Float=0,Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.anemone__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3],10);
		animation.play("idle");
	}
	
}