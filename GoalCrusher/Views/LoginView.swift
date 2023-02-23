import SwiftUI

struct LoginView: GoalCrusherViewProtocol {
    static var title: String = "Login"
    static var route: String = "/login"
    static var transtionType: TransitionType = .push

    @EnvironmentObject var navigator: NavigationCoordinator<NavigationMap>
    @ObservedObject var sessionManager: AuthenticationSessionManager

    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        navigator.navigationController.navigationBar.topItem?.title = Self.title
        if sessionManager.isLoggedIn { navigator.show(screen: .home) }
        return VStack(alignment: .center) {
            Text(verbatim: "Goal Crusher")
            Group {
                VStack {
                    if !username.isEmpty { Text(verbatim: "username") }
                    TextField("username", text: $username)
                }
                VStack {
                    if !password.isEmpty { Text(verbatim: "password") }
                    SecureField("password", text: $password)
                }
            }
            Spacer()
            Button {
                if !username.isEmpty && !password.isEmpty {
                    _ = sessionManager.login(with: Credentials(username: username, password: password))
                }
            } label: {
                Text("Login")
            }
            Spacer()
        }.padding(30)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(sessionManager: AuthenticationSessionManager.shared)
            .environmentObject(NavigationCoordinator<NavigationMap>(root: .home))
    }
}
