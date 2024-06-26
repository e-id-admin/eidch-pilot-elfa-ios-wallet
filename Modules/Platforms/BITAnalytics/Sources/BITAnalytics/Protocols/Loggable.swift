import Foundation

// MARK: - Loggable

public protocol Loggable {
  func log(_ event: AnalyticsEventProtocol)
  func log(_ errorEvent: AnalyticsErrorEventProtocol)
  func log(_ error: Error)
}
