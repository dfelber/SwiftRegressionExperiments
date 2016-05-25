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
    
    var regressionViews: [RegressionView]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views = self.view.subviews.filter({ $0 is RegressionView })
        regressionViews = views as? [RegressionView]
        
        guard let regressionViews = regressionViews else {
            return
        }
        
        for view in regressionViews {
            view.pointWasAddedCallback = { (newPoint, sender) in
                for otherView in regressionViews {
                    guard otherView != view else {
                        continue
                    }
                    
                    otherView.addPoint(newPoint)
                }
            }
        }
    }
    
    
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
