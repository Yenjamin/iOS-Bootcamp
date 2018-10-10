//
//  ViewController.swift
//  D07
//
//  Created by Yen-Ho CHEN on 2018/10/10.
//  Copyright © 2018 Yen-Ho CHEN. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    var bot : RecastAIClient?
    let client = DarkSkyClient(apiKey: "e190ce707d609554cc3f1aaf158c5869")
    
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var respondText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bot = RecastAIClient(token : "8af1b442478b01c9a5da731f866cb88e")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirmationButton(_ sender: UIButton) {
        makeRequest(request: respondText.text!)
    }
    
    func makeRequest(request: String)
    {
        self.bot?.textRequest(request, successHandler: recastRequestDone(_:), failureHandle: recastRequestError(_:))
    }
    
    func recastRequestDone(_ response : Response)
    {
        var location = response.get(entity: "location")
        if let myLat = location?["lat"]
        {
            let myLon = location?["lng"]
            client.getForecast(latitude: myLat as! Double, longitude: myLon as! Double) { result in                switch result {
                    case .success(let currentForecast, let requestMetadata):
                    DispatchQueue.main.async
                    {
                        self.replyLabel.text = currentForecast.currently?.summary
                    }
                    case .failure(let error):
                    print(error)
                    self.replyLabel.text = "error"
                }
            }

        }
        else
        {
            self.replyLabel.text = "no location found"
        }
    }
    
    func recastRequestError(_ error : Error)
    {
    }


}

