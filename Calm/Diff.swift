
import Foundation

class Diff : NSObject
{
	var state: Double = 0

	func push(x: Double) -> Double {
		var dx = state - x;
		state = x;
		return dx;
	}
}