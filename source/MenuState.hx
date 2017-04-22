package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		this.camera.bgColor = 0xFF0080C0;
		
		var t = new FlxText(0, 0, 0, "Aquarium king election", 22);
		t.screenCenter();
		add(t);
		
		var t = new FlxText(0, 0, 0, "You need to bring every animal to vote without\n touching each other, use arrow keys to move.", 12);
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
		{
			PlayState.resetRecords();
			FlxG.switchState(new PlayState());
		}
	}
}