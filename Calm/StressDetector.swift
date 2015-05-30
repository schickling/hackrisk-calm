
import Foundation

class StressDetector : NSObject
{
	var isMoving: Bool
 	let accFilter = MovingAverage(50)
 	let heartFilter = MovingAverage(5)
	let accDiff = [Diff](count: 3, initialValue: Diff())

	let movementThreshold = 0.4
	var heartrateNominal = 1.15
	var heartrateThreshold = 0.25

	var movement: Double
	var stress: Double

	/// Push [x, y, z] vector of Accellerometer data.
	/// Returns true if the individual is moving around a lot
	func pushAccdata(vec: [Double]) -> Bool {

		var filtered = [0.0, 0.0, 0.0];
		var dist = 0;

		for(i in 0..2) {
			filtered[i] = accDiff[i].push(vec[i])
			dist += filtered[i] * filtered[i]
		}

		dist = sqrt(dist)

		self.movement = accFilter.push(dist)

		self.isMoving = self.movement > movementThreshold

		return isMoving
	}

	/// Push r, the heart rate in beats/second
	/// Returns the stress level s.
	/// s < 0 Relaxed
	/// s ~ 0 Nominal
	/// s >= 1 Stress
	func pushHeartrate(r: Double) -> Double {
		var f = heartFilter.push(r)

		self.stress = (f - (heartrateNominal + heartrateThreshold)) / heartrateThreshold

		return self.stress
	}
}