import SwiftUI

struct HomeView: GoalCrusherViewProtocol {
    static let title = "Home"
    static let route = "/home"
    static let transtionType = TransitionType.pushClearStack
    @EnvironmentObject var navigator: NavigationCoordinator<NavigationMap>
    @EnvironmentObject var sessionManager: AuthenticationSessionManager

    var body: some View {
        navigator.navigationController.navigationBar.topItem?.title = Self.title
        return VStack{
            Text("Hello, World!")
            Button(NavigationMap.goal.title) {
                navigator.show(screen: .goal)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
