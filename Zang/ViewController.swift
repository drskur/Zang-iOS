//
//  ViewController.swift
//  Zang
//
//  Created by drskur on 2017. 6. 19..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://zangsisi.net").responseString { (res) in
            print(res)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

