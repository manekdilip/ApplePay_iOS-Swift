//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Devubha Manek on 26/02/20.
//  Copyright © 2020 Devubha Manek. All rights reserved.
//

import Stripe
import PassKit
import UIKit

//MARK: ViewController
class ViewController: UIViewController {
    
    
    //MARK: Variable Declaration
    var paymentRequest: PKPaymentRequest!
    var transactionId = ""
    var status = ""
    var amount = 100
    
    //MARK: Override Method Declaration
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //SetUp ApplePAy
    func setupApplePay()
    {
        paymentRequest = PKPaymentRequest()
        paymentRequest.currencyCode = "USD"
        paymentRequest.countryCode = "US"
        paymentRequest.merchantIdentifier = "merchant.com.ManekTech.ApplePayDemo"
        
        // Payment networks array
        let paymentNetworks:[PKPaymentNetwork] = [.amex,.masterCard,.visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks)
        {
            paymentRequest.supportedNetworks = paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            
            let item = PKPaymentSummaryItem(label: "Order Total", amount: NSDecimalNumber(string: "\(amount)"))
            
            paymentRequest.paymentSummaryItems = [item]
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC?.delegate = self
            self.present(applePayVC!, animated: true, completion: nil)
        }
        else
        {
            // Notify the user that he/she needs to set up the Apple Pay on the device
            // Below code calls a common function to display alert message. You can either create an alert or  can just print something on console.
            let alert = UIAlertController(title: "", message: "Apple Pay is not available on this device.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

//MARK: IBAction
extension ViewController {
    
    @IBAction func tappedOnPAy(_ sender: Any) {
        self.setupApplePay()
    }
}

//MARK: PKPaymentAuthorizationViewControllerDelegate
extension ViewController : PKPaymentAuthorizationViewControllerDelegate{
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Let the Operating System know that the payment was accepted successfully
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
        
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}

