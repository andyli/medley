package medley.test;

import utest.Runner;
import utest.ui.Report;

class Test {
	static public function main():Void {
		var runner = new Runner();
		runner.addCase(new TestChain());
		Report.create(runner);
		runner.run();
	}
}
