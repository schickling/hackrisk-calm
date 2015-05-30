//
//  ViewController.swift
//  StressWatch
//
//  Created by Johannes Schickling on 5/29/15.
//  Copyright (c) 2015 Johannes Schickling. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool)
    {
        //        HealthKit().observeHeartrate()
        HealthKit().startPollData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

