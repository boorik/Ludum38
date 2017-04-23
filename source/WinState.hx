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
		
		PlayState.remainingTime = Std.int(PlayState.remainingTime);
		
		var t = new FlxText(0, 0, 0, "YOU WIN !!!", 22);
		t.screenCenter();
		add(t);
		
		var tr = new FlxText(0, 0, 0, "TIME REMAINING : " + PlayState.remainingTime, 12);
		tr.x = (FlxG.width / 2) - (tr.width / 2);
		tr.y = FlxG.height*2/3;
		add(tr);
		
		var s = new FlxText(0, 0, 0, "SCORE : " + PlayState.score , 12);
		s.x = (FlxG.width / 2) - (s.width / 2);
		s.y = tr.y+tr.height+10;
		add(s);
		
		var ts = new FlxText(0, 0, 0, "TOTAL SCORE : " + PlayState.remainingTime+" + "+PlayState.score+" = "+(PlayState.remainingTime+PlayState.score), 12);
		ts.x = (FlxG.width / 2) - (ts.width / 2);
		ts.y = s.y+s.height+30;
		add(ts);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.firstPressed() != -1)
			FlxG.switchState(new MenuState());
	}
}