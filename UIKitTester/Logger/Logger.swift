//
//  Logger.swift
//  UIKitTester
//
//  Created by Oliver on 2023/05/28.
//

import Foundation
import os.log

extension OSLog {
    static var subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

// MARK: - 기본 세팅
struct Log {
    enum Level {
        case debug
        case info
        case network
        case error
        case custom(categoryName: String)
        
        fileprivate var category: String {
            switch self {
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .network:
                return "Network"
            case .error:
                return "Error"
            case let .custom(categoryName):
                return categoryName
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug,
                    .custom:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
            case .error:
                return OSLog.error
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug,
                    .custom:
                return .debug
            case .info:
                return .info
            case .network:
                return .default
            case .error:
                return .error
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level, _ fileName: String, _ line: Int) {
#if LOG
        if #available(iOS 14.0, *) {
            let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
            let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
            let logMessage = "⚠️[\(fileName)] [Line: \(line)] \(message) \(extraMessage)⚠️"
            
            switch level {
            case .debug,
                    .custom:
                logger.debug("\(logMessage, privacy: .public)")
            case .info:
                logger.info("\(logMessage, privacy: .public)")
            case .network:
                logger.log("\(logMessage, privacy: .public)")
            case .error:
                logger.error("\(logMessage, privacy: .public)")
            }
            
        } else {
            let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
            os_log(
                "%{public}@",
                log: level.osLog, type: level.osLogType,
                "⚠️[\(fileName)] [Line: \(line)] \(message) \(extraMessage)⚠️"
            )
        }
#endif
    }
}

// MARK: - 실사용 세팅
extension Log {
    static func debug(_ message: Any, _ arguments: Any..., fileName: String = #fileID, _ line: Int = #line) {
        log(message, arguments, level: .debug, fileName, line)
    }
    
    static func info(_ message: Any, _ arguments: Any..., fileName: String = #fileID, _ line: Int = #line) {
        log(message, arguments, level: .info, fileName, line)
    }
    
    static func network(_ message: Any, _ arguments: Any..., fileName: String = #fileID, _ line: Int = #line) {
        log(message, arguments, level: .network, fileName, line)
    }
    
    static func error(_ message: Any, _ arguments: Any..., fileName: String = #fileID, _ line: Int = #line) {
        log(message, arguments, level: .network, fileName, line)
    }
    
    static func custom(category: String, _ message: Any, _ arguments: Any..., fileName: String = #fileID, _ line: Int = #line) {
        log(message, arguments, level: .custom(categoryName: category), fileName, line)
    }
}
