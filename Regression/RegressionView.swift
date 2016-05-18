//
//  RegressionView.swift
//  Regression
//
//  Created by Dominik Felber on 15.05.16.
//  Copyright © 2016 Dominik Felber. All rights reserved.
//

import UIKit


@IBDesignable
class RegressionView: UIView
{
	@IBInspectable var regressionDegree: Int = 2 {
		didSet {
			redraw()
		}
	}
	
	@IBInspectable var lineWidth: CGFloat = 2 {
		didSet {
			redraw()
		}
	}
	
	@IBInspectable var lineColor: UIColor = .redColor() {
		didSet {
			redraw()
		}
	}
	
	@IBInspectable var pointColor: UIColor = .blackColor() {
		didSet {
			redraw()
		}
	}

	private var points: [CGPoint] = []
	private var reg: Regression?
	private var modelLine: CAShapeLayer?
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		redraw()
	}
	
	
	func addPoint(point: CGPoint) {
		points.append(point)
		self.layer.addSublayer(buildPoint(point))
		
		redraw()
	}
	
	
	func clear() {
		modelLine?.removeFromSuperlayer()
		
		for layer in self.layer.sublayers ?? [] {
			layer.removeFromSuperlayer()
		}
		
		points.removeAll()
	}
	
	
	private func setup() {
		self.clipsToBounds = true
		self.backgroundColor = .whiteColor()
		self.layer.cornerRadius = 4.0
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(RegressionView.tapped(_:)))
		self.addGestureRecognizer(tap)
	}
	
	
	private func redraw() {
		guard points.count > 0 else {
			return
		}
		
		if points.count < regressionDegree {
			self.reg = self.regressionForValues(min(points.count - 1, regressionDegree))
		} else {
			self.reg = self.regressionForValues(regressionDegree)
		}
		
		self.drawModelWithRegression(self.reg)
	}
	
	
	func tapped(sender: UIGestureRecognizer) {
		switch sender.state
		{
			case .Ended, .Changed:
				let tapPositionOneFingerTap = sender.locationInView(self)
				addPoint(tapPositionOneFingerTap)
			
			default: break
		}
	}
	
	
	private func regressionForValues(degree: Int) -> Regression {
		let xValues = points.map({ Double(round($0.x)) })
		let yValues = points.map({ Double(round($0.y)) })
		
		let x = Matrix(columns: 1, rows: UInt(points.count), values: xValues)
		let y = Matrix(columns: 1, rows: UInt(points.count), values: yValues)
		
		return Regression(x: x, y: y, degree: degree)
		
	}
	
	
	private func drawModelWithRegression(reg: Regression?) {
		guard let reg = reg else {
			return
		}
		
		modelLine?.removeFromSuperlayer()
		
		if reg.degree == 1 {
			modelLine = buildLinearModel(reg)
		} else {
			modelLine = buildQuadraticModel(reg)
		}
		
		if modelLine != nil {
			self.layer.addSublayer(modelLine!)
		}
	}
	
	
	private func buildLineLayer(points: [CGPoint]) -> CAShapeLayer {
		let path = UIBezierPath()
		let layer = CAShapeLayer()
		
		layer.lineWidth = lineWidth
		layer.fillColor = UIColor.clearColor().CGColor
		layer.strokeColor = lineColor.CGColor
		
		for (index, point) in points.enumerate() {
			if index == 0 {
				path.moveToPoint(point)
			} else {
				path.addLineToPoint(point)
			}
		}
		
		layer.path = path.CGPath
		
		return layer
	}
	
	
	private func buildQuadraticModel(regression: Regression) -> CAShapeLayer {
		var points: [CGPoint] = []
		let width = Int(frame.width)
		
		for i in 0..<width {
			let x = Matrix(columns: 1, rows: 1, values: [Double(i)])
			
			guard let predictedValue = regression.predict(x).values.first else {
				continue
			}
			
			guard predictedValue.isNaN == false else {
				continue
			}
			
			let point = CGPointMake(CGFloat(i), CGFloat(predictedValue))
			points.append(point)
		}
		
		return buildLineLayer(points)
	}
	
	
	private func buildLinearModel(regression: Regression) -> CAShapeLayer? {
		let width = Double(frame.width)
		let axeStartX = Matrix(columns: 1, rows: 1, values: [0])
		let axeEndX = Matrix(columns: 1, rows: 1, values: [width])
		
		guard let axeStartY = regression.predict(axeStartX).values.first else {
			return nil
		}
		
		guard axeStartY.isNaN == false else {
			return nil
		}
		
		guard let axeEndY = regression.predict(axeEndX).values.first else {
			return nil
		}
		
		guard axeEndY.isNaN == false else {
			return nil
		}
		
		return buildLineLayer([CGPointMake(0, CGFloat(axeStartY)), CGPointMake(CGFloat(width), CGFloat(axeEndY))])
	}

	
	private func buildPoint(point: CGPoint, size: CGFloat = 10) -> CAShapeLayer {
		let layer = CAShapeLayer()
		let rect = CGRect(x: point.x - size / 2, y: point.y - size / 2, width: size, height: size)
		
		layer.path = UIBezierPath(ovalInRect: rect).CGPath
		layer.fillColor = pointColor.CGColor
		
		return layer
		
	}
}
