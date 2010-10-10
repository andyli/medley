package medley.util;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

class PropSetter {

	/*
		Set target's properties based on the input object.
	*/
	static public function setProp(target:Dynamic, properties:Dynamic):Void {
		for (prop in Reflect.fields(properties)){
			Reflect.setField(target, prop, Reflect.field(properties,prop));
		}
	}
}

class PropSetterMacros {

	/*
		Set target's properties based on the input object.
	*/
	#if !macro @:macro #end //when running in macros, it takes Expr variables but not real expression.
	static public function setProp(target:Expr, properties:Expr):Expr {
		var pos = Context.currentPos();
        var defSet = [];
        switch (properties.expr) {
        		case EObjectDecl(fields):
				for (prop in fields){
					defSet.push({
									expr:EBinop(OpAssign, {expr:EField(target, prop.field), pos:pos}, prop.expr),
									pos:pos
								});
				}
        		default:
        			throw "properties should be a object declaration.";
        }
        
        return 
        {
        		expr: EBlock(defSet), 
			pos: pos 
		};
	}

	/*
		Return a function that set target's properties based on the input object.
	*/
	@:macro 
	static public function setPropFn(target:Expr, properties:Expr):Expr {
        var pos = Context.currentPos();
        return 
        {
        		expr: EFunction({
				args: [],
				ret: null,
				expr: setProp(target, properties)
			}), 
			pos: pos 
		};
    }
}
