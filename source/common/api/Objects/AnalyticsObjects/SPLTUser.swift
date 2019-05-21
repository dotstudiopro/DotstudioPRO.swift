//
//  SPLTUser.swift
//  DotstudioPRO
//
//  Created by ketan on 08/06/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import CoreLocation

open class SPLTUser: NSObject {
    public static let sharedInstance = SPLTUser()
    
    open var userId: String?
    open var isocode: String = SPLTRouter.COUNTRY_CODE
    open var geolocation: String?
    
    #if os(iOS)
        open var clPlacemark: CLPlacemark?
        open var location: CLLocation?

    #endif
    
    override init() {
        super.init()
        //self.updateLocation()
        if (userId == nil) {
            self.updateUserId()
        }
    }
    
    open func isLoggedinUser() -> Bool {
        if (SPLTRouter.strClientToken != nil) {
            return true
        }
        return false
    }
    open func updateUserId() {
        if let strClientToken = SPLTRouter.strClientToken {
            do {
                let segments = strClientToken.components(separatedBy: ".")
                if segments.count == 3 {
                    if let payloadData = base64decode(segments[1]) {
                        if let jsonDict = try JSONSerialization.jsonObject(with: payloadData, options: .mutableContainers) as? [String: AnyObject] {
                            if let contextDict = jsonDict["context"] as? [String: AnyObject] {
                                if let strCustomerId = contextDict["id"] as? String {
                                    self.userId = strCustomerId
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Failed to decode JWT: \(error)")
            }
        } else {
            self.userId = nil
        }
    }
    
//    func updateLocation() {
//        #if os(iOS)
//            LocationManager.shared.observeLocations(.Block, frequency: .OneShot, onSuccess: { location in
//                // location contain your CLLocation object
//                print(location)
//                self.location = location
//                self.updatePlaceMark()
//            }) { error in
//                // Something went wrong. error will tell you what
//                print(error.description)
//            }
//        #endif
//    }
//    
//    func updatePlaceMark() {
//        #if os(iOS)
//            if let location = self.location {
//                LocationManager.shared.reverseLocation(service: .Apple, location: location, onSuccess: { clPlacemark in
//                        self.clPlacemark = clPlacemark
//                    }, onError: { error in
//                        // Something went wrong. error will tell you what
//                        print(error.description)
//                })
//            }
//        #endif
//    }
    
    
    open func toJsonDict() -> [String: AnyObject] {
        var jsonDict: [String: AnyObject] = [:]
        if let userId = self.userId {
            jsonDict["id"] = userId as AnyObject?
        }
        if let geolocation = self.geolocation {
            jsonDict["geometry"] = geolocation as AnyObject?
        }
        var locationDict: [String: AnyObject] = [
            "isocode" : self.isocode as AnyObject
        ]
        #if os(iOS)

            if let clPlacemark = self.clPlacemark {
                if let strCountry = clPlacemark.country {
                    locationDict["country"] = strCountry as AnyObject?
                }
                if let strState = clPlacemark.administrativeArea {
                    locationDict["state"] = strState as AnyObject?
                }
                if let strCity = clPlacemark.locality {
                    locationDict["city"] = strCity as AnyObject?
                }
                if let strPostal = clPlacemark.postalCode {
                    locationDict["postal"] = strPostal as AnyObject?
                }
            }
            
            
//            "country": "Canada",
//            "state": "BC",
//            "city": "Vancouver",
//            "postal": "V5V0A0",
            
            
//            if let location: CLLocation = self.location {
//                locationDict["geometry"] = ["coordinates" :
//                    [location.coordinate.longitude,
//                        location.coordinate.latitude
//                    ]
//                ]
//            }
        #endif
        jsonDict["location"] = locationDict as AnyObject?
        return jsonDict
    }
}



//    "user": {
//        "id": "123456789",
//        "ua": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
//        "location": {
//            "isocode": "CA",
//            "country": "Canada",
//            "state": "BC",
//            "city": "Vancouver",
//            "postal": "V5V0A0",
//            "geometry": {
//                "coordinates": [49.2827, 123.1207]
//            }
//        }
//    }
