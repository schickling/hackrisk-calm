//
//  HealthKitHelper.swift
//
//
//  Created by Johannes Schickling on 5/30/15.
//
//

import Foundation
import HealthKit

class HealthKit : NSObject
{
    let storage = HKHealthStore()
    
    override init()
    {
        super.init()
        checkAuthorization()
    }
    
    func checkAuthorization() -> Bool
    {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = Set([HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate),
                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyTemperature),
                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic),
                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierRespiratoryRate)])
            
            // Now we can request authorization for step count data
            storage.requestAuthorizationToShareTypes(nil, readTypes: steps) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    func fetchAll()
    {
        fetchData(HKQuantityTypeIdentifierHeartRate)
        fetchData(HKQuantityTypeIdentifierBodyTemperature)
        fetchData(HKQuantityTypeIdentifierBloodPressureSystolic)
        fetchData(HKQuantityTypeIdentifierRespiratoryRate)
    }
    
    func fetchData(identifier: String)
    {
        let type = HKSampleType.quantityTypeForIdentifier(identifier)
        
        let today = NSDate()
        let lastSecond = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitSecond,
            value: -10,
            toDate: today,
            options: NSCalendarOptions(0))
        let predicate = HKQuery.predicateForSamplesWithStartDate(lastSecond, endDate: today, options: .None)
        
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) {
            query, results, error in
            
            if error != nil {
                println("Error fetching " + identifier)
                println(error.localizedDescription)
                abort()
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh:mm:ss"
            
            for result in results {
                
                print(identifier)
                print(", ")
                print(formatter.stringFromDate(result.startDate))
                print(", ")
                println(result.quantity)
                
                let unit = HKUnit.countUnit().unitDividedByUnit(HKUnit.secondUnit())
                let quantity = result.quantity!.doubleValueForUnit(unit)
                let params = ["s": quantity] as Dictionary<String, Double>
                let url = NSURL(string: "http://\(Constants.SERVER_IP)/heart")
                let request = NSMutableURLRequest(URL: url!)
                
                request.HTTPMethod = "POST"
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: nil)
                
                task.resume()
            }
        }
        
        storage.executeQuery(query)
    }
    
    func startPollData() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("fetchAll"), userInfo: nil, repeats: true)
    }
    
}