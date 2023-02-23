import SwiftUI

protocol GoalCrusherViewProtocol: View{
    static var title: String { get }
    static var route: String { get }
    static var transtionType: TransitionType { get }
}
