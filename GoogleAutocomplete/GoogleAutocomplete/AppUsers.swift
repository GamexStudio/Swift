//
//  AppUsers.swift
//  MapAll
//
//  Created by  V on 14/11/17.
//  Copyright © 2017 Harry. All rights reserved.
//

import UIKit
import ObjectMapper

class AppUsers: NSObject, Mappable {
    var id: Int! = 0
    var firstName: String?
    var lastName: String?
    var profilePic: String?
    var email : String?
    var socialType          : String?
    var socialID            : String?
    var dob                 : String?
    var phone               : String?
    //var arrInterest         : [MasterList]! = []
    var rating              : Float! = 0.0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["user_id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        profilePic <- map["profile_pic"]
        email <- map["email"]
        rating <- map["rating"]
        //arrInterest <- map["interest"]
        profilePic <- map["profile_pic"]
    }
}
