//
//  CABasicAnimation+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/3/29.
//  Copyright © 2019 BN. All rights reserved.
//

import QuartzCore


@objc public extension CABasicAnimation{

    /// [源]CABasicAnimation
    static func animKeyPath(_ keyPath: String,
                                  duration: CFTimeInterval,
                                  autoreverses: Bool = false,
                                  repeatCount: Float,
                                  fillMode: CAMediaTimingFillMode = .forwards,
                                  removedOnCompletion: Bool = false,
                                  functionName: CAMediaTimingFunctionName = .linear) -> CABasicAnimation {
        
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.duration = duration;
        anim.repeatCount = repeatCount;
        anim.fillMode = fillMode;
        anim.isRemovedOnCompletion = removedOnCompletion;
        
        let name = kFunctionNames.contains(functionName) ? functionName : kFunctionNames.first;
        anim.timingFunction = CAMediaTimingFunction(name: name!);
        anim.isCumulative = keyPath == CAAnimation.kTransformRotationZ;
        return anim;
    }
    
    /// [便捷]CABasicAnimation
    static func animKeyPath(_ keyPath: String,
                                  duration: CFTimeInterval,
                                  autoreverses: Bool = false,
                                  repeatCount: Float,
                                  fromValue: Any,
                                  toValue: Any) -> CABasicAnimation {
        let anim = animKeyPath(keyPath, duration: duration, repeatCount: repeatCount, functionName: kFunctionNames.first!);
        anim.fromValue = fromValue;
        anim.toValue = toValue;
        return anim;
    }
    
}
