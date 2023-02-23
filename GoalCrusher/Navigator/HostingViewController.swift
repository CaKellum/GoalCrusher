import SwiftUI

@MainActor
final class HostingViewController<Content, V>: UIHostingController<Content> where Content : View,
                                                                                  V : NavigationRoute{

    private let route: V

    @MainActor
    init(rootView: Content, route: V) {
        self.route = route
        super.init(rootView: rootView)
    }

    @MainActor @available (*, unavailable)
    required dynamic init?(coder aDecoder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        if route.route == NavigationMap.home.route {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                               style: .plain, target: self,
                                                               action: #selector(menuAction(_:)))
        } else {
            navigationItem.backButtonDisplayMode = .minimal
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = route.title
    }

    @IBAction private func menuAction(_ sender: Any?) {
        print("\n\n menu hit \n menu hit \n\n")
    }
}
