import Spyable
import XCTest
@testable import BITCredential
@testable import BITCredentialMocks
@testable import BITTestingCore

final class FetchMetadataUseCaseTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyRepository = CredentialRepositoryProtocolSpy()
    useCase = FetchMetadataUseCase(repository: spyRepository)
  }

  func testFetchMetadataHappyPath() async throws {
    let mockMetadata: CredentialMetadata = .Mock.sample
    guard let mockUrl: URL = .init(string: "http://mock.url") else { fatalError("url generation") }
    spyRepository.fetchMetadataFromReturnValue = mockMetadata

    let metadata = try await useCase.execute(from: mockUrl)

    XCTAssertEqual(mockMetadata, metadata)
    XCTAssertTrue(spyRepository.fetchMetadataFromCalled)
    XCTAssertEqual(1, spyRepository.fetchMetadataFromCallsCount)
    XCTAssertEqual(mockUrl, spyRepository.fetchMetadataFromReceivedInvocations.first)
  }

  func testFetchMetadataFailurePath() async throws {
    guard let mockUrl: URL = .init(string: "http://mock.url") else { fatalError("url generation") }
    spyRepository.fetchMetadataFromThrowableError = TestingError.error

    do {
      _ = try await useCase.execute(from: mockUrl)
      XCTFail("Should have thrown an exception")
    } catch TestingError.error {
      XCTAssertTrue(spyRepository.fetchMetadataFromCalled)
      XCTAssertEqual(1, spyRepository.fetchMetadataFromCallsCount)
      XCTAssertEqual(mockUrl, spyRepository.fetchMetadataFromReceivedInvocations.first)
    } catch {
      XCTFail("Not the error expected")
    }
  }

  // MARK: Private

  private var spyRepository = CredentialRepositoryProtocolSpy()
  private var useCase = FetchMetadataUseCase()

}
