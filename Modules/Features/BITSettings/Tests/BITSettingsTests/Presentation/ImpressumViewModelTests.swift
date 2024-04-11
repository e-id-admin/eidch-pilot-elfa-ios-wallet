import XCTest

@testable import BITAppVersion
@testable import BITSettings
@testable import BITTestingCore

final class ImpressumViewModelTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    super.setUp()
    getAppVersionUseCase = GetAppVersionUseCaseProtocolSpy()
    getBuildNumberUseCase = GetBuildNumberUseCaseProtocolSpy()
  }

  func test_init() {
    let version = "0.0.0"
    let buildNumber = 1234
    getAppVersionUseCase.executeReturnValue = AppVersion(version)
    getBuildNumberUseCase.executeReturnValue = buildNumber

    viewModel = ImpressumViewModel(getAppVersionUseCase: getAppVersionUseCase, getBuildNumberUseCase: getBuildNumberUseCase)

    XCTAssertEqual(viewModel.appVersion, version)
    XCTAssertEqual(viewModel.buildNumber, "\(buildNumber)")
  }

  func test_appVersionFailure() {
    let buildNumber = 1234
    getAppVersionUseCase.executeThrowableError = TestingError.error
    getBuildNumberUseCase.executeReturnValue = buildNumber

    viewModel = ImpressumViewModel(getAppVersionUseCase: getAppVersionUseCase, getBuildNumberUseCase: getBuildNumberUseCase)

    XCTAssertEqual(viewModel.appVersion, "0.0.0")
    XCTAssertEqual(viewModel.buildNumber, "\(buildNumber)")
  }

  func test_buildNumberFailure() {
    let version = "1234"
    getAppVersionUseCase.executeReturnValue = AppVersion(version)
    getBuildNumberUseCase.executeThrowableError = TestingError.error

    viewModel = ImpressumViewModel(getAppVersionUseCase: getAppVersionUseCase, getBuildNumberUseCase: getBuildNumberUseCase)

    XCTAssertEqual(viewModel.appVersion, version)
    XCTAssertEqual(viewModel.buildNumber, "0")
  }

  // MARK: Private

  // swiftlint:disable all
  private var getAppVersionUseCase: GetAppVersionUseCaseProtocolSpy!
  private var getBuildNumberUseCase: GetBuildNumberUseCaseProtocolSpy!

  private var viewModel: ImpressumViewModel!
  //swiftlint:enable all
}
