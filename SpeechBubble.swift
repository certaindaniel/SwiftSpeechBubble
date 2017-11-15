//
//  SpeechBubble.swift
//  Bark
//
//  Created by Sebastian on 6/3/16.
//  Copyright © 2016 Bourbonshake. All rights reserved.
//

import UIKit

class SpeechBubble: UIView {
    let strokeColor: UIColor = UIColor.gray
    let fillColor: UIColor = UIColor.white
    var triangleHeight: CGFloat!
    var radius: CGFloat!
    var borderWidth: CGFloat!
    var edgeCurve: CGFloat!
    var peakSide: PeakSide!

    public enum PeakSide: Int {
        case top
        case left
        case right
        case bottom
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required convenience init(baseView: UIView, text: String, fontSize: CGFloat = 17, side: PeakSide = .bottom) {
        // Calculate relative sizes
        let padding = fontSize * 0.7
        let triangleHeight = fontSize * 0.5
        let radius = fontSize * 1.2
        let borderWidth = fontSize * 0.25
        let margin = fontSize * 0.14 // margin between the baseview and balloon
        let edgeCurve = fontSize * 0.14 // smaller the curvier

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.text = text
        label.numberOfLines = 0
        let labelSize = label.intrinsicContentSize

        let width = labelSize.width + triangleHeight * 2 + padding * 3 // 50% more padding on width
        let height = labelSize.height + triangleHeight * 2 + padding * 3
        let bubbleRect = CGRect(x: baseView.center.x - width / 2,
                                y: baseView.center.y - (baseView.bounds.height / 2) - (height + margin),
                                width: width,
                                height: height)

        self.init(frame: bubbleRect)

        self.triangleHeight = triangleHeight
        self.radius = radius
        self.borderWidth = borderWidth
        self.edgeCurve = edgeCurve
        self.peakSide = side

        label.frame = CGRect(x: padding + triangleHeight,
                             y: padding * 1.5 + triangleHeight ,
                             width: labelSize.width + padding,
                             height: labelSize.height)
        label.textAlignment = .center
        label.textColor = strokeColor
        self.addSubview(label)
    }

    override func draw(_ rect: CGRect) {
        let bubble = CGRect(x: 0,
                            y: 0,
                            width: rect.width - radius * 2 - triangleHeight * 2,
                            height: rect.height - radius * 2 - triangleHeight * 2 ).offsetBy(dx: radius + triangleHeight , dy: radius + triangleHeight)
        let path = UIBezierPath()
        let radius2 = radius - borderWidth // Radius adjasted for the border width

        //                      P3
        //                    /    \
        //      P1 -------- P2     P4 -------- P5
        //      |                               |
        //      |                               |
        //      P16                            P6
        //     /                                 \
        //  P15                                   P7
        //     \                                 /
        //      P14                            P8
        //      |                               |
        //      |                               |
        //      P13 ------ P12    P10 -------- P9
        //                    \   /
        //                     P11

        // P5 Arc
        path.addArc(withCenter: CGPoint(x: bubble.maxX, y: bubble.minY),
                    radius: radius2,
                    startAngle: CGFloat(-1 * Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)

        if self.peakSide == .right {
            // P5 - P6 Line
            path.addLine(to: CGPoint(x: bubble.maxX + radius2,
                                     y: bubble.minY + bubble.height / 2 - triangleHeight * 1.2))

            // The speech bubble edge - P6 P7 P8 >
            path.addQuadCurve(to: CGPoint(x: bubble.maxX + radius2 + triangleHeight,
                                          y: bubble.minY + bubble.height / 2),
                              controlPoint: CGPoint(x: bubble.maxX + radius2 + edgeCurve,
                                                    y: bubble.minY + bubble.height / 2 - edgeCurve))

            path.addQuadCurve(to: CGPoint(x: bubble.maxX + radius2,
                                          y: bubble.minY + bubble.height / 2 + triangleHeight * 1.2),
                              controlPoint: CGPoint(x: bubble.maxX + radius2 + edgeCurve,
                                                    y: bubble.minY + bubble.height / 2 + edgeCurve))
        }

        // P9 Arc
        path.addArc(withCenter: CGPoint(x: bubble.maxX, y: bubble.maxY),
                    radius: radius2,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)

        if self.peakSide == .bottom {
            // P9 - P10 Line
            path.addLine(to: CGPoint(x: bubble.minX + bubble.width / 2 + triangleHeight * 1.2,
                                     y: bubble.maxY + radius2))

            // The speech bubble edge - P10 P11 P12 V
            path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2,
                                          y: bubble.maxY + radius2 + triangleHeight),
                              controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 + edgeCurve,
                                                    y: bubble.maxY + radius2 + edgeCurve))
            path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2 - triangleHeight * 1.2,
                                          y: bubble.maxY + radius2),
                              controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 - edgeCurve,
                                                    y: bubble.maxY + radius2 + edgeCurve))
        }

        // P13 Arc
        path.addArc(withCenter: CGPoint(x: bubble.minX, y: bubble.maxY),
                    radius: radius2,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)

        if self.peakSide == .left {
            // P3 - P14 Line
            path.addLine(to: CGPoint(x: bubble.minX - radius2,
                                     y: bubble.maxY - bubble.height / 2 + triangleHeight * 1.2))

            // The speech bubble edge - P14 P15 P16 <
            path.addQuadCurve(to: CGPoint(x: bubble.minX - radius2 - triangleHeight,
                                          y: bubble.maxY - bubble.height / 2),
                              controlPoint: CGPoint(x: bubble.minX - radius2 - edgeCurve,
                                                    y: bubble.maxY - bubble.height / 2 + edgeCurve))

            path.addQuadCurve(to: CGPoint(x: bubble.minX - radius2,
                                          y: bubble.maxY - bubble.height / 2 - triangleHeight * 1.2),
                              controlPoint: CGPoint(x: bubble.minX - radius2 - edgeCurve,
                                                    y: bubble.maxY - bubble.height / 2 - edgeCurve))
        }

        // P1 Arc
        path.addArc(withCenter: CGPoint(x: bubble.minX, y: bubble.minY),
                    radius: radius2,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(-1 * Double.pi / 2),
                    clockwise: true)

        if self.peakSide == .top {
            // P1 - P2
            path.addLine(to: CGPoint(x: bubble.minX + bubble.width / 2 - triangleHeight * 1.2,
                                     y: bubble.minY - radius2))

            // P2 P3 P4
            path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2 ,
                                          y: bubble.minY - radius2 - triangleHeight),
                              controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 - edgeCurve,
                                                    y: bubble.minY - radius2 - edgeCurve))

            path.addQuadCurve(to: CGPoint(x: bubble.minX + bubble.width / 2 + triangleHeight * 1.2,
                                          y: bubble.minY - radius2),
                              controlPoint: CGPoint(x: bubble.minX + bubble.width / 2 + edgeCurve,
                                                    y:  bubble.minY - radius2 - edgeCurve))
        }

        path.close()

        fillColor.setFill()
        strokeColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
        path.fill()
    }
}
