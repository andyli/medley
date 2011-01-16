package medley.test;

import utest.Runner;
import utest.ui.Report;

import flash.Lib;

class Test {
	static function main():Void {
		#if nme
			Lib.create(init,800,600,24,0xFFFFFF,Lib.RESIZABLE);
		#else
			init();
		#end
	}

	static function init():Void {
		var runner = new Runner();
		runner.addCase(new TestChain());
		runner.addCase(new TestTween());
		#if flash
		runner.addCase(new TestMemory());
		#end
		Report.create(runner);
		runner.run();
	}
}
