// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "5840138a137f9fec45202ea97b5e91f2"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: HealRequest.self)
    ModelRegistry.register(modelType: AudioInfo.self)
  }
}