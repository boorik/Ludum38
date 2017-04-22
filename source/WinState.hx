package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class WinState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, 0, "YOU WIN !!!", 22);
		t.screenCenter();
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.firstPressed() != -1)
			FlxG.switchState(new MenuState());
	}
}