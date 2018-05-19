//
//  ModelData.swift
//
//  Created by   on 06/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation
import GoogleMaps
public final class ModelData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let googlePlaceId = "google_place_id"
    static let placeId = "place_id"
    static let descriptionValue = "description"
    static let createdDate = "created_date"
    static let identity = "identity"
    static let rating = "rating"
    static let mediaData = "media_data"
    static let modifiedDate = "modified_date"
    static let userProfilePhoto = "user_profile_photo"
    static let placeName = "place_name"
    static let latitude = "latitude"
    static let status = "status"
    static let placePhoto = "place_photo"
    static let locationName = "location_name"
    static let discoveryId = "discovery_id"
    static let taggedFriendsObj = "tagged_friends_obj"
    static let title = "title"
    static let userName = "user_name"
    static let userId = "user_id"
    static let longitude = "longitude"
    static let mediaCount = "media_count"
    static let discoveryDate = "discovery_date"
    
  }

  // MARK: Properties
  public var googlePlaceId: String?
  public var placeId: Int?
  public var descriptionValue: String?
  public var createdDate: Int?
  public var identity: String?
  public var rating: Int?
  public var mediaData: [ModelMediaData]?
  public var modifiedDate: Int?
  public var userProfilePhoto: String?
  public var placeName: String?
  public var latitude: Double?
  public var status: Int?
  public var placePhoto: ModelPlacePhoto?
  public var locationName: String?
  public var discoveryId: Int?
  public var taggedFriendsObj: [ModelTaggedFriendsObj]?
  public var title: String?
  public var userName: String?
  public var userId: Int?
  public var longitude: Double?
  public var mediaCount: Int?
  public var discoveryDate: String?

  public var marker = GMSMarker()
  public  var coordinate: CLLocationCoordinate2D?
    var bounds = GMSCoordinateBounds()


  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    googlePlaceId = json[SerializationKeys.googlePlaceId].string
    placeId = json[SerializationKeys.placeId].int
    descriptionValue = json[SerializationKeys.descriptionValue].string
    createdDate = json[SerializationKeys.createdDate].int
    identity = json[SerializationKeys.identity].string
    rating = json[SerializationKeys.rating].int
    if let items = json[SerializationKeys.mediaData].array { mediaData = items.map { ModelMediaData(json: $0) } }
    modifiedDate = json[SerializationKeys.modifiedDate].int
    userProfilePhoto = json[SerializationKeys.userProfilePhoto].string
    placeName = json[SerializationKeys.placeName].string
    latitude = json[SerializationKeys.latitude].double
    status = json[SerializationKeys.status].int
    placePhoto = ModelPlacePhoto(json: json[SerializationKeys.placePhoto])
    locationName = json[SerializationKeys.locationName].string
    discoveryId = json[SerializationKeys.discoveryId].int
    if let items = json[SerializationKeys.taggedFriendsObj].array { taggedFriendsObj = items.map { ModelTaggedFriendsObj(json: $0) } }
    title = json[SerializationKeys.title].string
    userName = json[SerializationKeys.userName].string
    userId = json[SerializationKeys.userId].int
    longitude = json[SerializationKeys.longitude].double
    mediaCount = json[SerializationKeys.mediaCount].int
    discoveryDate = json[SerializationKeys.discoveryDate].string
   
    coordinate = CLLocationCoordinate2DMake(self.latitude!, self.longitude!)

    marker.position = coordinate!
    bounds = bounds.includingCoordinate(marker.position)

  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = googlePlaceId { dictionary[SerializationKeys.googlePlaceId] = value }
    if let value = placeId { dictionary[SerializationKeys.placeId] = value }
    if let value = descriptionValue { dictionary[SerializationKeys.descriptionValue] = value }
    if let value = createdDate { dictionary[SerializationKeys.createdDate] = value }
    if let value = identity { dictionary[SerializationKeys.identity] = value }
    if let value = rating { dictionary[SerializationKeys.rating] = value }
    if let value = mediaData { dictionary[SerializationKeys.mediaData] = value.map { $0.dictionaryRepresentation() } }
    if let value = modifiedDate { dictionary[SerializationKeys.modifiedDate] = value }
    if let value = userProfilePhoto { dictionary[SerializationKeys.userProfilePhoto] = value }
    if let value = placeName { dictionary[SerializationKeys.placeName] = value }
    if let value = latitude { dictionary[SerializationKeys.latitude] = value }
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = placePhoto { dictionary[SerializationKeys.placePhoto] = value.dictionaryRepresentation() }
    if let value = locationName { dictionary[SerializationKeys.locationName] = value }
    if let value = discoveryId { dictionary[SerializationKeys.discoveryId] = value }
    if let value = taggedFriendsObj { dictionary[SerializationKeys.taggedFriendsObj] = value.map { $0.dictionaryRepresentation() } }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = userName { dictionary[SerializationKeys.userName] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = longitude { dictionary[SerializationKeys.longitude] = value }
    if let value = mediaCount { dictionary[SerializationKeys.mediaCount] = value }
    if let value = discoveryDate { dictionary[SerializationKeys.discoveryDate] = value }
    return dictionary
  }

}
