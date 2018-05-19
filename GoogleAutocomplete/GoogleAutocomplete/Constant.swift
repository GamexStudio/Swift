//
//  Constant.swift
//
//
//

import UIKit
import Foundation

public let BASE_URL       = ""


struct K {
    static let GOOGLE_API_KEY   = "AIzaSyDbgcpNLTa95bNM-qGsKpwZGZ9LZ0tJPoo" //For
    
    static let HugeIntValue : Int = 99999
    
    
    //struct: Contains all the URLs
    struct URL {
        
        
        static let LOGIN                        = BASE_URL + "user/login"


        
        static let GOOGLE_PLACE_PHOTO  = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference="
        static let GOOGLE_NEAR_BY_SEARCH = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=500&"
        static let GOOGLE_TEXT_SEARCH = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
    
    }
        
    struct Notification {
        static let CartItemCountDidChange         = "CartItemCountDidChangeNotification"
    }
    
    //struct: Contains All notification types
    struct NotificationType {
        static let NewRequest                   = ""
    }

    //struct: Contains Keys
    struct Key {
        
        static let Data                         = "data"
        static let LoggedInUser                 = "LoggedInUserKey"
        static let DeviceToken                  = "DeviceToken"
        static let RecentSearchString           = "RecentSearchKey"
        
        static let discoveryImage               = "imageKey"
        static let discoveryMediaUrl            = "videoUrlKey"
        static let discoveryMediaType           = "mediaTypeKey"
        
    }
    
    //struct: Contains All the messages shown to user
    struct Message {
        static let OK                           = "OK"
    }
    
    //struct: Contains Color used in application
    struct Color {
        //static let white                   = UIColor(hexString: "FFFFFF")!
        
    }
    
    
    //struct: Contains all date and time format
    
    struct DateFormat {
        static let common                   = "MM/dd/yyyy"
        static let birthDate                = "MM/dd/yyyy"
        static let time                     = "h:mm a"
        static let time24Hours              = "H:mm"
    }
    
 
    
    public static var topBarHeight : CGFloat! {
        return Display.typeIsLike == .iphoneX ? 84.0 : 64.0
    }
    
    public static func googlePlacePhotoUrl(photoRefrence : String!) -> String {
        return String(format: "%@%@&key=%@", URL.GOOGLE_PLACE_PHOTO, photoRefrence, K.GOOGLE_API_KEY)
    }
    
    
}



enum PlaceType : Int {
    case favorite    = 1
    case visited     = 2
    case wishList    = 3
}



enum DiscoveryMediaType : String {
    case image    = "image"
    case video    = "video"
    case audio    = "audio"
}


public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    static let iphone7 = iphone6
    static let iphone7plus = iphone6plus
    static let iphone8 = iphone6
    static let iphone8plus = iphone6plus
    case iphoneX
}

public final class Display {
    class var width:CGFloat { return UIScreen.main.bounds.size.width }
    class var height:CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength:CGFloat { return max(width, height) }
    class var minLength:CGFloat { return min(width, height) }
    class var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina:Bool { return UIScreen.main.scale >= 2.0 }
    class var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if phone && maxLength == 812 {
            return .iphoneX
        }
        return .unknown
    }
}
