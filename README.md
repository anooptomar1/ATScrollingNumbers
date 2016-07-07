# ATScrollingNumbers
----------

## Overview


**ATScrollingNumbers** is a subclass of UIView, written in Swift and can be used as drop in solution for scrolling number animation.   
   

![image](https://raw.githubusercontent.com/anooptomar1/ATScrollingNumbers/master/example.gif)

## Requirements

* iOS 8

## Installation

Just import ATScrollingNumbers.swift into your project

## Usage

```swift
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sampleView: ATScrollingNumbers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sampleView.value = 100
        sampleView.startAnimation()
    }
}
```

## Demo

Check out the Example project.

## Author

Anoop Tomar, anooptomar@gmail.com

## License

Usage is provided under the [MIT License](http://opensource.org/licenses/MIT)

