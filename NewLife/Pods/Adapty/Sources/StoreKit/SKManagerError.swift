//
//  SKManagerError.swift
//  Adapty
//
//  Created by Aleksei Valiano on 25.10.2022
//

import StoreKit

enum SKManagerError: Error {
    case interrupted(AdaptyError.Source)
    case noProductIDsFound(AdaptyError.Source)
    case receiptIsEmpty(AdaptyError.Source, error: Error?)
    case refreshReceiptFailed(AdaptyError.Source, error: Error)
    case receiveRestoredTransactionsFailed(AdaptyError.Source, error: Error)
    case requestSKProductsFailed(AdaptyError.Source, error: Error)
    case productPurchaseFailed(AdaptyError.Source, transactionError: Error?)
    case noPurchasesToRestore(AdaptyError.Source)
}

extension SKManagerError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .interrupted(source):
            return "StoreKitManagerError.interrupted(\(source))"
        case let .noProductIDsFound(source):
            return "StoreKitManagerError.noProductIDsFound(\(source))"
        case let .receiptIsEmpty(source, error):
            if let error = error {
                return "StoreKitManagerError.receiptIsEmpty(\(source), \(error)"
            } else {
                return "StoreKitManagerError.receiptIsEmpty(\(source))"
            }
        case let .refreshReceiptFailed(source, error):
            return "StoreKitManagerError.refreshReceiptFailed(\(source), \(error)"
        case let .receiveRestoredTransactionsFailed(source, error):
            return "StoreKitManagerError.receiveRestoredTransactionsFailed(\(source), \(error)"
        case let .requestSKProductsFailed(source, error):
            return "StoreKitManagerError.requestSKProductsFailed(\(source), \(error)"
        case let .productPurchaseFailed(source, error):
            if let error = error {
                return "StoreKitManagerError.productPurchaseFailed(\(source), \(error))"
            } else {
                return "StoreKitManagerError.productPurchaseFailed(\(source))"
            }
        case let .noPurchasesToRestore(source):
            return "StoreKitManagerError.noPurchasesToRestore(\(source))"
        }
    }
}

extension SKManagerError {
    var source: AdaptyError.Source {
        switch self {
        case let .productPurchaseFailed(src, _),
             let .noProductIDsFound(src),
             let .receiptIsEmpty(src, _),
             let .refreshReceiptFailed(src, _),
             let .receiveRestoredTransactionsFailed(src, _),
             let .requestSKProductsFailed(src, _),
             let .noPurchasesToRestore(src),
             let .interrupted(src):
            return src
        }
    }

    var originalError: Error? {
        switch self {
        case let .receiptIsEmpty(_, error),
             let .productPurchaseFailed(_, error):
            return error
        case let .refreshReceiptFailed(_, error),
             let .receiveRestoredTransactionsFailed(_, error),
             let .requestSKProductsFailed(_, error):
            return error
        default:
            return nil
        }
    }

    var skError: SKError? {
        guard let originalError = originalError else { return nil }
        return originalError as? SKError
    }
}

extension SKManagerError {
    static func noProductIDsFound(file: String = #fileID, function: String = #function, line: UInt = #line
    ) -> Self {
        .noProductIDsFound(AdaptyError.Source(file: file, function: function, line: line))
    }
    static func productPurchaseFailed(_ error: Error?, file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .productPurchaseFailed(AdaptyError.Source(file: file, function: function, line: line), transactionError: error)
    }

    static func receiptIsEmpty(_ error: Error? = nil, file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .receiptIsEmpty(AdaptyError.Source(file: file, function: function, line: line), error: error)
    }

    static func refreshReceiptFailed(_ error: Error, file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .refreshReceiptFailed(AdaptyError.Source(file: file, function: function, line: line), error: error)
    }

    static func receiveRestoredTransactionsFailed(_ error: Error, file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .receiveRestoredTransactionsFailed(AdaptyError.Source(file: file, function: function, line: line), error: error)
    }

    static func requestSKProductsFailed(_ error: Error, file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .requestSKProductsFailed(AdaptyError.Source(file: file, function: function, line: line), error: error)
    }

    static func interrupted(file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .interrupted(AdaptyError.Source(file: file, function: function, line: line))
    }

    static func noPurchasesToRestore(file: String = #fileID, function: String = #function, line: UInt = #line) -> Self {
        .noPurchasesToRestore(AdaptyError.Source(file: file, function: function, line: line))
    }
}
