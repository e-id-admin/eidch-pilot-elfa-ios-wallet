import BITCore
import BITNavigation
import Factory
import Foundation
import Spyable
import UIKit

// MARK: - LoginRoutes

@Spyable
public protocol LoginRoutes {
  func login(animated: Bool)
}

@MainActor
extension LoginRoutes where Self: RouterProtocol {

  public func login(animated: Bool) {
    guard let topViewController = UIApplication.topViewController, !topViewController.className.contains("LoginHostingController") else {
      return
    }

    Container.shared.authContext.reset()

    let module = Container.shared.loginModule()
    let style = ModalOpeningStyle(animatedWhenPresenting: animated, modalPresentationStyle: .fullScreen)
    module.router.current = style
    let viewController = module.viewController

    open(viewController, on: topViewController, as: style)
  }

  public func login() {
    login(animated: true)
  }

}
