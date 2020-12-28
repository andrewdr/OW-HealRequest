// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f6da2d91399dd5a35229fff4f5ea9b03"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: HealRequest.self)
  }
}