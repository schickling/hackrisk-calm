<<<<<<< HEAD:Constants.swift
//
//  Constants.swift
//  Calm
//
//  Created by Johannes Schickling on 5/30/15.
//  Copyright (c) 2015 Optonaut. All rights reserved.
//

import Foundation

struct Constants {
    static var SERVER_IP = "172.16.4.43:18000"
=======

import Foundation

class Diff : NSObject
{
	var state: Double = 0

	func push(x: Double) -> Double {
		var dx = state - x;
		state = x;
		return dx;
	}
>>>>>>> 9f837c7cb271ecd76038f02454382906f9199029:Calm/Diff.swift
}