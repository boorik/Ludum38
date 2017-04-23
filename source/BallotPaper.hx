package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author vincent blanchet
 */
class BallotPaper extends FlxSprite
{
	var target:flixel.FlxObject;
	public function new(?X:Float=0, ?Y:Float=0, target:flixel.FlxObject) 
	{
		super(X, Y, AssetPaths.ballotpaper__png);
		this.target = target;
	}
	
	override public function update(elapsed:Float)
	{
		if (target != null)
		{
			this.x = target.x;
			this.y = target.y+target.height;
		}
		super.update(elapsed);
	}
	
	/**
	 * ballot paper in box!
	 */
	public function validate()
	{
		FlxG.sound.play(AssetPaths.voted__ogg);
		destroy();
	}
	
	override public function destroy():Void
	{
		target = null;
		super.destroy();
	}
}