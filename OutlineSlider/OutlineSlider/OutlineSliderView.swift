import UIKit

private class KnobView: UIView {

    var color: UIColor = .white

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func draw(_: CGRect) {

        let w = self.frame.size.width
        let margin: CGFloat = 1

        let knob = UIBezierPath(ovalIn: CGRect(x: margin, y: margin, width: w - 2 * margin, height: w - 2 * margin))
        color.setStroke()
        knob.lineWidth = 2
        knob.stroke()

    }

}

@IBDesignable
public class OutlineSliderView: UIView {

    private let knobView = KnobView()
    private let parameterNameLabel = UILabel(frame: .zero)
    private let parameterValueLabel = UILabel(frame: .zero)

    @IBInspectable
    public var name: String = "Parameter" {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable
    public var minValue: CGFloat = -100 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    public var maxValue: CGFloat = 100 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }

    @IBInspectable
    public var value: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
            self.setNeedsDisplay()
            if self.value < self.minValue {
                self.value = self.minValue
            }
            if self.value > self.maxValue {
                self.value = self.maxValue
            }
        }
    }

    @IBInspectable public var sliderColor: UIColor? = UIColor(white: 0.4, alpha: 1.000) {
        didSet {
            self.setNeedsDisplay()
        }
    }

    @IBInspectable public var textColor: UIColor? = UIColor(white: 0.65, alpha: 1.000) {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable public var highlightColor: UIColor? = UIColor.white {
        didSet {
            self.knobView.color = self.highlightColor ?? UIColor.white
            self.setNeedsDisplay()
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 250, height: 100)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.parameterNameLabel.text = self.name
        self.parameterValueLabel.text = String(Int(self.value))

        self.parameterNameLabel.sizeToFit()
        self.parameterValueLabel.sizeToFit()

        self.parameterNameLabel.frame.origin.x = 0
        self.parameterNameLabel.frame.origin.y = 0

        self.parameterValueLabel.frame.origin.x = self.frame.size.width - self.parameterValueLabel.frame.size.width
        self.parameterValueLabel.frame.origin.y = 0

        self.parameterNameLabel.textColor = textColor
        self.parameterValueLabel.textColor = textColor

        self.knobView.frame = CGRect(x: self.knobCenterX - self.knobSize / 2.0, y: self.sliderY - self.knobSize / 2 + self.sliderHeight / 2, width: self.knobSize, height: self.knobSize)

    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        self.contentMode = .redraw

        self.addSubview(self.parameterNameLabel)
        self.addSubview(self.parameterValueLabel)
        self.addSubview(self.knobView)

        self.knobView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:))))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    private let knobSize: CGFloat = 16
    private let sliderY: CGFloat = 35
    private let sliderHeight: CGFloat = 2

    private var knobCenterX: CGFloat {
        return CGFloat(self.value - self.minValue) / self.valuePt
    }

    private var valuePt: CGFloat {
        return CGFloat(abs(self.minValue) + abs(self.maxValue)) / self.width
    }

    private var width: CGFloat {
        return self.frame.size.width
    }

    public override func draw(_: CGRect) {

        let ctx = UIGraphicsGetCurrentContext()!

        ctx.clear(.infinite)

        // Cutout mask
        let cutoutRadius = knobSize * 0.8
        let cutoutRect = CGRect(x: knobCenterX - cutoutRadius, y: sliderY, width: cutoutRadius * 2, height: 10)
        let cutout = UIBezierPath(rect: .infinite)
        cutout.append(UIBezierPath(rect: cutoutRect))
        cutout.usesEvenOddFillRule = true

        ctx.saveGState()
        cutout.addClip()

        // Slider Bar
        let sliderBar = UIBezierPath(roundedRect: CGRect(x: 0, y: sliderY, width: width, height: sliderHeight), cornerRadius: 1)

        (sliderColor ?? UIColor.lightGray).setFill()
        sliderBar.fill()

        // Highlight Bar
        let highlightBar = UIBezierPath(rect: CGRect(x: knobCenterX, y: sliderY, width: width / 2.0 - knobCenterX, height: sliderHeight))
        (highlightColor ?? UIColor.white).setFill()
        highlightBar.fill()

        ctx.restoreGState()

    }

    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        self.value += gestureRecognizer.translation(in: self.knobView).x * valuePt
        gestureRecognizer.setTranslation(.zero, in: self.knobView)
    }

    @objc func handleTap(_: UITapGestureRecognizer) {
        self.value = 0
    }

}
