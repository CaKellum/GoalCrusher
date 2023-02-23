import UIKit
import SwiftUI

enum NavigationMap: NavigationRoute {

    case home, goal, login

    var title: String {
        switch self {
        case .home: return HomeView.title
        case .goal: return GoalView.title
        case .login: return LoginView.title
        }
    }

    var route: String {
        switch self {
        case .home: return HomeView.route
        case .goal: return GoalView.route
        case .login: return LoginView.route
        }
    }

    var transition: TransitionType {
        switch self {
        case .home: return HomeView.transtionType
        case .goal: return GoalView.transtionType
        case .login: return LoginView.transtionType
        }
    }

    @ViewBuilder
    func view() -> some View {
        switch self {
        case .home:
            HomeView()
        case .goal:
            GoalView()
        case .login:
            LoginView(sessionManager: AuthenticationSessionManager.shared)
        }
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let coordinator = NavigationCoordinator<NavigationMap>(root: nil)
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()
        do {
            try coordinator.run()
        } catch let e as NavigationError {
            // TODO: Make an errorHandler
            GCLogger.instance.error(e)
            coordinator.show(screen: .login)
        } catch {
            GCLogger.instance.error(error)
            coordinator.show(screen: .home)
        }
        GCLogger.instance.info(with: "Coordinator Started")
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

