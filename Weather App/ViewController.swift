//
//  ViewController.swift
//  Weather App
//
//  Created by Eliott Moreno on 1/4/17.
//  Copyright © 2017 Eliott Moreno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var webView: UIWebView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet var weatherForecastLabel: UILabel!

    @IBOutlet var city: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }

    @IBAction func checkWeather(_ sender: Any) {
        
        var realCity = NSString(string: city.text!)
        
        realCity = realCity.replacingOccurrences(of: " ", with: "-") as NSString
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/\(realCity)/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
        
            var fail = false
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                
                data, response, error in
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if  httpResponse.statusCode != 200 {
                        DispatchQueue.main.sync(execute:{
                        fail = true
                        self.weatherForecastLabel.text = "Please enter a real city."
                        })
                        
                    }
                }
                
                if error != nil || fail == true {
                
                    
                    
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        
                        
                        DispatchQueue.main.sync(execute: {
                            
                        
                         let check = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                            
                         
                         let myArrayOfWeather = dataString?.components(separatedBy: check)[1]
                            
                     var myRealArrayOfWeather = myArrayOfWeather?.components(separatedBy: "</span>")[0]
                            
                            
                            myRealArrayOfWeather = myRealArrayOfWeather?.replacingOccurrences(of: "&deg;", with: "°")
                            
                            
                        self.weatherForecastLabel.text = myRealArrayOfWeather
                            
                        })
                    }
                }
            }
            task.resume()
        }
        
    }
}

