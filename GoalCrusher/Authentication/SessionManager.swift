import SwiftUI
import Combine

struct Credentials {
    let username: String
    let password: String
}

final class AuthenticationSessionManager: ObservableObject {

    public static let shared = AuthenticationSessionManager()

    @Published private(set) var isLoggedIn: Bool

    private init() {
        isLoggedIn = false
    }

    func login(with credentials: Credentials) -> Bool {
         _ = loginRequest().sink(receiveValue: { val in
             withAnimation { self.isLoggedIn = val }
         })
            return true
    }

    private func loginRequest() -> Future<Bool, Never> {
        return Future() { promise in
            promise(Result.success(true))
        }
    }
}
