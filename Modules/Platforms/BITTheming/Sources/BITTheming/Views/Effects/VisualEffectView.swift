import SwiftUI
import UIKit

public struct VisualEffectView: UIViewRepresentable {
  var effect: UIVisualEffect?

  public init(effect: UIVisualEffect? = nil) {
    self.effect = effect
  }

  public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
    UIVisualEffectView()
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
    uiView.effect = effect
  }
}
