//
//  IAPService.swift
//  MrZzz
//
//  Created by eTech on 05/10/19.
//  Copyright © 2019 eTech. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto

import StoreKit

protocol IAPServiceModelDelegate {
    func purchseSuccess(updatedTransaction:SKPaymentTransaction)
    func purchseFail(updatedTransaction:SKPaymentTransaction)
    func tranjactionState(objSKPaymentTransactionState:SKPaymentTransactionState)
}

// call in app purchase method // IAPService.shared.purchase(product: .autoRenewing1monthSubscription)
enum IAPProductModel: String
{
//    case consumableW1000 = "com.rankingstar.app.test5"
//    case consumableW1000 = "com.rankingstar.app"
//    case consumableW3000 = "com.rankingstar.app.test5"
//    case consumableW5000 = "com.rankingstar.app.test5"
//    case consumableW10000 = "com.rankingstar.app.test5"
//    case consumableW20000 = "com.rankingstar.app.test5"
    
    case consumableW120 = "com.rankingstar.app.iap120star"
    case consumableW390 = "com.rankingstar.app.iap390star"
    case consumableW590 = "com.rankingstar.app.iap590star"
    case consumableW1100 = "com.rankingstar.app.iap1100star"
    case consumableW2000 = "com.rankingstar.app.iap2000star"
}



class IAPServiceModel: NSObject {

    private override init() {}
    static let shared = IAPServiceModel()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    var objIAPServiceModelDelegate:IAPServiceModelDelegate!
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func getProducts() {
        let products: Set = [IAPProductModel.consumableW120.rawValue,
                             IAPProductModel.consumableW390.rawValue,
                             IAPProductModel.consumableW590.rawValue,
                             IAPProductModel.consumableW1100.rawValue,
                             IAPProductModel.consumableW2000.rawValue
                            ]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProductModel, transactionId: String)
    {
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {
            return
        }
        
        print("transactionId.md5: \(transactionId.md5)")
        print("transactionId.md5: \(transactionId.md5)")
        
        //let payment = SKPayment(product: productToPurchase)
        let payment = SKMutablePayment(product: productToPurchase)
        payment.applicationUsername = transactionId.md5
        paymentQueue.add(payment)
    }
    
}

extension IAPServiceModel: SKProductsRequestDelegate
{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print("products : \(product.localizedTitle)")
        }
    }
}

extension IAPServiceModel: SKPaymentTransactionObserver
{
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction in transactions {
            printDebug("status: \(transaction.transactionState.status()) ID: \(transaction.payment.productIdentifier) Error: \(transaction.error)")
            
            if(objIAPServiceModelDelegate != nil) {
                objIAPServiceModelDelegate.tranjactionState(objSKPaymentTransactionState: transaction.transactionState)
                if(transaction.transactionState == .purchased)
                {
                    objIAPServiceModelDelegate.purchseSuccess(updatedTransaction: transaction)
                }
                else if(transaction.transactionState == .failed) {
                    objIAPServiceModelDelegate.purchseFail(updatedTransaction: transaction)
                }
            }
            
            switch transaction.transactionState {
            case .purchased, .failed:
                    queue.finishTransaction(transaction)
                break
            default: break
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String
    {
        switch self {
        case .deferred: return "deferred"
        case .failed: return  "failed"
        case .purchased: return  "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
