//
//  User.swift
//
//
//
//

import UIKit
import ObjectMapper

private let kUserID             = "user_id"
private let kUserName           = "username"
private let kFullName           = "first_name"
private let kEmail              = "email"
private let kProfilePic         = "profile_pic"
private let kSocialType         = "social_type"
private let kSocialID           = "social_id"

private let kCreatedDate        = "created_date"
private let kDOB                = "dob"
private let kPhone              = "phone"

private let kUserDeviceToken    = "device_token"
private let kUserDeviceType     = "device_type"
private let kUserServiceToken   = "service_token"
private let kUserInterest       = "interest"
private let kUserType           = "user_type"

class User: NSObject, NSCoding {

    var ID                  : Int?
    var userName            : String?
    var fullName            : String?
    var email               : String?
    var profilePic          : String?
    var socialType          : String?
    var socialID            : String?
    
    var createdDate         : String?
    var dob                 : String?
    var phone               : String?
    
    var deviceToken         : String! = ""
    var deviceType          : String! = "ios"
    var serviceToken        : String! = ""
    var userType            : String! = ""
    //var arrInterest         : [MasterList]! = []
    
    public init(dict : [String : Any]) {
        self.ID                 = dict[kUserID] as? Int
        self.userName           = dict[kUserName] as? String
        self.fullName           = dict[kFullName] as? String
        self.email              = dict[kEmail] as? String
        self.profilePic         = dict[kProfilePic] as? String
        self.socialType         = dict[kSocialType] as? String
        self.socialID           = dict[kSocialID] as? String
        self.createdDate        =  dict[kCreatedDate] as? String
        self.dob                =  dict[kDOB] as? String
        self.phone              =  dict[kPhone] as? String
        self.deviceType         =  dict[kUserDeviceToken] as? String
        self.serviceToken       =  dict[kUserServiceToken] as? String
        self.userType           = dict[kUserType] as? String
        for dictAttribute in dict[kUserInterest] as? Array<Dictionary<String, Any>> ?? [] {
//            if let masterlist = Mapper<MasterList>().map(JSON: dictAttribute) {
//                arrInterest.append(masterlist)
//            }
        }
    }

    //required public
    required init?(coder aDecoder: NSCoder) {
        
        self.ID                = aDecoder.decodeObject(forKey: kUserID) as? Int ?? 0
        self.userName          = aDecoder.decodeObject(forKey: kUserName) as? String
        self.fullName          = aDecoder.decodeObject(forKey: kFullName) as? String
        self.email             = aDecoder.decodeObject(forKey: kEmail) as? String
        self.profilePic        = aDecoder.decodeObject(forKey: kProfilePic) as? String
        self.socialType        = aDecoder.decodeObject(forKey: kSocialType) as? String
        self.socialID          = aDecoder.decodeObject(forKey: kSocialID) as? String
        
        self.createdDate       = aDecoder.decodeObject(forKey:kCreatedDate) as? String
        self.dob               = aDecoder.decodeObject(forKey:kDOB) as? String
        self.phone             = aDecoder.decodeObject(forKey:kPhone) as? String
        
        self.serviceToken      = aDecoder.decodeObject(forKey: kUserServiceToken) as? String
        self.deviceToken       = aDecoder.decodeObject(forKey: kUserDeviceType) as? String
        self.deviceType        = aDecoder.decodeObject(forKey: kUserDeviceType) as? String
        self.userType          = aDecoder.decodeObject(forKey: kUserType) as? String
       // self.arrInterest       = aDecoder.decodeObject(forKey: kUserInterest) as? [MasterList]

    }

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.ID, forKey: kUserID)
        aCoder.encode(self.userName, forKey: kUserName)
        aCoder.encode(self.fullName, forKey: kFullName)
        aCoder.encode(self.email, forKey: kEmail)
        aCoder.encode(self.profilePic, forKey: kProfilePic)
        aCoder.encode(self.socialType, forKey: kSocialType)
        aCoder.encode(self.socialID, forKey: kSocialID)
        aCoder.encode(self.serviceToken, forKey: kUserServiceToken)
        aCoder.encode(self.userType, forKey: kUserType)
        aCoder.encode(self.deviceToken, forKey: kUserDeviceToken)
        aCoder.encode(self.deviceType, forKey: kUserDeviceType)
        aCoder.encode(self.createdDate,forKey:kCreatedDate)
        aCoder.encode(self.dob,forKey:kDOB)
        aCoder.encode(self.phone,forKey:kPhone)
       // aCoder.encode(self.arrInterest,forKey:kUserInterest)
    }

    func save() -> Void {
        StandardUserDefaults.setCustomObject(obj: self, key: K.Key.LoggedInUser)
    }
    
    class func delete() -> Void {
        StandardUserDefaults.removeObject(forKey: K.Key.LoggedInUser)
        StandardUserDefaults.synchronize()
    }
    
    public static func loggedInUser() -> User? {
        let user  = StandardUserDefaults.getCustomObject(key: K.Key.LoggedInUser) as? User
        return user
    }
}
