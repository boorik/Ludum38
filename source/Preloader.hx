package;
import flixel.FlxG;
import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * ...
 * @author vincent blanchet
 */
@:bitmap("assets/images/heart.png")
private class GraphicLogo extends BitmapData {}

class Preloader extends flixel.system.FlxBasePreloader
{
	var _text:flash.text.TextField;
	var logo:Bitmap;
	var progressBar:Bitmap;
	var _buffer:openfl.display.Sprite;

	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{
		super(MinDisplayTime, AllowedURLs);
	}

	override private function create():Void
	{
		_buffer = new Sprite();
		//_buffer.scaleX = _buffer.scaleY = 2;
		addChild(_buffer);
		_width = Std.int(Lib.current.stage.stageWidth / _buffer.scaleX);
		_height = Std.int(Lib.current.stage.stageHeight / _buffer.scaleY);
		_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, 0x00345e)));

		var logo = createBitmap(GraphicLogo, function(logoBmp:Bitmap)
		{
			logoBmp.x = (Lib.current.stage.stageWidth - logoBmp.width) * .5;
			logoBmp.y = (Lib.current.stage.stageHeight - logoBmp.height) * .5;
		});
		logo.smoothing = true;
		//logo.alpha = 0;
		_buffer.addChild(logo);

		progressBar = new Bitmap(new BitmapData(200, 7, false, 0xFFFFFF));
		progressBar.x = (Lib.current.stage.stageWidth - progressBar.width) * .5;
		progressBar.y = (Lib.current.stage.stageHeight - progressBar.height) * .5 + 100;
		_buffer.addChild(progressBar);

		_text = new TextField();
		_text.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 8, 0xFFFFFF);
		_text.embedFonts = true;
		_text.selectable = false;
		_text.multiline = false;
		_text.autoSize = TextFieldAutoSize.CENTER;
		_text.x = (Lib.current.stage.stageWidth - _text.width) * .5;
		_text.y = progressBar.y - 30;

		_buffer.addChild(_text);

		var bitmap = new Bitmap(new BitmapData(_width, _height, false, 0xffffff));
		var i:Int = 0;
		var j:Int = 0;
		while (i < _height)
		{
			j = 0;
			while (j < _width)
			{
				bitmap.bitmapData.setPixel(j++, i, 0);
			}
			i += 2;
		}
		bitmap.blendMode = BlendMode.OVERLAY;
		bitmap.alpha = 0.25;
		_buffer.addChild(bitmap);

		super.create();
	}

	override private function destroy():Void
	{
		/*
		removeChild(logo);
		removeChild(_text);
		removeChild(_buffer);
		logo = null;
		_text = null;
		super.destroy();
		*/
	}

	override public function update(Percent:Float):Void
	{
		progressBar.scaleX = Percent;

		_text.text = Std.int(Percent * 100) + "%";
	}

}