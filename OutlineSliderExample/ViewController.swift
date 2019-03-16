//
//  ViewController.swift
//  OutlineSliderExample
//
//  Created by Ralf Ebert on 11.03.19.
//  Copyright © 2019 Ralf Ebert. All rights reserved.
//

import OutlineSlider
import UIKit

class ViewController: UIViewController {

    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var slider: OutlineSliderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func valueChanged() {
        self.valueLabel.text = "Value change: \(self.slider.value)"
    }
}
