//
//  ViewController.swift
//  Lab1
//
//  Created by Haoran Song on 9/7/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        reset()
    }
    
    func reset(){
        notfoundstate.isHidden = true
        saleprice.isHidden = true
        pricelabel.font = pricelabel.font.withSize(CGFloat(17))
        manuallyTF.isHidden = true
        wrong_enter_tax.text = ""
        saleprice.text = "$0.00"
        tax.isHidden = true
    }
    
    var tax_flag = false
    
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var discountTF: UITextField!
    
    @IBAction func PriceInput(_ sender: UITextField) {
        if let price = priceTF.text
        {
            let error = isvalidprice(price)
            if error != "" {
                priceerror.text = error
                pricelabel.attributedText = nil
                pricelabel.text = "$0.00"
                saleprice.isHidden = true
                pricelabel.font = pricelabel.font.withSize(CGFloat(17))
                totallabel.text = "$0.00"
            }
            else{
                priceerror.text = ""
                let my = Double(price)
                let outputprice =  "$\(String(format: "%.2f", my!))"
                let discount = discountlabel.text
                if(discount! != "0.00"){
                    saleprice.isHidden = false
                    pricelabel.font = pricelabel.font.withSize(CGFloat(11))
                    let sale = my! -  (my!)*Double(discount!)!/100
                    saleprice.text = "$" +  String(format: "%.2f", sale)
                    let testAttributes = [NSAttributedString.Key.strikethroughStyle:1] as [NSAttributedString.Key : Any]
                    let testAttributeString = NSAttributedString(string: String(outputprice), attributes:testAttributes)
                    pricelabel.attributedText = testAttributeString
                    let characterSet = CharacterSet(charactersIn: "%")
                    print(tax_flag)
                    if(tax_flag == false){
                        var taxcount = taxlabel.text
                        taxcount = taxcount!.trimmingCharacters(in: characterSet)
                        totallabel.text = "$" + String(format: "%.2f", sale * (1+Double(taxcount!)!/100))
                    }
                    else{
                        let taxcount = manuallyTF.text
                        totallabel.text = "$" + String(format: "%.2f", sale * (1+(Double(taxcount ?? "0.00") ?? 0.00)/100))
                    }
                }
                else{
                    pricelabel.text = String(outputprice)
                    let characterSet = CharacterSet(charactersIn: "$%")
                    let finalprice = outputprice.trimmingCharacters(in: characterSet)
                    if(tax_flag == false){
                        var taxcount = taxlabel.text
                        taxcount = taxcount!.trimmingCharacters(in: characterSet)
                        totallabel.text = "$" + String(format: "%.2f", Double(finalprice)! * (1+Double(taxcount!)!/100))
                    }
                    else{
                        let taxcount = manuallyTF.text
                        totallabel.text = "$" + String(format: "%.2f", Double(finalprice)! * (1+(Double(taxcount ?? "0.00") ?? 0.00)/100))
                    }
                }
            }
        }
        
        if(sender.text == ""){
            pricelabel.text = "$0.00";
            saleprice.text = "$0.00"
        }
        
    }
    @IBAction func DiscountInput(_ sender: UITextField) {
        if let discount = discountTF.text
        {
            let error = isvaliddiscount(discount)
            if error != "" {
                discounterror.text = error
                saleprice.text = "$0.00"
                discountlabel.text = "0.00"
                totallabel.text = "$0.00"
                saleprice.isHidden = true
                pricelabel.font = pricelabel.font.withSize(CGFloat(17))
                let temp = pricelabel.text
                pricelabel.attributedText = nil
                pricelabel.text = temp
                totallabel.text = "$0.00"
            }
            else{
                discounterror.text = ""
                var price = pricelabel.text!
                discountlabel.text = discount
                let characterSet = CharacterSet(charactersIn: "$")
                price = price.trimmingCharacters(in: characterSet)
                if(price != ""){
                    let doubleprice = Double(price)
                    let sale = doubleprice! -  (doubleprice!)*Double(discount)!/100
                    saleprice.text = "$" +  String(format: "%.2f", sale)
                    let characterSet = CharacterSet(charactersIn: "%")
                    if(tax_flag == false){
                        var taxcount = taxlabel.text
                        taxcount = taxcount!.trimmingCharacters(in: characterSet)
                        totallabel.text = "$" + String(format: "%.2f", sale * (1+Double(taxcount!)!/100))
                    }
                    else{
                        var taxcount = manuallyTF.text
                        taxcount = taxcount!.trimmingCharacters(in: characterSet)
                        totallabel.text = "$" + String(format: "%.2f", sale * (1+(Double(taxcount ?? "0.00") ?? 0.00)/100))
                    }

                }
                else{
                    saleprice.text = "$0.00"
                }
                saleprice.isHidden = false
                let testAttributes = [NSAttributedString.Key.strikethroughStyle:1] as [NSAttributedString.Key : Any]
                let testAttributeString = NSAttributedString(string: String("$" + price), attributes:testAttributes)
                pricelabel.attributedText = testAttributeString
                pricelabel.font = pricelabel.font.withSize(CGFloat(11))
                
            }
        }

    }
    
    
    @IBAction func enter_tax_button(_ sender: Any) {
        taxlabel.isHidden = true
        manuallyTF.isHidden = false
        notfoundstate.isHidden = true
        tax.isHidden = false
        tax_flag = true
        totallabel.text = "$0.00"
    }
    
    @IBAction func entet_tax(_ sender: Any) {
        if let discount = manuallyTF.text
        {
            let error = isvaliddiscount(discount)
            if error != "" {
                wrong_enter_tax.text = error
                totallabel.text = "$0.00"
            }
            else{
                wrong_enter_tax.text = ""
                var sale = saleprice.text!
                if(sale == "$0.00"){
                    sale = pricelabel.text!
                }
                let characterSet = CharacterSet(charactersIn: "$")
                sale = sale.trimmingCharacters(in: characterSet)
                let saleprice = Double(sale)
                let taxcount = manuallyTF.text
                
                totallabel.text = "$" + String(format: "%.2f", saleprice! * (1+(Double(taxcount ?? "0.00") ?? 0.00)/100))
            }
        }
    }
    
    func isvalidprice(_ value: String) -> String?
    {
        let validprice = "^[0-9]+([.][0-9]{1,20})?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", validprice)
        if !predicate.evaluate(with: value)
        {
            let warn = NSLocalizedString("Invalid Price", comment: "invalidprice")
            return warn
        }
        else{
            if Double(value)!>100000{
                let warn = NSLocalizedString("That's too much", comment: "invalidprice")
                return warn
            }
        }

        return ""
    }
    
    func isvaliddiscount(_ value: String) -> String?
    {
        let validdiscount = "^[0-9]+([.][0-9]{1,20})?$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", validdiscount)
        if !predicate.evaluate(with: value)
        {
            let warn = NSLocalizedString("Invalid discount", comment: "invaliddiscount")
            return warn
        }
        else{
            let temp = Double(value)!
            if temp > 100{
                let warn = NSLocalizedString("Invalid discount", comment: "invaliddiscount")
                return warn
            }
        }
        return ""
    }

    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var getlocation: UILabel!
    
    @IBOutlet weak var discounterror: UILabel!
    @IBOutlet weak var priceerror: UILabel!
    @IBOutlet weak var txtnumber: UITextField!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var totallabel: UILabel!
    @IBOutlet weak var saleprice: UILabel!
    @IBOutlet weak var discountlabel: UILabel!
    @IBOutlet weak var locationlabel: UIButton!

    @IBOutlet weak var wrong_enter_tax: UILabel!
    @IBOutlet weak var manuallyTF: UITextField!
    @IBOutlet weak var taxlabel: UILabel!
    @IBAction func getlocation(_ sender: Any) {
        manuallyTF.isHidden = true
        tax_flag = false
        manuallyTF.text = ""
        taxlabel.isHidden = false
        totallabel.text = "$0.00"
        tax.isHidden = true
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager!.startUpdatingLocation()
            let characterSet = CharacterSet(charactersIn: "%")
            var taxcount = taxlabel.text
            taxcount = taxcount!.trimmingCharacters(in: characterSet)
            let characterSet2 = CharacterSet(charactersIn: "$")
            var sale = saleprice.text!
            if(sale == "$0.00"){
                sale = pricelabel.text!
            }
            sale = sale.trimmingCharacters(in: characterSet2)
            let salep = Double(sale)
            let test = salep! * (1+(Double(taxcount!)!)/100)
            totallabel.text = "$" + String(format: "%.2f", test)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        let staterate:[String:String] = [
            "AL":"11%",
            "AK":"7.5%",
            "AZ":"11.2%",
            "AR":"11.5%",
            "CA":"10.25%",
            "CO":"11.2%",
            "CT":"6.35%",
            "DE":"0.00%",
            "FL":"8.00%",
            "GA":"9.00%",
            "HI":"4.50%",
            "ID":"9.00%",
            "IL":"11.00%",
            "IN":"7.00%",
            "IA":"8.00%",
            "KS":"10.60%",
            "KY":"6.00%",
            "LA":"11.45%",
            "ME":"5.50%",
            "MD":"6.00%",
            "MA":"6.25%",
            "MI":"6.00%",
            "MN":"8.38%",
            "MS":"8.00%",
            "MO":"10.10%",
            "MT":"0.00%",
            "NE":"7.50%",
            "NV":"8.27%",
            "NH":"0.00%",
            "NJ":"6.63%",
            "NM":"9.06%",
            "NY":"8.88%",
            "NC":"7.50%",
            "ND":"8.50%",
            "OH":"8.00%",
            "OK":"11.50%",
            "OR":"0.00%",
            "PA":"8.00%",
            "RI":"7.00%",
            "SC":"9.00%",
            "SD":"6.50%",
            "TN":"10.00%",
            "TX":"8.25%",
            "UT":"8.70%",
            "VT":"7.00%",
            "VA":"7.00%",
            "WA":"10.40%",
            "WV":"7.00%",
            "WI":"5.60%",
            "WY":"6.00%",
            ]
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation){ [self]
            (placemarks,error) in
            if(error != nil){
                print("error")
            }
            let placemark = placemarks! as [CLPlacemark]
            if (placemark.count>0){
                let placemark = placemarks![0]
                
                let admin = placemark.administrativeArea ?? ""
                locationlabel.setTitle(String(format: NSLocalizedString("You're in: %@", comment: "location"), admin), for: .normal)
                if(staterate[admin] == nil){
                    notfoundstate.isHidden = false
                    taxlabel.text = "0.00%"
                    
                }
                else{
                    taxlabel.text = staterate[admin]
                }
                
                let characterSet = CharacterSet(charactersIn: "%")
                var taxcount = taxlabel.text
                taxcount = taxcount!.trimmingCharacters(in: characterSet)
                let characterSet2 = CharacterSet(charactersIn: "$")
                var sale = saleprice.text!
                if(sale == "$0.00"){
                    sale = pricelabel.text!
                }
                sale = sale.trimmingCharacters(in: characterSet2)
                let salep = Double(sale)
                let test = salep! * (1+(Double(taxcount!)!)/100)
                totallabel.text = "$" + String(format: "%.2f", test)
            }
        }
    }
    
    @IBOutlet weak var notfoundstate: UILabel!
    
    
    
}

