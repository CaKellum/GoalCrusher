import Foundation

extension String? {

    public var isNilOrEmpty: Bool { self?.isEmpty ?? true }

}
