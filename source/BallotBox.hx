package;

/**
 * ...
 * @author vincent blanchet
 */
class BallotBox extends flixel.FlxSprite
{

	public function new(X:Float,Y:Float) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.ballotbox__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3]);
		animation.play("idle");
		
	}
	
}