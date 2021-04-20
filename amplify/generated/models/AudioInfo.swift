// swiftlint:disable all
import Amplify
import Foundation

public struct AudioInfo: Model {
  public let id: String
  public var audioTitle: String
  public var audioFileName: String
  
  public init(id: String = UUID().uuidString,
      audioTitle: String,
      audioFileName: String) {
      self.id = id
      self.audioTitle = audioTitle
      self.audioFileName = audioFileName
  }
}