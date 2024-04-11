import BITCore
import Foundation

// MARK: - CredentialOffer

public struct CredentialOffer: Codable, Equatable {
  public let issuer: String
  public let grants: Grants
  public let credentials: [String]

  public var preAuthorizedCode: String {
    grants.urn.preAuthorizedCode
  }

  enum CodingKeys: String, CodingKey {
    case issuer = "credential_issuer"
    case grants = "grants"
    case credentials = "credentials"
  }
}

// MARK: - Grants

public struct Grants: Codable, Equatable {
  public let urn: Urn

  enum CodingKeys: String, CodingKey {
    case urn = "urn:ietf:params:oauth:grant-type:pre-authorized_code"
  }
}

// MARK: - Urn

public struct Urn: Codable, Equatable {
  public let preAuthorizedCode: String

  enum CodingKeys: String, CodingKey {
    case preAuthorizedCode = "pre-authorized_code"
  }
}
