import UIKit

private class KnobView : UIView {

    var color : UIColor = .white

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func draw(_ rect: CGRect) {

        let w = self.frame.size.width
        let margin : CGFloat = 1

        let knob = UIBezierPath(ovalIn: CGRect(x: margin, y: margin, width: w - 2*margin, height: w-2*margin))
        color.setStroke()
        knob.lineWidth = 2
        knob.stroke()

    }

}

@IBDesignable
class OutlineSliderView: UIView {

    private let knobView = KnobView()
    private let parameterNameLabel = UILabel(frame: .zero)
    private let parameterValueLabel = UILabel(frame: .zero)

    @IBInspectable
    var name : String = "Parameter" {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable
    var minValue : CGFloat = -100 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var maxValue : CGFloat = 100 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var value : CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
            if value < minValue {
                self.value = minValue
            }
            if value > maxValue {
                self.value = maxValue
            }
        }
    }

    @IBInspectable var sliderColor : UIColor? = UIColor(white: 0.4, alpha: 1.000) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var textColor : UIColor? = UIColor(white: 0.65, alpha: 1.000) {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var highlightColor : UIColor? = UIColor.white {
        didSet {
            knobView.color = self.highlightColor ?? UIColor.white
            self.setNeedsDisplay()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        parameterNameLabel.text = self.name
        parameterValueLabel.text = String(Int(self.value))

        parameterNameLabel.sizeToFit()
        parameterValueLabel.sizeToFit()

        parameterNameLabel.frame.origin.x = 0
        parameterNameLabel.frame.origin.y = 0

        parameterValueLabel.frame.origin.x = self.frame.size.width - parameterValueLabel.frame.size.width
        parameterValueLabel.frame.origin.y = 0

        parameterNameLabel.textColor = textColor
        parameterValueLabel.textColor = textColor

        knobView.frame = CGRect(x: knobCenterX - knobSize / 2.0, y: sliderY - knobSize/2 + sliderHeight / 2, width: knobSize, height: knobSize)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        self.addSubview(parameterNameLabel)
        self.addSubview(parameterValueLabel)
        self.addSubview(knobView)

        knobView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    private let knobSize : CGFloat = 16
    private let sliderY : CGFloat = 35
    private let sliderHeight : CGFloat = 2

    private var knobCenterX : CGFloat {
        return CGFloat(self.value - self.minValue) / valuePt
    }

    private var valuePt : CGFloat {
        return CGFloat(abs(minValue) + abs(maxValue)) / width
    }

    private var width : CGFloat {
        return self.frame.size.width
    }

    override func draw(_ rect: CGRect) {

        // Cutout mask
        let cutoutRadius = knobSize * 0.8
        let cutout = UIBezierPath(rect: .infinite)
        cutout.append(UIBezierPath(rect: CGRect(x: knobCenterX - cutoutRadius, y: sliderY, width: cutoutRadius * 2, height: 10)))
        cutout.usesEvenOddFillRule = true

        UIGraphicsGetCurrentContext()!.saveGState()
        cutout.addClip()

        // Slider Bar
        let sliderBar = UIBezierPath(roundedRect: CGRect(x: 0, y: sliderY, width: width, height: sliderHeight), cornerRadius: 1)

        (sliderColor ?? UIColor.lightGray).setFill()
        sliderBar.fill()

        // Highlight Bar
        let highlightBar = UIBezierPath(rect: CGRect(x: knobCenterX, y: sliderY, width: width / 2.0 - knobCenterX, height: sliderHeight))
        (highlightColor ?? UIColor.white).setFill()
        highlightBar.fill()

        UIGraphicsGetCurrentContext()!.restoreGState()

    }

    @objc func handlePan(_ gestureRecognizer : UIPanGestureRecognizer) {
        self.value += gestureRecognizer.translation(in: knobView).x * valuePt
        gestureRecognizer.setTranslation(.zero, in: knobView)
    }

    @objc func handleTap(_ gestureRecognizer : UITapGestureRecognizer) {
        self.value = 0
    }

}
