//
//  AnalogStick.swift
//  Joystick
//
//  Created by Dmitriy Mitrophanskiy on 28.09.14.
//
//
/*
 AnalogJoystick.swift
 
 ### Preview
 ![Analog joustick](https://github.com/MitrophD/Swift-SpriteKit-Analog-Stick/blob/master/preview.gif?raw=true)
 
 ### Features
 - Begin handler
 - Tracking handler
 - Stop handler
 - Set/change joystick diameter
 - Set/change stick && substrate colors
 - Set/change stick && substrate images
 
 ### Manual
 1. Just drop the **AnalogJoystick.swift** file into your project.
 2. That's it!
 
 ### Init examples:
 ***init with 100px diameter.Colors & images you can change later***
 ``` swift
 let joystick = AnalogJoystick(diameter: 100)
 // or
 let joystick = 🕹(diameter: 100)
 ```
 ***Substrate has 100px diameter, stick has 50px diameter***
 ``` swift
 let joystick = AnalogJoystick(diameters: (100, 50))
 ```
 ***init with 100px diameter.Substrate has blue color, stick has yellow color***
 ``` swift
 let joystick = AnalogJoystick(diameter: 100, colors: (UIColor.blue(), UIColor.yellow()))
 ```
 ***init with 100px diameter.Substrate has "substrate" image, stick has "stick" image***
 ``` swift
 let joystick = AnalogJoystick(diameter: 100, images: (UIImage(named: "substrate"), UIImage(named: "stick")))
 ```
 ***init with 100px diameter.Substrate has blue color && "substrate" image, stick has yellow color && "stick" image***
 ``` swift
 let joystick = AnalogJoystick(diameter: 100, colors: (UIColor.blue(), UIColor.yellow()), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
 ```
 ***init with substrate && stick diameters.Substrate has blue color && "substrate" image, stick has yellow color && "stick" image***
 ``` swift
 let joystick = AnalogJoystick(diameters: (100, 50), colors: (UIColor.blue(), UIColor.yellow()), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
 ```
 ***init with substrate && stick diameters.Substrate has blue color, stick has yellow color***
 ``` swift
 let joystick = AnalogJoystick(diameters: (100, 50), colors: (UIColor.blue(), UIColor.yellow()))
 ```
 ***init with substrate && stick diameters.Substrate has "substrate" image, stick has "stick" image***
 ``` swift
 let joystick = AnalogJoystick(diameters: (100, 50), images: (UIImage(named: "substrate"), UIImage(named: "stick")))
 ```
 
 ### Designated initializator
 ``` swift
 init(substrate: AnalogJoystickSubstrate, stick: AnalogJoystickStick)
 ```
 **WHERE:**
 - **substrate** - substrate of joystick (AnalogJoystickSubstrate:AnalogJoystickComponent)
 - **stick** - stick of joystick (AnalogJoystickStick:AnalogJoystickComponent)
 
 ### Convenience initializators:
 ``` swift
 convenience init(diameters: (substrate: CGFloat, stick: CGFloat?), colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil)
 convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil)
 ```
 
 ### Typealias
 ``` swift
 typealias AnalogJoystick = 🕹
 ```
 ## Example
 ``` swift
 let joystick = 🕹(diameter: 110) // it's equal let joystick = AnalogJoystick(diameter: 110)
 ```
 
 ### Handlers
 - var beginHandler: (() -> Void)? // before move
 - var trackingHandler: ((AnalogJoystickData) -> ())? // when move
 - var stopHandler: (() -> Void)? // after move
 
 ### Computed Properties
 - var stickColor: UIColor (get/set)
 - var substrateColor: UIColor (get/set)
 - var stickImage: UIImage? (get/set)
 - var substrateImage: UIImage? (get/set)
 - var diameter: CGFloat (get/set)
 
 ## Examples
 ### Create joystick
 ``` swift
 let joystick = AnalogJoystick(diameter: 100) // you can set images/color later
 ```
 **or with images**
 ``` swift
 let joystick = AnalogJoystick(diameter: 100, images: (UIImage(named: "substrate"), UIImage(named: "stick")))
 ```
 ### Tracking With Closure
 ``` swift
 joystick.beginHandler = { [unowned self] in
 // Something...
 }
 
 joystick.trackingHandler = { [unowned self] data in
 // Something...
 // data contains angular && velocity (data.angular, data.velocity)
 }
 
 joystick.stopHandler = { [unowned self] in
 // Something...
 }
 ```
 ### Change diameter
 ``` swift
 joystick.diameter = 100 // set new diameter
 ```
 ### Change colors
 ``` swift
 joystick.stick.color = UIColor.yellow() // set yellow color to stick node
 joystick.substrate.color = UIColor.red() // set red color to substrate node
 ```
 ### Change images
 ``` swift
 joystick.stick.image = UIImage(imageNamed: "yourStickImage") // set image to stick node
 joystick.substrate.image = UIImage(imageNamed: "yourSubstrateImage") // set image to substrate node
 ```
 ## License
 
 The MIT License (MIT)
 
 Copyright (c) 2015...2017 Dmitriy Mitrophanskiy
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import SpriteKit

//MARK: AnalogJoystickData
public struct AnalogJoystickData: CustomStringConvertible {
    var velocity = CGPoint.zero,
    angular = CGFloat(0)
    
    mutating func reset() {
        velocity = CGPoint.zero
        angular = 0
    }
    
    public var description: String {
        return "AnalogStickData(velocity: \(velocity), angular: \(angular))"
    }
}

//MARK: - AnalogJoystickComponent
open class AnalogJoystickComponent: SKSpriteNode {
    private var kvoContext = UInt8(1)
    
    
    
    var borderWidth = CGFloat(0) {
        didSet {
            redrawTexture()
        }
    }
    
    var borderColor = UIColor.black {
        didSet {
            redrawTexture()
        }
    }
    
    var image: UIImage? {
        didSet {
            redrawTexture()
        }
    }
    
    var diameter: CGFloat {
        get {
            return max(size.width, size.height)
        }
        
        set(newSize) {
            size = CGSize(width: newSize, height: newSize)
        }
    }
    
    var radius: CGFloat {
        get {
            return diameter * 0.5
        }
        
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    //MARK: - DESIGNATED
    init(diameter: CGFloat, color: UIColor? = nil, image: UIImage? = nil) {
        super.init(texture: nil, color: color ?? UIColor.black, size: CGSize(width: diameter, height: diameter))
        addObserver(self, forKeyPath: "color", options: NSKeyValueObservingOptions.old, context: &kvoContext)
        self.diameter = diameter
        self.image = image
        redrawTexture()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "color")
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        redrawTexture()
    }
    
    private func redrawTexture() {
        
        guard diameter > 0 else {
           // print("Diameter should be more than zero")
            texture = nil
            return
        }
        
        let scale = UIScreen.main.scale
        let needSize = CGSize(width: self.diameter, height: self.diameter)
        UIGraphicsBeginImageContextWithOptions(needSize, false, scale)
        let rectPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: needSize))
        rectPath.addClip()
        
        if let img = image {
            img.draw(in: CGRect(origin: CGPoint.zero, size: needSize), blendMode: .normal, alpha: 1)
        } else {
            color.set()
            rectPath.fill()
        }
        
        let needImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        texture = SKTexture(image: needImage)
    }
}

//MARK: - AnalogJoystickSubstrate
open class AnalogJoystickSubstrate: AnalogJoystickComponent {
    // coming soon...
}

//MARK: - AnalogJoystickStick
open class AnalogJoystickStick: AnalogJoystickComponent {
    // coming soon...
}

//MARK: - AnalogJoystick
open class AnalogJoystick: SKNode {
    
    var buttonReference : JKButtonNode? = nil

    var trackingHandler: ((AnalogJoystickData) -> ())?
    var beginHandler: (() -> Void)?
    var stopHandler: (() -> Void)?
    var substrate: AnalogJoystickSubstrate!
    var stick: AnalogJoystickStick!
    private var tracking = false
    private(set) var data = AnalogJoystickData()
    
    var disabled: Bool {
        get {
            return !isUserInteractionEnabled
        }
        
        set(isDisabled) {
            isUserInteractionEnabled = !isDisabled
            
            if isDisabled {
                resetStick()
            }
        }
    }
    
    var diameter: CGFloat {
        get {
            return substrate.diameter
        }
        
        set(newDiameter) {
            stick.diameter += newDiameter - diameter
            substrate.diameter = newDiameter
        }
    }
    
    var radius: CGFloat {
        get {
            return diameter * 0.5
        }
        
        set(newRadius) {
            diameter = newRadius * 2
        }
    }
    
    init(substrate: AnalogJoystickSubstrate, stick: AnalogJoystickStick) {
        super.init()
        self.substrate = substrate
        substrate.zPosition = 0
        addChild(substrate)
        self.stick = stick
        stick.zPosition = substrate.zPosition + 1
        addChild(stick)
        disabled = false
        let velocityLoop = CADisplayLink(target: self, selector: #selector(listen))
        velocityLoop.add(to: RunLoop.current, forMode: RunLoop.Mode(rawValue: RunLoop.Mode.common.rawValue))
    }
    
    convenience init(diameters: (substrate: CGFloat, stick: CGFloat?), colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        let stickDiameter = diameters.stick ?? diameters.substrate * 0.6,
        jColors = colors ?? (substrate: nil, stick: nil),
        jImages = images ?? (substrate: nil, stick: nil),
        substrate = AnalogJoystickSubstrate(diameter: diameters.substrate, color: jColors.substrate, image: jImages.substrate),
        stick = AnalogJoystickStick(diameter: stickDiameter, color: jColors.stick, image: jImages.stick)
        self.init(substrate: substrate, stick: stick)
    }
    
    convenience init(diameter: CGFloat, colors: (substrate: UIColor?, stick: UIColor?)? = nil, images: (substrate: UIImage?, stick: UIImage?)? = nil) {
        self.init(diameters: (substrate: diameter, stick: nil), colors: colors, images: images)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func listen() {
        
        if tracking {
            trackingHandler?(data)
        }
    }
    
    var trackingTouch = UITouch()
    //MARK: - Overrides
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Joystick receief touches ")
        guard let touch = touches.first else { return }
          let location = touch.location(in: self)
        print(location)
        let distance = sqrt(pow(location.x, 2) + pow(location.y, 2))
            if distance <= substrate.radius {
                if !tracking, stick.contains(location) {
                    tracking = true
                    trackingTouch = touch
                    beginHandler?()
                }
            } else {
                // Let other nodes handle the touch
                if let button = buttonReference {
                    print("wasnt in self, passing to button")
                    button.touchesBegan(touches, with: event)
                }
            }
        
     
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch: UITouch in touches {
            if(touch == trackingTouch){
            let location = touch.location(in: self)
            
            guard tracking else {
                return
            }
            
            let maxDistantion = substrate.radius,
            realDistantion = sqrt(pow(location.x, 2) + pow(location.y, 2)),
            needPosition = realDistantion <= maxDistantion ? CGPoint(x: location.x, y: location.y) : CGPoint(x: location.x / realDistantion * maxDistantion, y: location.y / realDistantion * maxDistantion)
            stick.position = needPosition
            data = AnalogJoystickData(velocity: needPosition, angular: -atan2(needPosition.x, needPosition.y))
            } else {
                buttonReference?.touchesMoved(touches, with: event)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch: UITouch in touches {
        if(touch == trackingTouch){
            resetStick()
            
        } else {
            buttonReference?.touchesEnded(touches, with: event)
        }
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            if(touch == trackingTouch){
                resetStick()
                
            } else {
                buttonReference?.touchesCancelled(touches, with: event)
            }
        }
    }
    
    // CustomStringConvertible protocol
    open override var description: String {
        return "AnalogJoystick(data: \(data), position: \(position))"
    }
    
    // private methods
    private func resetStick() {
        tracking = false
        let moveToBack = SKAction.move(to: CGPoint.zero, duration: TimeInterval(0.1))
        moveToBack.timingMode = .easeOut
        stick.run(moveToBack)
        data.reset()
        stopHandler?();
    }
}

typealias 🕹 = AnalogJoystick
