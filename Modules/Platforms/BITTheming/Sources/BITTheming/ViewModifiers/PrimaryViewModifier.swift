import Foundation
import SwiftUI

public struct PrimaryViewModifier: ViewModifier {

  public init() {}

  public func body(content: Content) -> some View {
    content
      .padding()
      .frame(maxWidth: .infinity)
      .background(ThemingAssets.accentColor.swiftUIColor)
      .cornerRadius(.standard)
      .foregroundColor(.white)
      .progressViewStyle(CircularProgressViewStyle(tint: .white))
  }

}
