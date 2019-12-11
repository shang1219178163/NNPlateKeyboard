
//
//  UIColor+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/24.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UIColor{
    
    //MARK: - -属性
    static var random: UIColor {
        return UIColor.randomColor();
    }
    
    static var theme: UIColor {
        get{
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UIColor;
            obj = obj ?? UIColor.hexValue(0x0082e0)
            return obj!;
        }
        set{
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    /// 通用背景色
    static var background: UIColor {
        return UIColor.hexValue(0xe9e9e9);
    }
    /// 线条默认颜色(同cell分割线颜色)
    static var line: UIColor {
//        return UIColor.hexValue(0xe0e0e0);
        return UIColor.hexValue(0xe4e4e4);
    }
    
    static var btnN: UIColor {
        return UIColor.hexValue(0xfea914);
    }
    
    static var btnH: UIColor {
        return UIColor.hexValue(0xf1a013);
    }
    
    static var btnD: UIColor {
        return UIColor.hexValue(0x999999);
    }
    
    static var excel: UIColor {
        return UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0);
    }
    /// 青蓝
    static var lightBlue: UIColor {
        return UIColor.hexValue(0x29B5FE);
    }
    /// 亮橙
    static var lightOrange: UIColor {
        return UIColor.hexValue(0xFFBB50);
    }
    /// 浅绿
    static var lightGreen: UIColor {
        return UIColor.hexValue(0x1AC756);
    }
    
    static var textColor3: UIColor {
        return UIColor.hexValue(0x333333);
    }
    
    static var textColor6: UIColor {
        return UIColor.hexValue(0x666666);
    }
    
    static var textColor9: UIColor {
        return UIColor.hexValue(0x999999);
    }
    
    /// 获取某种颜色Alpha下的色彩
    static func alpha(_ color: UIColor, _ a: CGFloat = 1.0) -> UIColor{
        return color.withAlphaComponent(a)
    }

    static func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor{
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    /// [源]0x开头的16进制Int数字(无#前缀十六进制数表示，开头就是0x)
    static func hexValue(_ hex: Int, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: a)
    }
    
    /// [源]十六进制颜色字符串
    static func hex(_ hex: String, a: CGFloat = 1.0) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased();
        if cString.hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy:1);
            cString = String(cString[index...]);
        }
        
        if cString.count != 6 {
            return .red;
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2);
        let rString = String(cString[..<rIndex]);
        
        let otherString = String(cString[rIndex...]);
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2);
        let gString = String(otherString[..<gIndex]);
        
        let bIndex = cString.index(cString.endIndex, offsetBy: -2);
        let bString = String(cString[bIndex...]);
        
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r);
        Scanner(string: gString).scanHexInt32(&g);
        Scanner(string: bString).scanHexInt32(&b);
        
        //        print(hex,rString,gString,bString,otherString)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a);
    }
    /// 灰色背景
    static func dim(_ white: CGFloat, _ a: CGFloat = 1.0) -> UIColor{
        return .init(white: white, alpha: a);
    }
    
    static func randomColor() -> UIColor {
        let r = arc4random_uniform(256);
        let g = arc4random_uniform(256);
        let b = arc4random_uniform(256);
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1.0));
    }
    
    /// 两个颜色是否相等
    func equalTo(_ c2: UIColor) -> Bool {
        // some kind of weird rounding made the colors unequal so had to compare like this
        let c1 = self;
        var red: CGFloat = 0
        var green: CGFloat  = 0
        var blue: CGFloat = 0
        var alpha: CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2: CGFloat = 0
        var green2: CGFloat  = 0
        var blue2: CGFloat = 0
        var alpha2: CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255))
    }
}

