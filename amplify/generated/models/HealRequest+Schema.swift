// swiftlint:disable all
import Amplify
import Foundation

extension HealRequest {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case playerName
    case selectedHero
    case location
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let healRequest = HealRequest.keys
    
    model.pluralName = "HealRequests"
    
    model.fields(
      .id(),
      .field(healRequest.playerName, is: .required, ofType: .string),
      .field(healRequest.selectedHero, is: .required, ofType: .string),
      .field(healRequest.location, is: .required, ofType: .string)
    )
    }
}