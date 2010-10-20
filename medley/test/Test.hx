package medley.test;

import flash.system.Capabilities;
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
		trace(Capabilities.isDebugger);
		var runner = new Runner();
		runner.addCase(new TestChain());
		runner.addCase(new TestTween());
		runner.addCase(new TestMemory());
		Report.create(runner);
		runner.run();
	}
}
