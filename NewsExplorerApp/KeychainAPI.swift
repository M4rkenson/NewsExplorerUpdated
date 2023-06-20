import Foundation
import KeychainAccess

final class KeychainStorage {
    private struct KeychainKeys {
        static let accessToken: String = "accessToken"
    }

    static let shared = KeychainStorage()
    private let keychain = Keychain(service: "com.test.keychain")
    
    private init() {
        // В данном методе не нужно устанавливать значение accessToken, так как оно будет загружаться из Keychain при первом обращении
    }
    
    var accessToken: String? {
        get {
            return keychain[KeychainKeys.accessToken]
        }
        set {
            keychain[KeychainKeys.accessToken] = newValue
        }
    }
}
