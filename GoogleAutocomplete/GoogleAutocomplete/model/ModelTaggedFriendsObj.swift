//
//  ModelTaggedFriendsObj.swift
//
//  Created by   on 06/05/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class ModelTaggedFriendsObj {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let profilePic = "profile_pic"
    static let lastName = "last_name"
    static let userId = "user_id"
    static let firstName = "first_name"
  }

  // MARK: Properties
  public var profilePic: String?
  public var lastName: String?
  public var userId: Int?
  public var firstName: String?

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
    profilePic = json[SerializationKeys.profilePic].string
    lastName = json[SerializationKeys.lastName].string
    userId = json[SerializationKeys.userId].int
    firstName = json[SerializationKeys.firstName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = profilePic { dictionary[SerializationKeys.profilePic] = value }
    if let value = lastName { dictionary[SerializationKeys.lastName] = value }
    if let value = userId { dictionary[SerializationKeys.userId] = value }
    if let value = firstName { dictionary[SerializationKeys.firstName] = value }
    return dictionary
  }

}
