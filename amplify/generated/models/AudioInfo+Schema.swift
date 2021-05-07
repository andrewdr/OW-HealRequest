// swiftlint:disable all
import Amplify
import Foundation

extension AudioInfo {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case audioTitle
    case audioFileName
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let audioInfo = AudioInfo.keys
    
    model.pluralName = "AudioInfos"
    
    model.fields(
      .id(),
      .field(audioInfo.audioTitle, is: .required, ofType: .string),
      .field(audioInfo.audioFileName, is: .required, ofType: .string)
    )
    }
}