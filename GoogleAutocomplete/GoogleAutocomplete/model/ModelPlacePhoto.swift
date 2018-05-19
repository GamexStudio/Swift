//
//  ModelPlacePhoto.swift
//
//  Created by   on 06/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ModelPlacePhoto {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let width = "width"
    static let height = "height"
    static let htmlAttributions = "html_attributions"
    static let photoReference = "photo_reference"
  }

  // MARK: Properties
  public var width: Int?
  public var height: Int?
  public var htmlAttributions: [String]?
  public var photoReference: String?

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
    width = json[SerializationKeys.width].int
    height = json[SerializationKeys.height].int
    if let items = json[SerializationKeys.htmlAttributions].array { htmlAttributions = items.map { $0.stringValue } }
    photoReference = json[SerializationKeys.photoReference].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = width { dictionary[SerializationKeys.width] = value }
    if let value = height { dictionary[SerializationKeys.height] = value }
    if let value = htmlAttributions { dictionary[SerializationKeys.htmlAttributions] = value }
    if let value = photoReference { dictionary[SerializationKeys.photoReference] = value }
    return dictionary
  }

}
