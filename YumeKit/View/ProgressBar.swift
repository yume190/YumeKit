//
//  ProgressBarView.swift
//  MaxwinBus
//
//  Created by Yume on 2019/5/15.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

public final class ProgressBar: UIView {
    override public class final var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    private final var shape: CAShapeLayer? {
        return self.layer as? CAShapeLayer
    }
    
    public final var stroke: UIColor = .red {
        didSet {
            self.shape?.strokeColor = self.stroke.cgColor
        }
    }
    public final var lineWidth: CGFloat = 0 {
        didSet {
            self.shape?.lineWidth = self.lineWidth
        }
    }
    
    public final var lineCap: CAShapeLayerLineCap = .round {
        didSet {
            self.shape?.lineCap = .round
        }
    }
    
    private final var path: UIBezierPath {
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        return path
    }
    
    public final func animation(duration: CFTimeInterval) {
        self.shape?.path = self.path.cgPath
        self.shape?.strokeEnd = 0
        
        //        self.shape?.removeAllAnimations()
        self.shape?.removeAnimation(forKey: "yume")
        CATransaction.begin()
        // 這時會同時執行顯式動畫以及隱式動畫，所以先將隱式動畫關閉
        CATransaction.setDisableActions(true)
        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = "strokeEnd"
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.isRemovedOnCompletion = false
        self.shape?.add(animation, forKey: "yume")
        CATransaction.commit()
    }
    
}
