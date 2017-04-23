package;

import flixel.FlxGame;
import flixel.util.FlxTimer;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxTimer.globalManager = new flixel.util.FlxTimer.FlxTimerManager();
		addChild(new FlxGame(640, 480, MenuState, 1, 60, 60, true));
		
	}
}