//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

enum Topics {
    case Movies, Famous
}

class ViewController: UIViewController {
    
    //hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    //copy fancy text quote to clipboard
    @IBAction func copyToClipboard(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = movieTitleLabel.text
    }
    
    //refresh view
    @IBAction func refreshQuote(sender: AnyObject) {
        self.viewDidLoad()
    }
    
    var topic: Topics = Topics.Movies
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        
        var sentence = ""
        
        //getting random quote
        let apiToContact = "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=\(String(topic))&mashape-key=NGCfVMNnMEmshogbn7PorFlf7NCep1gt4OGjsnwhcCCg6rl9f0"
        Alamofire.request(.POST, apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)

                    sentence = json["quote"].stringValue
                    print("\(sentence)")
                    
                    //calling transform text API method
                    self.transformText(sentence)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    // transform given String to fancy text
    func transformText(sentence: String) -> String {
        
        var fancyText = ""
        var apiToContact2 = "https://ajith-Fancy-text-v1.p.mashape.com/text?text=\(sentence)&mashape-key=NGCfVMNnMEmshogbn7PorFlf7NCep1gt4OGjsnwhcCCg6rl9f0"
        apiToContact2 = apiToContact2.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!

        Alamofire.request(.GET, apiToContact2).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json2 = JSON(value)
                    
                    fancyText = json2["fancytext"].stringValue
                    self.movieTitleLabel.text = fancyText
                }
            case .Failure(let error):
                print(error)
            }
        }
        return fancyText
    }
    
    // change between the 2 options given by the API
    @IBAction func changeTopic(sender: AnyObject) {
        if topic == Topics.Movies{
            topic = Topics.Famous
        } else{
            topic = Topics.Movies
        }
        self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

