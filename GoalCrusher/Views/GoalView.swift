import SwiftUI

struct GoalView: GoalCrusherViewProtocol {
    static let title = "Goal View"
    static let route = "/goal"
    static let transtionType = TransitionType.push
    @EnvironmentObject var navigator: NavigationCoordinator<NavigationMap>
    @EnvironmentObject var sessionManager: AuthenticationSessionManager

    var body: some View {
        navigator.navigationController.navigationBar.topItem?.title = Self.title
        return Text("Hello, World!")
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
