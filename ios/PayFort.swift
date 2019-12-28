//
//  PayFortManager.swift
//  RNPayFortDemo
//
//  Created by BhavinR on 13/12/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import UIKit

@objc(PayFort)
class PayFort: NSObject {
  
  @objc func Pay(_ dataDict:String,successCallback:@escaping(NSObject) -> (), errorCallback:@escaping(NSObject) -> ()) {
    let testUrl = "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
    let productionUrl = "https://paymentservices.payfort.com/FortAPI/paymentApi"
    var vc:UIViewController!
    var dataDictionary:NSDictionary!
    let dataDictonary:NSDictionary = convertToDictionary(text: dataDict)! as NSDictionary
    
    let request_string = dataDictonary.object(forKey: "sha_request_phrase") as! String
    
    let access_code = dataDictonary.object(forKey: "access_code") as! String
   
    let purchase = dataDictonary.object(forKey: "command") as! String
  
    let merchant_identifier = dataDictonary.object(forKey: "merchant_identifier") as! String
    
    let amount = dataDictonary.object(forKey: "amount") as! NSNumber
    
    let currencyType = dataDictonary.object(forKey: "currencyType") as! String
    
    let language = dataDictonary.object(forKey: "language") as! String
    
    let email = dataDictonary.object(forKey: "email") as! String
    
    let testing = dataDictonary.object(forKey: "testing") as! Bool
    
   

    let payFort = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
   
    payFort?.setPayFortCustomViewNib("PayFortView2")
    
    DispatchQueue.main.async(execute: {
      vc = UIApplication.shared.windows.first?.rootViewController
    })
    
    
      
    var post = ""
    post = post.appending("\(request_string)access_code=\(access_code)")
    post = post.appending("device_id=\(payFort!.getUDID()!)")
    post = post.appending("language=\("en")")
    post = post.appending("merchant_identifier=\(merchant_identifier)")
    post = post.appending("service_command=SDK_TOKEN\(request_string)")
    let data = ccSha256(data: post.data(using: .utf8)!)
    let data1 = "\(data.map { String(format: "%02hhx", $0) }.joined())"
    
    var dictParam: [String: String] = [:]
    dictParam = ["service_command":"SDK_TOKEN",
                 "access_code":access_code,
                 "device_id": payFort?.getUDID()!,
                 "merchant_identifier":merchant_identifier,
                 "language": "en",
                 "signature":data1] as! [String:String]
    
    do {
      let postData = try JSONSerialization.data(withJSONObject: dictParam, options: .prettyPrinted)
      let tokenAPIEndpoint = testing ? testUrl : productionUrl
      guard let url = URL(string: tokenAPIEndpoint) else {
        print("invalid url")
        return
      }
      var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
      request.httpBody = postData
      let length = postData.count
      request.httpMethod = "POST"
      request.addValue("\(length)", forHTTPHeaderField: "Content-Length")
      request.addValue("application/json", forHTTPHeaderField: "Accept")
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
          print("we have encountered an error == \(error.localizedDescription)")
        }
        guard let data = data else {
          return
        }
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
          print("json == \(json)")
          if let dict = json as? Dictionary<String, AnyObject> {
            if let status = dict["status"] as? String {
              if status == "22" {
                //succesfully get token start payment
                if let SDKToken = dict["sdk_token"] as? String {
                  let request:NSMutableDictionary = NSMutableDictionary()
                  request.setValue(purchase, forKey: "command")
                  request.setValue(amount
                    , forKey: "amount")
                  request.setValue(currencyType, forKey: "currency")
                  request.setValue(email, forKey: "customer_email")
                  request.setValue(language, forKey: "language")
                  request.setValue(arc4random(), forKey: "merchant_reference")//should be unique
                  request.setValue(SDKToken , forKey: "sdk_token")
                  if let payment_option = dataDictonary.object(forKey: "payment_option")
                  {
                    request.setValue(payment_option , forKey: "payment_option")
                  }
                  if let eci = dataDictonary.object(forKey: "eci")
                  {
                    request.setValue(eci , forKey: "eci")
                  }
                  
                  if let order_description = dataDictonary.object(forKey: "order_description")
                  {
                    request.setValue(order_description , forKey: "order_description")
                  }
                  
                  if let customer_ip = dataDictonary.object(forKey: "customer_ip")
                  {
                    request.setValue(customer_ip , forKey: "customer_ip")
                  }
                  if let customer_name = dataDictonary.object(forKey: "customer_name")
                  {
                    request.setValue(customer_name , forKey: "customer_name")
                  }
                  
                  if let phone_number = dataDictonary.object(forKey: "phone_number")
                  {
                    request.setValue(phone_number , forKey: "phone_number")
                  }
                  
                  if let settlement_reference = dataDictonary.object(forKey: "settlement_reference")
                  {
                    request.setValue(settlement_reference , forKey: "settlement_reference")
                  }
                  
                  if let merchant_extra = dataDictonary.object(forKey: "merchant_extra")
                  {
                    request.setValue(merchant_extra , forKey: "merchant_extra")
                  }
                  
                  if let merchant_extra1 = dataDictonary.object(forKey: "merchant_extra1")
                  {
                    request.setValue(merchant_extra1 , forKey: "merchant_extra1")
                  }
                  
                  if let merchant_extra2 = dataDictonary.object(forKey: "merchant_extra2")
                  {
                    request.setValue(merchant_extra2, forKey: "merchant_extra2")
                  }
                  
                  if let merchant_extra3 = dataDictonary.object(forKey: "merchant_extra3")
                  {
                    request.setValue(merchant_extra3, forKey: "merchant_extra3")
                  }
                  
                  if let merchant_extra4 = dataDictonary.object(forKey: "merchant_extra4")
                  {
                    request.setValue(merchant_extra4, forKey: "merchant_extra4")
                  }
                  
                  if let token_name = dataDictonary.object(forKey: "token_name")
                  {
                    request.setValue(token_name, forKey: "token_name")
                  }
                  DispatchQueue.main.async {
                    payFort?.callPayFort(withRequest: request, currentViewController: vc, success: { (reqDict, resDict) in
                      
                      dataDictionary = resDict! as NSDictionary
                      successCallback([dataDictionary] as NSObject)
                    }, canceled: { (reqDict, resDict) in
                      
                    }, faild: { (reqDict, resDict, message) in
                      dataDictionary = resDict! as NSDictionary
                      errorCallback([dataDictionary] as NSObject)
                    })
                  }
                  payFort?.isShowResponsePage = true
                }
              }
            } else {
              print("token creation failed")
              errorCallback(["error":"token creation failed"] as NSObject)
            }
          }
        } catch let error {
          print("We have error decoding == \(error.localizedDescription)")
          errorCallback(error as NSObject)
        }
      }.resume()
    } catch let error {
      print("error creating json from paramDict, == \(error.localizedDescription)")
      errorCallback(error as NSObject)
    }
  }
  
  
  func ccSha256(data: Data) -> Data {
    var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = digest.withUnsafeMutableBytes { (digestBytes) in
      data.withUnsafeBytes { (stringBytes) in
        CC_SHA256(stringBytes, CC_LONG(data.count), digestBytes)
      }
    }
    return digest
  }
  
  func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      } catch {
        print(error.localizedDescription)
      }
    }
    return nil
  }
  
}
