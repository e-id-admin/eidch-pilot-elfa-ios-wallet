import Foundation

struct SecKeyTestsHelper {

  static func createPrivateKey() -> SecKey {

    let attributes: [String: Any] = [
      kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
      kSecAttrKeySizeInBits as String: 521,
      kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: false,
        kSecAttrApplicationTag as String: UUID().uuidString,
      ],
    ]

    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
      fatalError("Can not create Private Key: \(error.debugDescription)")
    }
    return privateKey
  }

  static func getPublicKey(for privateKey: SecKey) -> SecKey {
    guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
      fatalError("Can not get the Public Key")
    }
    return publicKey
  }

}
