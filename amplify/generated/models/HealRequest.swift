// swiftlint:disable all
import Amplify
import Foundation

public struct HealRequest: Model {
  public let id: String
  public var playerName: String
  public var selectedHero: String
  public var location: String
  
  public init(id: String = UUID().uuidString,
      playerName: String,
      selectedHero: String,
      location: String) {
      self.id = id
      self.playerName = playerName
      self.selectedHero = selectedHero
      self.location = location
  }
}