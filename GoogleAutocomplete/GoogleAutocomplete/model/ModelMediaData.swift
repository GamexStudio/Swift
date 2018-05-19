//
//  ModelMediaData.swift
//
//  Created by   on 06/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ModelMediaData {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let discoveryId = "discovery_id"
    static let mediaThumb = "media_thumb"
    static let mediaFile = "media_file"
    static let discoveryMediaId = "discovery_media_id"
    static let duration = "duration"
    static let mediaType = "media_type"
  }

  // MARK: Properties
  public var status: Int?
  public var discoveryId: Int?
  public var mediaThumb: String?
  public var mediaFile: String?
  public var discoveryMediaId: Int?
  public var duration: Int?
  public var mediaType: String?

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
    status = json[SerializationKeys.status].int
    discoveryId = json[SerializationKeys.discoveryId].int
    mediaThumb = json[SerializationKeys.mediaThumb].string
    mediaFile = json[SerializationKeys.mediaFile].string
    discoveryMediaId = json[SerializationKeys.discoveryMediaId].int
    duration = json[SerializationKeys.duration].int
    mediaType = json[SerializationKeys.mediaType].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = status { dictionary[SerializationKeys.status] = value }
    if let value = discoveryId { dictionary[SerializationKeys.discoveryId] = value }
    if let value = mediaThumb { dictionary[SerializationKeys.mediaThumb] = value }
    if let value = mediaFile { dictionary[SerializationKeys.mediaFile] = value }
    if let value = discoveryMediaId { dictionary[SerializationKeys.discoveryMediaId] = value }
    if let value = duration { dictionary[SerializationKeys.duration] = value }
    if let value = mediaType { dictionary[SerializationKeys.mediaType] = value }
    return dictionary
  }

}
