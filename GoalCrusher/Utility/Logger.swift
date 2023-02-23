import Foundation
import os

class GCLogger {
    private static let appLogTitle = "GoalCrusher"
    private static let defaultFileName = "File Unknown"
    private static let defaultFunctionName = "Function Unknown"
    private let logger: Logger

    public static let instance = GCLogger()

    private init() {
        logger = .init()
    }

    public func debug(with description: String, file: String? = #file,
                      function: String? = #function, line: Int? = #line) {
        let message = createLogMessage(description: description,
                                       file: file,
                                       function: function ?? Self.defaultFunctionName,
                                       line: line ?? .zero)
        logger.debug("\(message, privacy: .public)")
    }

    public func info(with description: String, file: String? = #file,
                     function: String? = #function, line: Int? = #line) {
        let message = createLogMessage(description: description,
                                       file: file,
                                       function: function ?? Self.defaultFunctionName,
                                       line: line ?? .zero)
        logger.info("\(message, privacy: .public)")
    }

    public func warning(with description: String, file: String? = #file,
                        function: String? = #function, line: Int? = #line) {
        let message = createLogMessage(description: description,
                                       file: file,
                                       function: function ?? Self.defaultFunctionName,
                                       line: line ?? .zero)
        logger.warning("\(message, privacy: .public)")
    }

    public func  error(_ error: Error, file: String? = #file,
                       function: String? = #function, line: Int? = #line) {
        let description = "ERROR-\(error.localizedDescription)"
        let message = createLogMessage(description: description,
                                      file: file,
                                      function: function ?? Self.defaultFunctionName,
                                       line: line ?? .zero)
        logger.error("\(message, privacy: .public)")
    }

    private func createLogMessage(description: String, file: String?, function: String, line: Int) -> String {
        let date = Date().formatted(date: .abbreviated, time: .standard)
        return "\(Self.appLogTitle) \(date) <\(extractFileName(file)):\(function):\(line)> \"\(description)\""
    }

    private func extractFileName(_ file: String?) -> String {
        file?.components(separatedBy: "/").last ?? Self.defaultFileName
    }
}
