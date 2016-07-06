//
//  ViewController.swift
//  ExampleATScrollingNumbers
//
//  Created by Anoop tomar on 7/6/16.
//  Copyright © 2016 Devtechie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sampleView: ATScrollingNumbers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleView.value = 100
        sampleView.startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

