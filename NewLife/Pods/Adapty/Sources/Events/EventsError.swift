//
//  EventsError.swift
//  Adapty
//
//  Created by Aleksei Valiano on 07.10.2022.
//

enum EventsError: Error {
    case sending(AdaptyError.Source, error: HTTPError)
    case analyticsDisabled(AdaptyError.Source)
    case encoding(AdaptyError.Source, error: Error)
    case interrupted(AdaptyError.Source)
}

extension EventsError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .sending(source, error: error):
            return "EventsError.sending(\(source), \(error))"
        case let .analyticsDisabled(source):
            return "EventsError.analyticsDisabled(\(source))"
        case let .encoding(source, error: error):
            return "EventsError.encoding(\(source), \(error))"
        case let .interrupted(source):
            return "EventsError.interrupted(\(source))"
        }
    }
}

extension EventsError {
    var source: AdaptyError.Source {
        switch self {
        case let .sending(src, _),
             let .analyticsDisabled(src),
             let .encoding(src, _),
             let .interrupted(src):
            return src
        }
    }

    var isInterrupted: Bool {
        switch self {
        case .interrupted:
            return true
        case let .sending(_, error: error):
            return error.isCancelled
        default:
            return false
        }
    }

    var originalError: Error? {
        switch self {
        case let .sending(_, error):
            return error
        case let .encoding(_, error):
            return error
        default:
            return nil
        }
    }
}

extension EventsError {
    static func sending(
        _ error: HTTPError,
        file: String = #fileID, function: String = #function, line: UInt = #line
    ) -> Self {
        .sending(AdaptyError.Source(file: file,
                                    function: function,
                                    line: line),
                 error: error)
    }

    static func analyticsDisabled(
        file: String = #fileID, function: String = #function, line: UInt = #line
    ) -> Self {
        .analyticsDisabled(AdaptyError.Source(file: file,
                                              function: function,
                                              line: line))
    }

    static func encoding(
        _ error: Error,
        file: String = #fileID, function: String = #function, line: UInt = #line
    ) -> Self {
        .encoding(AdaptyError.Source(file: file,
                                     function: function,
                                     line: line),
                  error: error)
    }

    static func interrupted(
        file: String = #fileID, function: String = #function, line: UInt = #line
    ) -> Self {
        .interrupted(AdaptyError.Source(file: file,
                                        function: function,
                                        line: line))
    }
}
