package;

import flixel.system.replay.FlxReplay;
import flixel.system.replay.FrameRecord;

/**
 * ...
 * @author vincent blanchet
 */
class MyReplay extends FlxReplay
{
	public var keys:flixel.input.keyboard.FlxKeyboard;
	public var mouse:flixel.input.mouse.FlxMouse;
	/**
	 * Get the current frame record data and load it into the input managers.
	 */
	override public function playNextFrame():Void
	{
		mouse.reset();
		keys.reset();
		
		if (_marker >= frameCount)
		{
			finished = true;
			return;
		}
		if (_frames[_marker].frame != frame++)
		{
			return;
		}
		
		var fr:FrameRecord = _frames[_marker++];
		
		#if FLX_KEYBOARD
		if (fr.keys != null)
		{
			keys.playback(fr.keys);
		}
		#end
		
		#if FLX_MOUSE
		if (fr.mouse != null)
		{
			mouse.playback(fr.mouse);
		}
		#end
	}
	
}