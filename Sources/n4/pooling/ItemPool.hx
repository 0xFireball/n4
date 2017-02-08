package n4.pooling;

import n4.NBasic;

class ItemPool<T:NBasic> {
	public var items:Array<T> = new Array<T>();

	public function new() {

	}

	public function putWeak(Object:T) {
		items.push(Object);
	}

	public function getWeak():T {
		// get item
		var item = items.pop();
		if (item == null) return null;
		// resurrect item
		item.initialize();
		return item;
	}

	public function empty() {
		items.splice(0, items.length);
	}
}