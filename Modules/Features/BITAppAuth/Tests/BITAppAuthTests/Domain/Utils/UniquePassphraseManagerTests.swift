import BITCore
import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCrypto
@testable import BITLocalAuthentication

// MARK: - UniquePassphraseManagerTests

final class UniquePassphraseManagerTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyIsBiometricUsageAllowedUseCase = IsBiometricUsageAllowedUseCaseProtocolSpy()
    spyUniquePassphraseRepository = UniquePassphraseRepositoryProtocolSpy()
    uniquePassphraseManager = UniquePassphraseManager(
      isBiometricUsageAllowedUseCase: spyIsBiometricUsageAllowedUseCase,
      uniquePassphraseRepository: spyUniquePassphraseRepository,
      passphraseLength: Self.passphraseLength)
  }

  func testGenerate() throws {
    let uniquePassphrase = try uniquePassphraseManager.generate()
    XCTAssertEqual(Self.passphraseLength, uniquePassphrase.count)
  }

  func testSaveWithBiometrics() throws {
    spyIsBiometricUsageAllowedUseCase.executeReturnValue = true
    try testSave(withBiometrics: true)
  }

  func testSaveWithoutBiometrics() throws {
    spyIsBiometricUsageAllowedUseCase.executeReturnValue = false
    try testSave(withBiometrics: false)
  }

  func testGetUniquePassphraseForAppPin() throws {
    try testGetUniquePassphrase(authMethod: .appPin)
  }

  func testGetUniquePassphraseForBiometric() throws {
    try testGetUniquePassphrase(authMethod: .biometric)
  }

  func testExistsForAppPin() throws {
    try testExists(authMethod: .appPin)
  }

  func testExistsForBiometric() throws {
    try testExists(authMethod: .biometric)
  }

  func testNotExistsForAppPin() throws {
    try testNotExists(authMethod: .appPin)
  }

  func testNotExistsForBiometric() throws {
    try testNotExists(authMethod: .biometric)
  }

  // MARK: Private

  private static let passphraseLength = 64

  // swiftlint:disable all
  private var spyIsBiometricUsageAllowedUseCase: IsBiometricUsageAllowedUseCaseProtocolSpy!
  private var spyUniquePassphraseRepository: UniquePassphraseRepositoryProtocolSpy!
  private var spyEncrypter: EncryptableSpy!
  private var uniquePassphraseManager: UniquePassphraseManager!
  // swiftlint:enable all
}

extension UniquePassphraseManagerTests {

  private func testSave(withBiometrics: Bool) throws {
    let uniquePassphrase: Data = .init()
    let context: LAContextProtocol = LAContextProtocolSpy()

    try uniquePassphraseManager.save(uniquePassphrase: uniquePassphrase, context: context)
    XCTAssertTrue(spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextCalled)
    XCTAssertTrue(spyIsBiometricUsageAllowedUseCase.executeCalled)

    if withBiometrics {
      XCTAssertEqual(2, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextCallsCount)
      XCTAssertEqual(uniquePassphrase, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedInvocations[0].data)
      XCTAssertEqual(uniquePassphrase, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedInvocations[1].data)
      XCTAssertEqual(AuthMethod.appPin, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedInvocations[0].authMethod)
      XCTAssertEqual(AuthMethod.biometric, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedInvocations[1].authMethod)
    } else {
      XCTAssertEqual(1, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextCallsCount)
      XCTAssertEqual(AuthMethod.appPin, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedArguments?.authMethod)
      XCTAssertEqual(uniquePassphrase, spyUniquePassphraseRepository.saveUniquePassphraseForAuthMethodInContextReceivedArguments?.data)
    }
  }

  private func testGetUniquePassphrase(authMethod: AuthMethod) throws {
    let mockUniquePassphrase: Data = .init()
    let spyContext: LAContextProtocol = LAContextProtocolSpy()
    spyUniquePassphraseRepository.getUniquePassphraseForAuthMethodInContextReturnValue = mockUniquePassphrase
    let uniquePassphrase = try uniquePassphraseManager.getUniquePassphrase(authMethod: authMethod, context: spyContext)
    XCTAssertEqual(mockUniquePassphrase, uniquePassphrase)
    XCTAssertTrue(spyUniquePassphraseRepository.getUniquePassphraseForAuthMethodInContextCalled)
    XCTAssertEqual(authMethod, spyUniquePassphraseRepository.getUniquePassphraseForAuthMethodInContextReceivedArguments?.authMethod)
  }

  private func testExists(authMethod: AuthMethod) throws {
    spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodReturnValue = true
    let exists = uniquePassphraseManager.exists(for: authMethod)
    XCTAssertTrue(exists)
    XCTAssertTrue(spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodCalled)
    XCTAssertEqual(authMethod, spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodReceivedAuthMethod)
  }

  private func testNotExists(authMethod: AuthMethod) throws {
    spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodReturnValue = false
    let exists = uniquePassphraseManager.exists(for: authMethod)
    XCTAssertFalse(exists)
    XCTAssertTrue(spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodCalled)
    XCTAssertEqual(authMethod, spyUniquePassphraseRepository.hasUniquePassphraseSavedForAuthMethodReceivedAuthMethod)
  }

}
