import SwiftUI


enum TransitionType: String {
    case push, modal, sheet, pushClearStack
}

protocol NavigationRoute {
    associatedtype V: View
    var title: String { get }
    var route: String { get }
    var transition: TransitionType { get }

    @ViewBuilder
    func view() -> V
}
