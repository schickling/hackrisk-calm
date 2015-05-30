
import Foundation

class MovingAverage : NSObject
{
	var buffer: [Double]
	var count: Int
	var pos: Int

	init(window: Int) {
		self.count = 0
		self.pos = 0
		self.buffer = [Double](count: window, repeatedValue: 0.0)
	}

	func push(v: Double) -> Double {
		buffer[self.pos] = v
		self.pos++;
		if(self.pos > buffer.count) {
			self.pos = 0;
		}

		var avg: Double

		for(i in 0..(self.count)) {
			avg += self.buffer[i]
		}

		avg = avg / self.count

		return avg
	}
	
}