import SpriteKit

class SKSlider: SKNode {

    private var currentTarget: AnyObject?
    private var currentAction: Selector?
    private var touchInProgress = false
    private var touchRectangle: CGRect = .zero
    private var touchLocation: CGPoint = .zero

    var sliderBackground: SKSpriteNode!
    var sliderIcon: SKSpriteNode!
    var sliderValue: CGFloat = 0.0 {
        didSet {
            // Update slider icon position based on slider value
            updateSliderIconPosition()
        }
    }

    // Convenience initializer
    class func sliderWithBackgroundImage(_ backgroundImage: String, iconImage: String, target: AnyObject, action: Selector) -> SKSlider {
        return SKSlider(backgroundImage: backgroundImage, iconImage: iconImage, target: target, action: action)
    }

    // Designated initializer
    init(backgroundImage: String, iconImage: String, target: AnyObject, action: Selector) {
        super.init()

        self.isUserInteractionEnabled = true

        // Create the background sprite
        self.sliderBackground = SKSpriteNode(imageNamed: backgroundImage)
        self.addChild(sliderBackground)

        // Create the slider icon sprite
        self.sliderIcon = SKSpriteNode(imageNamed: iconImage)
        self.addChild(sliderIcon)

        // Set initial position of the slider icon
        self.sliderIcon.position = CGPoint(x: -sliderBackground.size.width / 2, y: 0)
        
        self.sliderIcon.zPosition = 1  

        // Initialize touch rectangle
        self.touchRectangle = CGRect(
            x: -sliderBackground.size.width / 2,
            y: -sliderBackground.size.height / 2,
            width: sliderBackground.size.width,
            height: sliderBackground.size.height
        )

        self.currentAction = action
        self.currentTarget = target
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = true

        if let action = currentAction {
            currentTarget?.perform(action, with: nil)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchInProgress else { return }

        for touch in touches {
            let location = touch.location(in: self)
            if touchRectangle.contains(location) {
                touchLocation = location
            }
        }

        // Calculate slider value based on touch location
        let sliderWidth = sliderBackground.size.width
        sliderValue = (touchLocation.x + sliderWidth / 2) / sliderWidth * 200 - 100

        // Clamp slider value to the range -100 to 100
        sliderValue = min(max(sliderValue, -100), 100)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchInProgress = false
    }

    private func updateSliderIconPosition() {
        // Map slider value (-100 to 100) to slider background width
        let sliderWidth = sliderBackground.size.width
        let positionX = (sliderValue + 100) / 200 * sliderWidth - sliderWidth / 2

        // Update slider icon position
        sliderIcon.position = CGPoint(x: positionX, y: 0)
    }
}
