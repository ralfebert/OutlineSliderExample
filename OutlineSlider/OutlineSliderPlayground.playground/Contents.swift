//: A UIKit based Playground for presenting user interface

import OutlineSlider
import PlaygroundSupport
import UIKit

let view = UIView()

let slider = OutlineSliderView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = slider
