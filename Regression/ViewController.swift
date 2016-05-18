//
//  ViewController.swift
//  Regression
//
//  Created by Dominik Felber on 18.05.16.
//  Copyright © 2016 Dominik Felber. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
	@IBOutlet var regressionViewOrder1: RegressionView!
	@IBOutlet var regressionViewOrder2: RegressionView!
	@IBOutlet var regressionViewOrder3: RegressionView!
	@IBOutlet var regressionViewOrder4: RegressionView!
	@IBOutlet var regressionViewOrder5: RegressionView!
	@IBOutlet var regressionViewOrder6: RegressionView!
	
	
	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if motion == .MotionShake {
			regressionViewOrder1.clear()
			regressionViewOrder2.clear()
			regressionViewOrder3.clear()
			regressionViewOrder4.clear()
			regressionViewOrder5.clear()
			regressionViewOrder6.clear()
		}
	}
}
