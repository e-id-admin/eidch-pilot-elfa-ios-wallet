import Factory
import Moya
import XCTest
@testable import BITNetworking

final class Tests: XCTestCase {

  enum FakeAPI: TargetType {
    case someEndpoint

    // swiftlint:disable force_unwrapping
    var baseURL: URL { URL(string: "http://localhost")! }
    var path: String { "/" }
    var method: Moya.Method { .get }
    var task: Moya.Task { .requestPlain }
    var headers: [String: String]? { nil }
    var sampleData: Data { "{\"name\": \"John\"}".data(using: .utf8)! }
    // swiftlint:enable force_unwrapping

  }

  struct FakeModel: Decodable {
    var name: String
  }

  override func setUp() {
    NetworkContainer.shared.reset()
    NetworkContainer.shared.stubClosure.register(factory: {
      { _ in .immediate }
    })
  }

  func test_decodeRequest() async throws {
    let object: FakeModel = try await NetworkService().request(FakeAPI.someEndpoint)
    XCTAssertEqual(object.name, "John")
  }

  func test_responseRequest() async throws {
    let object: (FakeModel, Response) = try await NetworkService().request(FakeAPI.someEndpoint)
    XCTAssertEqual(object.0.name, "John")
    XCTAssertEqual(object.1.statusCode, 200)
  }

  func test_apiError500() async throws {
    NetworkContainer.shared.endpointClosure.register {
      .networkResponse(500, .init())
    }

    do {
      let _: (FakeModel, Response) = try await NetworkService().request(FakeAPI.someEndpoint)
    } catch {
      XCTAssertEqual(error as? NetworkError, .internalServerError)
    }
  }

}
