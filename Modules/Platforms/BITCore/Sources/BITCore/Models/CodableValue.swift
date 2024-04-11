import Foundation

// MARK: - CodableValueError

public enum CodableValueError: Error {
  case dictionaryDecodingError
}

// MARK: - CodableValue

public enum CodableValue: Codable {
  case string(String)
  case int(Int)
  case double(Double)
  case bool(Bool)
  case array([CodableValue?])
  case dictionary([String: CodableValue?])

  // MARK: Lifecycle

  public init(value: String, as type: String) {
    switch type {
    case "number":
      self = .int(Int(value) ?? 0)
    default:
      self = .string(value)
    }
  }

  public init?(anyValue: Any) throws {
    switch anyValue {
    case let stringValue as String: self = .string(stringValue)
    case let intValue as Int: self = .int(intValue)
    case let doubleValue as Double: self = .double(doubleValue)
    case let boolValue as Bool: self = .bool(boolValue)
    case let dictionaryValue as [String: Any]: self = try .dictionary(Self.convert(dictionaryOfAny: dictionaryValue))
    case let arrayValue as [Any]: self = try .array(Self.convert(arrayOfAny: arrayValue))
    default:
      return nil
    }
  }

  // MARK: Public

  public var isString: Bool {
    if case .string = self { return true }
    return false
  }

  public var isInt: Bool {
    if case .int = self { return true }
    return false
  }

  public var isDouble: Bool {
    if case .double = self { return true }
    return false
  }

  public var isBool: Bool {
    if case .bool = self { return true }
    return false
  }

  public var isArray: Bool {
    if case .array = self { return true }
    return false
  }

  public var isDictionary: Bool {
    if case .dictionary = self { return true }
    return false
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let value):
      try container.encode(value)
    case .int(let value):
      try container.encode(value)
    case .double(let value):
      try container.encode(value)
    case .bool(let value):
      try container.encode(value)
    case .array(let value):
      try container.encode(value)
    case .dictionary(let value):
      try container.encode(value)
    }
  }

}

// MARK: Equatable

extension CodableValue: Equatable {
  public static func == (lhs: CodableValue, rhs: CodableValue) -> Bool {
    switch (lhs, rhs) {
    case (.string(let leftValue), .string(let rightValue)):
      leftValue == rightValue
    case (.int(let leftValue), .int(let rightValue)):
      leftValue == rightValue
    case (.double(let leftValue), .double(let rightValue)):
      leftValue == rightValue
    case (.bool(let leftValue), .bool(let rightValue)):
      leftValue == rightValue
    case (.array(let leftValue), .array(let rightValue)):
      leftValue == rightValue
    case (.dictionary(let leftValue), .dictionary(let rightValue)):
      leftValue == rightValue
    default:
      false
    }
  }
}

// MARK: Helpers

extension CodableValue {

  public static func convert(dictionaryOfAny: [String: Any]) throws -> [String: CodableValue] {
    var dictionaryOfCodableValue: [String: CodableValue] = [:]
    for (key, value) in dictionaryOfAny {
      dictionaryOfCodableValue[key] = try .init(anyValue: value)
    }
    return dictionaryOfCodableValue
  }

  public static func convert(arrayOfAny: [Any]) throws -> [CodableValue?] {
    var arrayOfCodableValue: [CodableValue?] = []
    for value in arrayOfAny {
      try arrayOfCodableValue.append(.init(anyValue: value))
    }
    return arrayOfCodableValue
  }
}

extension CodableValue {

  public var rawValues: (type: String, value: String) {
    (self.type, self.rawValue)
  }

  public var type: String {
    switch self {
    case .string:
      "string"
    case .int:
      "int"
    case .double:
      "double"
    case .bool:
      "bool"
    case .array:
      "array"
    case .dictionary:
      "dictionary"
    }
  }

  public var rawValue: String {
    switch self {
    case .string(let string):
      string
    case .int(let int):
      String(int)
    case .double(let double):
      String(double)
    case .bool(let bool):
      String(bool)
    case .array(let array):
      "\(array)"
    case .dictionary(let dictionary):
      "\(dictionary)"

    }
  }
}
