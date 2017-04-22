package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class LoseState extends FlxState
{
	override public function create():Void
	{
		super.create();
		var t = new FlxText(0, 0, 0, "YOU LOSE!!!", 22);
		t.screenCenter();
		add(t);
		
		var t = new FlxText(0, 0, 0, "SCORE : " + StringTools.lpad(Std.string(PlayState.score), "0", 5), 12);
		t.x = (FlxG.width / 2) - (t.width / 2);
		t.y = FlxG.height*2/3;
		add(t);
		
		var t = new FlxText(0, 0, 0, "Press any key to start playing", 12);
		t.x = (FlxG.width / 2) - (t.width / 2);
		t.y = FlxG.height*3/4;
		add(t);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.firstPressed() != -1)
			FlxG.switchState(new MenuState());
	}
}