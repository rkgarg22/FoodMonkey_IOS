//
//  CompleteYourPaymentVC.swift
//  Monkey
//
//  Created by apple on 25/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn

class CompleteYourPaymentVC: UIViewController {
    var restaturantNumber = ""
    var toKinizationKey = ""
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var btnOutlet_paypal: UIButton!
    @IBOutlet weak var btnOutlet_cashOnDelivery: UIButton!
    var orderId = 0
    var cardId : String?
    var paymentMethod = ""
    var amount = 0.0
    var restId :Int?
    var arrCards = [CardDetailModal]()
    var selectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCardList()
    }
    
    @IBAction func btnAction_addNewCard(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiate_AddCard_VC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnAction_payPal(_ sender: UIButton) {
        if self.btnOutlet_paypal.image(for: .normal) == #imageLiteral(resourceName: "Checkbox-click"){
            self.btnOutlet_paypal.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
            paymentMethod = ""
        }else{
            self.btnOutlet_paypal.setImage(#imageLiteral(resourceName: "Checkbox-click"), for: .normal)
            paymentMethod = "Paypal"
        }
        self.cardId = nil
        self.btnOutlet_cashOnDelivery.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
        self.selectedIndexPath = nil
        self.tblView.reloadData()
    }
    
    @IBAction func btnAction_cashOnDelivery(_ sender: UIButton) {
        if self.btnOutlet_cashOnDelivery.image(for: .normal) == #imageLiteral(resourceName: "Checkbox-click"){
            self.btnOutlet_cashOnDelivery.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
            paymentMethod = ""
        }else{
            self.btnOutlet_cashOnDelivery.setImage(#imageLiteral(resourceName: "Checkbox-click"), for: .normal)
            paymentMethod = "Cash"
        }
        self.cardId = nil
        self.btnOutlet_paypal.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
        self.selectedIndexPath = nil
        self.tblView.reloadData()
    }
    
    @IBAction func btnAction_placeMyorder(_ sender: UIButton) {
        if paymentMethod == "Paypal"{
            getBrainTreeToken()
        }else{
            callPaymentApi()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func payUsingPaypal(){
        let request =  BTDropInRequest()
        request.applePayDisabled = true
        let dropIn = BTDropInController(authorization: toKinizationKey, request: request)
        { [unowned self] (controller, result, error) in
            
            if let error = error {
                self.show(message: error.localizedDescription)
                
            } else if (result?.isCancelled == true) {
                self.show(message: "Transaction Cancelled")
                
            } else if let nonce = result?.paymentMethod?.nonce {
                self.callPayPalAPi(nounce:nonce)
               // self.sendRequestPaymentToServer(nonce: nonce, amount: "10")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
        self.present(dropIn!, animated: true, completion: nil)
    }
    
//    func sendRequestPaymentToServer(nonce: String, amount: String) {
//       // activityIndicator.startAnimating()
//
//        let paymentURL = URL(string: "http://localhost/donate/pay.php")!
//        var request = URLRequest(url: paymentURL)
//        request.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: String.Encoding.utf8)
//        request.httpMethod = "POST"
//
//        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
//            guard let data = data else {
//                self?.show(message: error!.localizedDescription)
//                return
//            }
//
//            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = result?["success"] as? Bool, success == true else {
//                self?.show(message: "Transaction failed. Please try again.")
//                return
//            }
//
//            self?.show(message: "Successfully charged. Thanks So Much :)")
//            }.resume()
//    }
    
    func callPayPalAPi(nounce:String)
    {
        var email = ""
        if let s = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.email.rawValue) as? String{
            email = s
        }
        var firstName = ""
        if let s = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.firstName.rawValue) as? String{
            firstName = s
        }
        
        var lastName : String?
        if let s = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.lastName.rawValue) as? String{
            lastName = s
        }
        
        APIManager.shared.postRequest(with: LoginEndpoint.brainTreePayment(TokenKey: CommonMethodsClass.getDeviceToken(), Payment_Method_Nonce: nounce, Amount: amount, orderId: orderId, Customer_First_Name: firstName, Customer_Last_Name: lastName, Customer_Email: email,CallingChannel: "App")) { (response) in
            self.brainTreePayment(response : response)
        }
    }
    
    func brainTreePayment(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let resultDic  = dict.object(forKey: "Result_Output") as? NSDictionary
                {
                    if let value  = resultDic.object(forKey: "success") as? Bool
                    {
                        if value == true{
                           CommonMethodsClass.showAlertWithSingleButton(title: "" , msg: "Payment successful" , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                        }else{
                            show(message: "Payment unsuccessful.Check credentials")
                        }
                    }else{
                        show(message: resultDic.object(forKey: "message") as? String ?? "Payment unsuccessful.Check credentials")
                    }
                    
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    func show(message: String) {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // get brain tree token api
    func getBrainTreeToken(){
        APIManager.shared.request(with: LoginEndpoint.createBrainToken(TokenKey: CommonMethodsClass.getDeviceToken())) { (response) in
            self.createBrainTokenApiResponse(response : response)
        }
    }
    
    
    func createBrainTokenApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let token = dict.object(forKey: Keys.brainTreeToken.rawValue) as? String
                {
                   toKinizationKey = token
                    self.payUsingPaypal()
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    //MARK:- Call payment api
    func callPaymentApi()
    {
        if self.paymentMethod == "Card"{
            let stripeCustomerId = APIConstants.getStripeCustomerId()
            APIManager.shared.request(with: LoginEndpoint.stripePayment(TokenKey: CommonMethodsClass.getDeviceToken(), Price: Int(amount * 100), Stripe_Customer_Id: stripeCustomerId, Stripe_Card_Id: self.cardId, Order_Id: self.orderId,CallingChannel: "App")) { (response) in
                self.handlePaymentApiResponse(response : response)
            }
        }else if self.paymentMethod == "Cash"{
            APIManager.shared.request(with: LoginEndpoint.payment(TokenKey: CommonMethodsClass.getDeviceToken(), Order_id: self.orderId, Stripe_Cardid: nil, Payment_Method: self.paymentMethod), completion: { (response) in
                            self.handlePaymentApiResponse(response : response)
            })
        }
    }
    
    func handlePaymentApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let msg = dict.object(forKey: Keys.message.rawValue) as? NSDictionary
                {
                    if self.paymentMethod == "Card"{
                        if let paid = msg.object(forKey: "paid") as? Bool
                        {
                            if paid == true{
                                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Payment succesfully done", vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                            }
                            else{
                                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Payment unsucessfull", vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                            }
                        }
                    }
                }else{
                    if let msg = dict.object(forKey: Keys.message.rawValue) as? String
                    {
                        if self.paymentMethod == "Cash"{
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                        }
                    }
                   
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    
    ///api get cards call
    
    func getCardList(){
//        var customerId : Int?
//        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
//            customerId = customer_id
//        }
        var Stripe_Customer_Id : String?
        if let Stripe_CustomerId = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.Stripe_Customer_Id.rawValue) as? String{
            Stripe_Customer_Id = Stripe_CustomerId
        }
//        APIManager.shared.request(with: LoginEndpoint.getCardListFromStripe(customer: nil, ending_before: nil, limit: nil, starting_after: nil)){[weak self] (response) in
//
//            self?.handleGetCardsResponse(response: response)
//        }

        APIManager.shared.request(with: LoginEndpoint.getCardList(TokenKey:  CommonMethodsClass.getDeviceToken(), Customer_id: Stripe_Customer_Id)){[weak self] (response) in
            self?.handleGetCardsResponse(response: response)
        }
    }
    
    func handleGetCardsResponse(response : Response){
        switch response {
        case .success(let responseValue):
            
          
            if let dict = responseValue as? CardListModel
            {
                if let add = dict.data
                {
                    arrCards = add
                }
                self.tblView.reloadData()
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
}

extension CompleteYourPaymentVC : UITableViewDataSource, UITableViewDelegate,DelegateFromSingleAlert{
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
         
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderStatus_VC") as! OrderStatus_VC
            vc.orderId = self.orderId
            vc.fromPayment = true
            vc.restId = self.restId ?? 0
            vc.restaurantNumber = self.restaturantNumber
            self.navigationController?.pushViewController(vc, animated: true)
//            let vc = StoryboardScene.Main.instantiateHome_ViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardTableCell") as! PaymentCardTableCell
        let model = self.arrCards[indexPath.row]
        let name = ((model.name ?? "").capitalizedFirst())
        let last4 = model.last4 ?? ""
        let text = name + "****" + last4 + "  Exp " + "\(model.exp_month ?? 0)"
        cell.lbl_visaNoExpiry.text = text
        if indexPath == selectedIndexPath{
            cell.imgVw_card.image = #imageLiteral(resourceName: "Card-bg")
            cell.btnOutlet_selectCard.setImage(#imageLiteral(resourceName: "Checkbox-click"), for: .normal)
            cell.btnOutlet_arrow.setImage(#imageLiteral(resourceName: "arrow-up"), for: .normal)
        }else{
            cell.imgVw_card.image = nil
            cell.btnOutlet_selectCard.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
            cell.btnOutlet_arrow.setImage(#imageLiteral(resourceName: "arrow-down"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAtIndexPath was called")
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath! == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        }
        paymentMethod = "Card"
        self.cardId = self.arrCards[indexPath.row].id
        self.btnOutlet_paypal.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
        self.btnOutlet_cashOnDelivery.setImage(#imageLiteral(resourceName: "check-box"), for: .normal)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let smallHeight: CGFloat = 60.0
        let expandedHeight: CGFloat = 200.0
        let ip = indexPath
        if selectedIndexPath != nil {
            if ip == selectedIndexPath! {
                return expandedHeight
            } else {
                return smallHeight
            }
        } else {
            return smallHeight
        }
    }
}
