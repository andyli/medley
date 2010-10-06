package medley.easing;

class Circ implements haxe.Public
{
	inline static function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return -c * ( Math.sqrt( 1 - ( t /= d ) * t ) - 1 ) + b;
	}
	
	inline static function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		return c * Math.sqrt( 1 - ( t = t / d - 1 ) * t ) + b;
	}
	
	inline static function easeInOut ( t : Float, b : Float, c : Float, d : Float ) : Float
	{
		if ( ( t /= d / 2 ) < 1 )
			return -c / 2 * ( Math.sqrt( 1 - t * t ) - 1 ) + b;
		return c / 2 * ( Math.sqrt( 1 - ( t -= 2 ) * t ) + 1 ) + b;
	}
}
