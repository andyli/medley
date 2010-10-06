package medley.ease;

interface IEase {
	public function getStartFeathers():Array<String>;
	public function getEndFeathers():Array<String>;

	public function getFunction(startFeather:String,endFeather:String):Dynamic;
}
