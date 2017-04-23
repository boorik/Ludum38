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
		
		var t = new FlxText(0, 0, 0, "[    Aquarium king election    ]", 22);
		t.x = (FlxG.width / 2) - (t.width / 2);
		t.y = 150;
		add(t);
		
		var f = new GreyFish(FlxG.width / 3, FlxG.height / 2);
		add(f);
		var bp = new BallotPaper(FlxG.width / 3, FlxG.height / 2, f);
		add(bp);
		
		var arrow = new FlxSprite(0, 0, AssetPaths.Arrow__png);
		arrow.x = f.x + f.width + 5;
		arrow.y = f.y;
		add(arrow);
		
		var bb = new BallotBox(FlxG.width* 2 / 3, FlxG.height  / 2 - 10);
		add(bb);
		
		var t = new FlxText(0, 0, 0, "You need to bring every animal to vote without\n touching each other, use arrow keys to move.\n 0 to disable sound.", 12);
		t.x = (FlxG.width / 2) - (t.width / 2);
		t.y = FlxG.height*2/3;
		add(t);
		
		var t = new FlxText(0, 0, 0, "Press any key to start playing", 12);
		t.x = (FlxG.width / 2) - (t.width / 2);
		t.y = FlxG.height*3/4+40;
		add(t);
		
		var t = new FlxText(0, 0, 0, "A game by Vincent Blanchet", 8);
		t.x = FlxG.width - t.width - 5;
		t.y = FlxG.height - t.height - 5;
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