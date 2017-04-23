package;

/**
 * ...
 * @author vincent blanchet
 */
class Crab extends Character
{
	static inline var GRAVITY = 7000;
	public function new(X:Float,Y:Float) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.crab__png, true, 64, 32);
		animation.add("idle", [4, 5, 6, 7],5);
		animation.add("walk_right", [0, 1, 2, 3]);
		animation.add("walk_left", [0, 1, 2, 3], 30, true, true);
		animation.play("idle");
		
		setSize(52, 27);
		offset.set(6, 0);
		acceleration.y = GRAVITY;	
		
	}
	
}