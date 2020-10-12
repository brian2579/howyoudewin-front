//
//  ViewController.swift
//  howyoudewin-front
//
//  Created by Brian Kiefer on 10/4/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var btnGetData: UIButton!
    var resultClick:String!
    var resultTemp:String!
    var resultMeter:String!
    var resultDewPt:String!
    
    var myDictionary = [String:String]()
    
    
    @IBOutlet weak var lblMeter: UILabel!
    
    @IBOutlet weak var lblTemperature: UILabel!
    
    @IBOutlet weak var imgCity: UIImageView!
    
    @IBOutlet weak var lblDewPt: UILabel!
    
    @IBOutlet weak var lblDewPtTemp: UILabel!
    
    @IBOutlet weak var lblRealFeel: UILabel!
    
    @IBAction func btnGetData(_ sender: Any) {
        //print("hi")
        
        getDewPtData(isToday: false)
        self.lblResult.text = resultClick
        self.lblTemperature.text = resultTemp
        self.lblMeter.text = resultMeter
        self.lblDewPtTemp.text = resultDewPt
        self.imgCity.isHidden = false
        self.lblDewPtTemp.isHidden = false
        self.lblDewPt.isHidden = false
        self.lblRealFeel.isHidden = false
        
    }
    
    //This function makes a call to the hyd backend API to retrieve weather info. The call expcets long/lat as an input to get the weather api. As this is a simple POC for hobby/learning purposes, the code will make a random call for preset location. The istoday parameter will ensure that the intial call will go to my current locaion of phoenixville. Hopr you enjoy this code!
    
    func getDewPtData(isToday: Bool){
        
        //reset the screen before making API calls
        self.lblResult.text = ""
        self.lblTemperature.text = ""
        self.lblMeter.text = ""
        self.lblDewPtTemp.text = ""
        
        //default the value to the default call
        var number = 0
        
        
        //host variable is the location of the backend service. Hardcoding is not a great practice but suffcient for my POC. Ideally it would hit a static URL
        
        let host = "35.173.139.187:8081"
        // let host = "localhost:8081"
        //Default the URL to ensure results, again this is a POC
        var url = URL(string: "http://" + host + "/today")
        
        //A few selcted coordinates in the US representing North, South, East, West parts of the country
        if !isToday {
            myDictionary["0"] = "http://" + host + "/today"
            myDictionary["1"] = "http://" + host + "/today?x=36.153980,-95.992775"
            myDictionary["2"] = "http://" + host + "/today?x=31.756439,-106.489723"
            myDictionary["3"] = "http://" + host + "/today?x=30.844818,-83.287129"
            myDictionary["4"] = "http://" + host + "/today?x=33.677059,-93.604898"
            myDictionary["5"] = "http://" + host + "/today?x=25.719054,-80.298430"
            myDictionary["6"] = "http://" + host + "/today?x=35.047685,-106.600812"
            myDictionary["7"] = "http://" + host + "/today?x=45.826125,-115.436358"
            myDictionary["8"] = "http://" + host + "/today?x=43.513545,-72.401988"
            
            number = Int.random(in: 0...8)
            url = URL(string: myDictionary[String(number)] ?? "0")
        }
        
        print(number)
        
        print(url)
        
        
        //Make API Call, alot more to do with error handling, reporting, and tracing
        //TODO: Trace response from Client to server and log in a visual
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            //Process Reponse and assign to UI Fields
            if let data = data{
                
                print(data.description)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                {
                    print(json.self)
                    //let z = json["results.city"] as! String;
                    let hyd = json["results"] as! [[String:Any]]
                    for item in hyd {
                        print (item["city"] as! String)
                        self.resultClick = item["city"] as! String
                        self.resultMeter = item["currentFeeling"] as! String
                        var x:Int = 0
                        x = item["apparentTemp"] as! Int
                        
                        self.resultTemp = String(x)
                        var y:Int = 0
                        y = item["currentDewpoint"] as! Int
                        
                        self.resultDewPt = String(y)
                        
                        
                        
                    }
                    
                    
                }
                
            }
        })
        task.resume()
        
        //Assign resultset to UI Fields
        self.lblResult.text = resultClick
        self.lblTemperature.text = resultTemp
        self.lblMeter.text = resultMeter
        self.lblDewPtTemp.text = resultDewPt
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This is to open the app with the first call to the default city
        getDewPtData(isToday: true)
        
        
        
    }
    
    
    
    
    
}

