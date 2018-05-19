//
//  Discovery.swift

//
//  Created by  on 27/11/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit
import ObjectMapper

class Discovery: NSObject, Mappable {
    
    var ID: Int! = 0
    var placeId: Int! = 0
    var googlePlaceId: String?
    var userId: Int! = 0
    var userName: String?
    //var placePhoto: String?
    var userProfilePhoto: String?
    var latitude: Double! = 0.0
    var longitude: Double! = 0.0
    var discoveryDescription: String?
    var identity: String?
    var locationName: String?
    var status: Int! = 0
    var createdDate: Double! = 0.0
    var modifiedDate: Double! = 0.0
    var mediaData: Array<DiscoveryMediaData>! = []
    var taggedFriends: Array<DiscoveryTaggedFriend>! = []
    var placeName : String?
    var rating : Float! = 0.0
    
    //var placePhoto : GooglePlaceDetail.Photo!
    
    //var coordinate: CLLocationCoordinate2D?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ID <- map["discovery_id"]
        placeId <- map["place_id"]
        googlePlaceId <- map["google_place_id"]
       // placePhoto <- map["place_photo"]
        userId <- map["user_id"]
        userName <- map["user_name"]
        userProfilePhoto <- map["user_profile_photo"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        discoveryDescription <- map["description"]
        identity <- map["identity"]
        locationName <- map["location_name"]
        status <- map["status"]
        createdDate <- map["created_date"]
        modifiedDate <- map["modified_date"]
        mediaData <- map["media_data"]
        taggedFriends <- map["tagged_friends_obj"]
        placeName <- map["place_name"]
        rating  <- map["rating"]
        
       // coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
   
class DiscoveryMediaData: NSObject, Mappable {
    
    var ID: Int! = 0
    var discoveryId: Int! = 0
    var mediaFile: String?
    var mediaType: DiscoveryMediaType! = .image
    var mediaThumb: String?
    var status: Int! = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ID <- map["discovery_media_id"]
        discoveryId <- map["discovery_id"]
        mediaFile <- map["media_file"]
        mediaType <- (map["media_type"], EnumTransform())
        if mediaType == nil {
            mediaType = .image
        }
        mediaThumb <- map["media_thumb"]
        status <- map["status"]
    }
}

class DiscoveryTaggedFriend: NSObject, Mappable {
    
    var ID: Int! = 0
    var name: String?
    var profilePic: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ID <- map["id"]
        name <- map["name"]
        profilePic <- map["profile_pic"]
    }
}
}   
