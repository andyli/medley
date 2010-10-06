package medley.util;

class HashUtil {
	static public function clone<T>(hash:Hash<T>):Hash<T> {
		var newHash = new Hash<T>();
		for (key in hash.keys()) {
			newHash.set(key,hash.get(key));
		}
		return newHash;
	}

	static public function setFrom<T>(hash:Hash<T>, obj:Dynamic<T>):Hash<T> {
		for (key in Reflect.fields(obj)) {
			hash.set(key, Reflect.field(obj, key));
		}
		return hash;
	}
}
