import Foundation
import SwiftUI

public enum BiometricStepType {
  case none
  case faceID
  case touchID

  // MARK: Lifecycle

  public init(type: BiometricType) {
    self = switch type {
    case .faceID: .faceID
    case .touchID: .touchID
    default: .none
    }
  }

  // MARK: Public

  public var text: String {
    switch self {
    case .faceID: L10n.biometricSetupFaceidText
    case .touchID: L10n.biometricSetupTouchidText
    case .none: ""
    }
  }

  public var image: Image {
    switch self {
    case .faceID,
         .touchID: Image(systemName: icon)
    case .none: Assets.biometric.swiftUIImage
    }
  }

  // MARK: Private

  private var icon: String {
    switch self {
    case .faceID: "faceid"
    case .touchID: "touchid"
    case .none: ""
    }
  }

}
