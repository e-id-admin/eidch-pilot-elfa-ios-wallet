import BITCore
import BITTheming
import Factory
import SwiftUI

public struct NoDevicePinCodeView: View {

  // MARK: Lifecycle

  public init(viewModel: NoDevicePinCodeViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          Assets.noDevicePin.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 300)
          Text(BITCore.L10n.globalErrorNoDevicePinTitle)
            .font(.custom.title)
          Text(BITCore.L10n.globalErrorNoDevicePinMessage)
          Spacer()
        }
      }

      VStack {
        Button {
          openSettings()
        } label: {
          Label(BITCore.L10n.globalErrorNoDevicePinButton, systemImage: "arrow.up.forward")
            .frame(maxWidth: .infinity)
            .labelStyle(.titleAndIconReversed)
        }
        .buttonStyle(.primaryProminent)
      }
      .background(ThemingAssets.background.swiftUIColor)
    }
    .padding()
    .navigationBarHidden(true)
  }

  // MARK: Internal

  @Environment(\.scenePhase) var scenePhase

  // MARK: Private

  private var viewModel: NoDevicePinCodeViewModel

  private func openSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
