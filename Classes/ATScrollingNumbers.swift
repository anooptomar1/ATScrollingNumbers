//
//  ATScrollingNumbers.swift
//  TableViewExamples
//
//  Created by Anoop tomar on 7/4/16.
//  Copyright © 2016 Devtechie. All rights reserved.
//

import UIKit

class ATScrollingNumbers: UIView{
    var value: Int?
    var textColor: UIColor?
    var font: UIFont?
    var duration: CFTimeInterval?
    var durationOffset: CFTimeInterval?
    var density: Int?
    var scrollDown: Bool?
    var makeCircularBorder: Bool?
    var viewBorderColor: UIColor?
    var viewBorderWidth: CGFloat?
    
    private var numbersArray: [String]?
    private var layersArray: [CALayer]?
    private var layerContentArray: [UILabel]?
    private var centerView: UIView!
    private var circleLayerArray: [CAShapeLayer]?
    private var baseLayer: CAShapeLayer?
    private var baseView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaults()
    }
    
    // MARK: public functions
    func startAnimation(){
        prepareForAnimation()
        createAnimation()
    }
    
    func stopAnimation(){
        for layer in layersArray!{
            layer.removeAnimationForKey("ATScrollingNumbers")
        }
    }
    
    // MARK: Internal functions
    private func defaults(){
        duration = 5.0
        durationOffset = 0.2
        density = 30
        scrollDown = true
        makeCircularBorder = true
        viewBorderWidth = 1
        viewBorderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        
        font = UIFont.systemFontOfSize(30, weight: UIFontWeightLight)
        textColor = UIColor.lightGrayColor()
        
        numbersArray = [String]()
        layerContentArray = [UILabel]()
        layersArray = [CALayer]()
        circleLayerArray = [CAShapeLayer]()
        
        createbaseView()
    }
    
    private func createbaseView(){
        baseView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame) * 0.9, CGRectGetHeight(self.frame) * 0.9))
        baseView.center = CGPoint(x: CGRectGetWidth(self.frame) / 2, y: CGRectGetHeight(self.frame) / 2)
        addSubview(baseView)
        
        baseView.layer.borderWidth = viewBorderWidth!
        baseView.layer.borderColor = viewBorderColor!.CGColor
        
        if makeCircularBorder!{
            baseView.layer.cornerRadius = (min(CGRectGetWidth(baseView.frame), CGRectGetHeight(baseView.frame)))/2
            baseView.layer.masksToBounds = true
            createCircleLayers()
        }
        
        
        centerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(baseView.frame) * 0.6, CGRectGetHeight(baseView.frame)))
        centerView.center = CGPoint(x: CGRectGetWidth(baseView.frame) / 2, y: CGRectGetHeight(baseView.frame) / 2)
        baseView.addSubview(centerView)
    }
    
    private func createNumbersArray(){
        numbersArray = String(self.value!).characters.map{String($0)}
    }
    
    private func createAnimation(){
        let dur = self.duration! - (Double(numbersArray!.count) * self.durationOffset!)
        var offset = 0.4
        createCircleAnimation()
        for layer in layersArray!{
            let maxY = (layer.sublayers!.last)!.frame.origin.y
            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = dur + offset
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            if self.scrollDown! {
                animation.fromValue = Float(-maxY)
                animation.toValue = 0
            }else {
                animation.fromValue = 0
                animation.toValue = Float(-maxY)
            }
            
            layer.addAnimation(animation, forKey: "ATScrollingNumbers")
            offset += self.durationOffset!
        }
    }
    
    private func createScrollNumberLayers(){
        let itemCount = numbersArray!.count
        let width: CGFloat = CGRectGetWidth(self.centerView.frame) / CGFloat(itemCount)
        let height: CGFloat = CGRectGetHeight(self.centerView.frame)
        
        
        for i in 0..<itemCount {
            let layer = CAScrollLayer()
            layer.frame = CGRectMake(CGFloat(width) * CGFloat(i), 0, width, height)
            layersArray!.append(layer)
            self.centerView.layer.addSublayer(layer)
        }
        
        for i in 0..<itemCount{
            let layer = layersArray![i] as! CAScrollLayer
            let num = numbersArray![i]
            self.createLayerText(layer, numberString: num)
        }
    }
    
    private func createLayerText(scrollL: CAScrollLayer, numberString: String){
        let number = Int(numberString)!
        var textForScroll = [String]()
        
        for i in 0..<density! {
            textForScroll.append(String(format: "%d", (number + i)%10))
        }
        
        textForScroll.append(numberString)
        
        if !self.scrollDown!{
            textForScroll = textForScroll.reverse()
        }
        
        var height: CGFloat = 0
        for text in textForScroll {
            let label = labelForText(text)
            label.frame = CGRectMake(0, height, CGRectGetWidth(scrollL.frame), CGRectGetHeight(scrollL.frame))
            scrollL.addSublayer(label.layer)
            layerContentArray?.append(label)
            height = CGRectGetMaxY(label.frame)
        }
    }
    
    private func labelForText(text: String) -> UILabel{
        let lblView = UILabel()
        lblView.textColor = self.textColor
        lblView.font = self.font
        lblView.textAlignment = NSTextAlignment.Center
        lblView.text = text
        return lblView
    }
    
    private func prepareForAnimation(){
        for layer in layersArray!{
            layer.removeFromSuperlayer()
        }
        numbersArray?.removeAll()
        layersArray?.removeAll()
        layerContentArray?.removeAll()
        createNumbersArray()
        createScrollNumberLayers()
    }
    
    private func createCircleLayers(){
        let width = CGRectGetWidth(self.frame)
        let height = CGRectGetHeight(self.frame)
        for i in 0..<2 {
            let circleLayer = CAShapeLayer()
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: (width + CGFloat(CGFloat(i) * width * 0.1))/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
            circleLayer.path = circlePath.CGPath
            circleLayer.fillColor = UIColor.clearColor().CGColor
            circleLayer.strokeColor = UIColor.redColor().CGColor
            circleLayer.lineWidth = 1.0
            circleLayer.strokeEnd = 0.0
            circleLayerArray!.append(circleLayer)
        }
        
        for cLayer in circleLayerArray!{
            layer.addSublayer(cLayer)
        }
    }
    
    private func createCircleAnimation(){
        var offsetTime = 0.0
        var offsetDur = 1.0
        for cLayer in circleLayerArray! {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration!/offsetDur
            animation.beginTime = CACurrentMediaTime() + offsetTime
            animation.fillMode = kCAFillModeForwards
            animation.speed = 1
            animation.fromValue = 0
            animation.toValue = 1
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.removedOnCompletion = false
            cLayer.addAnimation(animation, forKey: "ATCircleAnimation")
            offsetDur += 1
            offsetTime += duration!/offsetDur
        }
    }
}














