import Alamofire
import Foundation
import Moya

// MARK: - NetworkError

public struct NetworkError: Error, LocalizedError {

  // MARK: Lifecycle

  public init(status: NetworkErrorStatus, response: Response? = nil) {
    self.status = status
    self.response = response
  }

  public init(response: Response) {
    status = NetworkErrorStatus(response: response)
    self.response = response
  }

  public init?(moyaError: MoyaError) {
    switch moyaError {
    case .statusCode(let response):
      self.init(response: response)

    case .underlying(let error, let response):
      let underlyingCode: Int = if let underlyingError = (error as? AFError)?.underlyingError {
        (underlyingError as NSError).code
      } else if let alamofireError = error as? Alamofire.AFError {
        (alamofireError as NSError).code
      } else {
        (error as NSError).code
      }

      switch underlyingCode {
      case -1003:
        self.init(status: .hostnameNotFound, response: response)
      case -1009,
           -1020:
        self.init(status: .noConnection, response: response)
      default:
        if let afError = error.asAFError, afError.isServerTrustEvaluationError {
          self.init(status: .pinning, response: response)
        } else {
          self.init(status: .unknown(message: error.localizedDescription))
        }
      }

    default:
      guard let response = moyaError.response else { return nil }
      self.init(response: response)
    }

  }

  // MARK: Public

  public let status: NetworkErrorStatus
  public let response: Response?

  public var errorDescription: String? {
    status.localizedDescription
  }
}
