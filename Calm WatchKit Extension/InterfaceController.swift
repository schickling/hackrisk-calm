//
//  InterfaceController.swift
//  Calm WatchKit Extension
//
//  Created by Johannes Schickling on 5/30/15.
//  Copyright (c) 2015 Optonaut. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON


class InterfaceController: WKInterfaceController {
    
    var timer: NSTimer?

//    @IBOutlet weak var test: WKInterfaceLabel!
    @IBOutlet weak var exerciseImage: WKInterfaceImage!
    @IBOutlet weak var stressLevelImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        stressLevelImage.setImageNamed("level")
        stressLevelImage.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: 150),
            duration: 6,
            repeatCount: 0)
        
        exerciseImage.setImageNamed("exercise")
        exerciseImage.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: 610),
            duration: 24.4,
            repeatCount: 0)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        timer?.invalidate()
//        timer = nil
    }

    func fetchData() {
        let url = NSURL(string: "http://\(Constants.SERVER_IP)/stress")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            let stress = json["stress"].doubleValue;
            let stressString: String = String(format:"%.1f", stress)

            if(stress > 0.8) {
                //Do notification
            }
            //self.test.setText(stress)
        }
        
        task.resume()
    }

}
