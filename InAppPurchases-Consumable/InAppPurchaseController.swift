//
//  ViewController.swift
//  InAppPurchases-Consumable
//
//  Created by Swarajmeet Singh on 04/06/23.
//

import UIKit
import StoreKit

enum Product : String , CaseIterable{
    case valuePackage  = "cn_1599"
}

class InAppPurchaseController: UIViewController {
    private var products = [SKProduct]()

    @IBOutlet weak var productsTableView: UITableView!{
        didSet{
            let nib = UINib(nibName: "ProductTableCell", bundle: Bundle.main)
            self.productsTableView.register(nib, forCellReuseIdentifier: "ProductTableCell")
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        self.fetchproducts()
        
    }

    
    func fetchproducts(){
        let pi = Product.allCases.compactMap({$0.rawValue})
        let request = SKProductsRequest(productIdentifiers: Set(pi))
        request.delegate = self
        request.start()
    }
    
    func purchase(product:SKProduct){
        guard SKPaymentQueue.canMakePayments() else {return}
        SKPaymentQueue.default().add(self)
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    private func handlePurchase(_ id: String){
        
    }

}



extension InAppPurchaseController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell") as! ProductTableCell
        
        cell.product = products[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        tableView.deselectRow(at: indexPath, animated: true)
        self.purchase(product: self.products[indexPath.row])
    }
    
    
    
}

extension InAppPurchaseController: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        DispatchQueue.main.async {
            self.productsTableView.reloadData()
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard request is SKProductsRequest else {return}
        print("product fetch request failes \(error.localizedDescription)")
    }
    
    
}

extension InAppPurchaseController: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach{
            
            switch $0.transactionState{
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                self.handlePurchase($0.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("@unknown")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    
}
