import SwiftUI

/// This is the Coordinator for navigation of the application that will manage the general navigation
class NavigationCoordinator<Route: NavigationRoute>: ObservableObject {

    /// The root of app
    let root: Route?
    /// the core of the navigation wrapper
    let navigationController: UINavigationController
    /// stack of views in the app
    private(set) var viewStack = [Route]()
    /// flag to indicate if the current screen is a modal
    public var isModalPresentation: Bool {
        navigationController.modalPresentationStyle != .automatic
    }

    /// Initializer for the Navigation wrapper
    /// - Parameters:
    ///   - navigationController: The core of the Coordinator, defaults to a Basic UINavigationController
    ///   - root: The Root route of the app, ie the Home Page/Login
    init(navigationController: UINavigationController = .init(), root: Route? = nil) {
        self.root = root
        self.navigationController = navigationController
        if let root = root { viewStack.append(root) }
        GCLogger.instance.info(with: "NavigationCoordinator being Initialized")
    }

    /// presents the root screen and starts the launch of the app
    @MainActor func run() throws {
        guard let route = root else {
            let error = NavigationError(type: .noRoot)
            GCLogger.instance.error(error)
            throw error
        }
        self.show(screen: route)
        GCLogger.instance.info(with: "NavigationCoordinator showing \(route.title)")
    }

    /// Presents the route's View via the routes contained transitions
    /// - Parameters:
    ///   - screen: The route that will be presented
    ///   - animated: option to make the transition smoother, defaults to true
    /// - Returns: true after it copmletes
    @MainActor @discardableResult func show(screen: Route, animated: Bool = true) -> Bool {
        let view = setupRouteToShow(screen)
        let host = HostingViewController(rootView: view, route: screen)
        switch screen.transition {
        case .push:
            viewStack.append(screen)
            navigationController.pushViewController(host, animated: animated)
        case .pushClearStack:
            clearStack(add: screen)
            navigationController.pushViewController(host, animated: animated)
            let viewController = navigationController.topViewController ?? host
            navigationController.viewControllers = [viewController]
        case .modal:
            host.modalPresentationStyle = .formSheet
            navigationController.present(host, animated: animated)
        case .sheet:
            host.modalPresentationStyle = .pageSheet
            navigationController.present(host, animated: animated)
        }
        return true
    }

    /// dismiss modal presenting ViewController
    /// - Parameter animated: if true trasition will appear smoother, defaults true
    func dissmiss(animated: Bool = true) {
        guard isModalPresentation else { return }
        navigationController.dismiss(animated: animated) { [weak self] in
            guard let route = self?.viewStack.last, let view = self?.setupRouteToShow(route) else { return }
            DispatchQueue.main.async {
                self?.navigationController.viewControllers = [HostingViewController(rootView: view, route: route)]
            }
        }
    }

    /// Removes the specific views from the stack and can present the top view
    /// - Parameters:
    ///   - view: view to remove
    ///   - showTop: show the top view of the stack
    @MainActor func removeFromStack(_ view: Route, showTop: Bool = false) {
        viewStack.removeAll { $0.route == view.route }
        if showTop { showTopScreen() }
    }

    /// pops a number of sceens off the stack
    /// - Parameter numOfViews: The number of views to pop off the viewStack
    @MainActor func popFromStack(_ numOfViews: Int = 1) {
        guard viewStack.count > numOfViews && numOfViews > 0 else { return }
        for _ in 0 ..< numOfViews { _ = viewStack.popLast() }
        showTopScreen()
    }

    private func setupRouteToShow(_ route: Route) -> some View {
        route.view().environmentObject(self).environmentObject(AuthenticationSessionManager.shared)
    }

    @MainActor private func showTopScreen() {
        guard let screen = viewStack.last else { return }
        show(screen: screen)
    }

    /// Clear the viewStack
    ///
    /// This won't clear the NavigationController viewControllers list will need to be handle at function call
    /// - Parameter screen: A screen to add to the stack after the clear
    @MainActor private func clearStack(add screen: Route? = nil) {
        guard let screen = screen else {
            viewStack = []
            return
        }
        viewStack = [screen]
    }
}
