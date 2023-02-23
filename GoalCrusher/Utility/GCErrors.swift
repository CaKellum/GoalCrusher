import Foundation

struct NavigationError: Error {

    let type: NavigatioErrorType

    var localizedDescription: String {
        switch type {
        case .noRoot:
            return "Navigation Coordinator has no valid root view"
        case .noAssociatedView:
            return "No associated view with route"
        case .stackEmpty:
            return "View Stack is Empty can t perform action"
        }
    }

    enum NavigatioErrorType {
        case noRoot, noAssociatedView, stackEmpty
    }
}
