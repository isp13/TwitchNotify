//
//  QuotesViewController.swift
//  Quotes
//
//  Created by Никита on 11.08.2018.
//  Copyright © 2018 Sinapsic. All rights reserved.
//

import Cocoa
import Foundation
public var changeSegueId="0"


class QuotesViewController: NSViewController {
    @IBOutlet var showinfo: NSTextField!
    @IBOutlet var streamLabel: NSTextField!
    @IBOutlet var StreamerInput: NSTextField!
    @IBOutlet var setNickBttn: NSButton!
    @IBOutlet var saveBttn: NSButton!
    var streamername=""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
extension QuotesViewController {
    @IBAction func setNicknamevalue(_ sender: NSButton) {
       
        streamername = self.StreamerInput.stringValue
        
        
    }
    
    @IBAction func saveall(_ sender: NSButton) {//main thing to refresh all
        checkstreamer(streamername:streamername)
        sleep(1)
        if changeSegueId == "1"
        {
            self.showinfo.stringValue=streamername+" is live now!"
        }
        else
        {
            self.showinfo.stringValue=streamername+" is offline =("
        }
        
    }
}
    
func convertToDictionary(from text: String) -> [String: String]? {
    guard let data = text.data(using: .utf8) else { return nil }
    let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
    return anyResult as? [String: String]
}
   



extension QuotesViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> QuotesViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "QuotesViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? QuotesViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

func stringify(json: Any, prettyPrinted: Bool = false) -> String {
    var options: JSONSerialization.WritingOptions = []
    if prettyPrinted {
        options = JSONSerialization.WritingOptions.prettyPrinted
    }
    
    do {
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch {
        print(error)
    }
    
    return ""
}

func checkstreamer( streamername:String){
    changeSegueId = "0"
    let TWITCH_STREAMER_INFO="https://api.twitch.tv/kraken/streams/"
    let STREAMER_NAME=streamername
    let TWITCH_KEY="?client_id=25mvgjso3sywfysrr52tiyagm6ymek"
    let TWITCH_REQUEST=TWITCH_STREAMER_INFO+STREAMER_NAME+TWITCH_KEY
    
    guard let url=URL(string:TWITCH_REQUEST) else {return}
    let session = URLSession.shared
    session.dataTask(with: url) {(data,response,error)in
        if let response = response as? HTTPURLResponse{
            
            
            
            
        }
        
        guard let data=data else {return}
        print(data)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            let str=stringify(json: json)
            
            if str.contains("\u{22}stream_type\u{22}:\u{22}live\u{22}") {
                print("online")
               
                changeSegueId = "1"
            }
            else
            {
                print("offline")
                changeSegueId = "0"
                
            }
        }catch{
            print(error)
        }
        }.resume()
    
}


