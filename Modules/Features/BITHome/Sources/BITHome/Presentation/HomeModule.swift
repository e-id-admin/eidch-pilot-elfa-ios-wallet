import Factory
import Foundation
import SwiftUI
import UIKit

// MARK: - HomeModule

@MainActor
public class HomeModule {

  // MARK: Lifecycle

  public init(router: HomeRouter = Container.shared.homeRouter()) {
    let router = router
    let viewModel = Container.shared.homeViewModel(router)
    let view = HomeComposerView(viewModel: viewModel)
      .environment(\.font, .custom.body)
      .preferredColorScheme(.light)
    let viewController = HomeHostingController(rootView: view)
    let navigation = UINavigationController(rootViewController: viewController)
    router.viewController = navigation

    self.router = router
    self.viewController = navigation
    self.viewModel = viewModel
  }

  // MARK: Public

  public let viewController: UIViewController

  public let router: HomeRouter
  public let viewModel: HomeViewModel

}
