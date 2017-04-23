package;

/**
 * ...
 * @author vincent blanchet
 */
class CrabKing extends Character
{
	static inline var GRAVITY = 7000;
	public function new(X:Float,Y:Float) 
	{
		super(X, Y, null);
		
		loadGraphic(AssetPaths.crabKing__png, true, 64, 32);
		animation.add("idle", [4, 5, 6, 7],5);
		animation.add("walk_right", [0, 1, 2, 3]);
		animation.add("walk_left", [0, 1, 2, 3], 30, true, true);
		animation.play("idle");
		
		setSize(52, 27);
		offset.set(6, 0);
		maxAcceleration.y = GRAVITY;
		acceleration.y = maxAcceleration.y;
		
		maxVelocity.x = 120;
		
	}
	
}