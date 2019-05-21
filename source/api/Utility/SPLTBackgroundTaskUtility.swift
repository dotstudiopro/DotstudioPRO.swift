//
//  SPLTBackgroundTaskUtility.swift
//  DotstudioAPI
//
//  Created by Ketan Sakariya on 19/05/18.
//

import Foundation
import UIKit

open class SPLTBackgroundTaskUtility: NSObject {
    
    public static let sharedInstance = SPLTBackgroundTaskUtility()
    
    //MARK: - Background Task Helper methods
    var backgroundTask: UIBackgroundTaskIdentifier?
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
            
            self.completeBackgroundTask()
        })
        return self.backgroundTask!
        //        return UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandl
        
    }
    
    func completeBackgroundTask() {
        if (self.backgroundTask != nil && self.backgroundTask != UIBackgroundTaskIdentifier.invalid) {
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
    }
}




