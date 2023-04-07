//
//  NNPlateKeyboard.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/10.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

@objc public protocol NNPlateKeyboardDeleagte {
    @objc func plateDidChange(_ plate: String, complete: Bool)
}
/// 车牌号键盘
@objc public class NNPlateKeyboard: NSObject {
    @objc public weak var delegate: NNPlateKeyboardDeleagte?

    ///当前格子中的输入内容
    @objc public var plateNumber = "" {
        willSet{
            guard newValue.count >= 7 else { return }
            inputIndex = min(maxCount - 1, newValue.count)
//            DDLog("plateNumber_\(newValue)_\(inputIndex)")

            keyboardAccessoryView.plateNumber = newValue
            keyboardView.plateNumber = newValue;
            inputTextfield.text = newValue;
        }
    }
    ///最大车牌号位数
    @objc public var maxCount = 7 {
        willSet{
            keyboardAccessoryView.maxCount = newValue
            keyboardView.maxCount = newValue;
        }
    }
    @objc public var inputIndex = 0 {
        willSet{
            keyboardAccessoryView.inputIndex = newValue;
            keyboardView.inputIndex = newValue;
        }
    }
    
    @objc public var numType = NNKeyboardNumType.auto {
        willSet{
            keyboardView.numType = newValue;
        }
    }
    ///当前输入框
    var inputTextfield: UITextField!
    ///改变键盘类型
    @objc public func changeKeyboardNumType(isNewEnergy: Bool){
        guard let keyboardView = inputTextfield.inputView as? NNKeyboardView else { return }
        keyboardView.numType = isNewEnergy ? .newEnergy : .auto
        var numType = keyboardView.numType
        
        if plateNumber.count > 0, plateNumber.hasPrefix("W") {
            numType = .wuJing
        }
        let isPlateCount8 = (numType == .newEnergy || numType == .wuJing);
        maxCount = isPlateCount8 ? 8 : 7

//        DDLog("之前:changeKeyboardNumType:\(maxCount)_\(plateNumber)_\(inputIndex)")
        if plateNumber.count >= maxCount {
            plateNumber = (plateNumber as NSString).substring(to: maxCount)
            inputIndex = maxCount - 1
        } else {
            inputIndex = plateNumber.count
        }
//        DDLog("之后:changeKeyboardNumType:\(maxCount)_\(plateNumber)_\(inputIndex)")
        keyboardView.updateKeyboard(isMoreType: false)
    }
    
    ///将车牌输入框绑定到 UITextField
    @objc public func bindTextField(_ textField: UITextField, showSearch: Bool = false) {
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.placeholder = " 请输入车牌号码";
        if showSearch {
//            let image = UIImage(named: "search_bar")
            let image = UIImage(named: "search_bar", podClass: NNPlateKeyboard.self)
            textField.setupLeftView(image: image)
        }

        inputTextfield = textField
        inputTextfield.inputView = keyboardView
        inputTextfield.inputAccessoryView = keyboardAccessoryView
    }
    ///键盘视图
    @objc lazy var keyboardView: NNKeyboardView = {
        let view = NNKeyboardView(frame: .zero)
        view.delegate = self

        return view
    }()
    ///键盘辅助视图
    @objc lazy var keyboardAccessoryView: NNKeyboardAccessoryView = {
        let view = NNKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50);
        view.maxCount = 7
        view.delegate = self
        view.switchBtn.addTarget(self, action: #selector(handleActionBtn), for: .touchUpInside)
        return view
    }()

    @objc private func handleActionBtn(_ sender: UIButton) {
//        DDLog("inputIndex_\(inputIndex)")
        sender.isSelected = !sender.isSelected;
        changeKeyboardNumType(isNewEnergy: sender.isSelected)
    }

}

extension NNPlateKeyboard: NNKeyBoardViewDeleagte{
    
    func keyboardViewSelect(key: String) {
        var isMoreType = false

        switch key {
        case NNKeyboardEngine.kSTR_More.replacingOccurrences(of: ",", with: ""):
            isMoreType = true;
            
        case NNKeyboardEngine.kSTR_Back.replacingOccurrences(of: ",", with: ""):
            isMoreType = false;
            
        case NNKeyboardEngine.kSTR_Delete.replacingOccurrences(of: ",", with: ""):
            if plateNumber.count > 0 {
                plateNumber = (plateNumber as NSString).substring(to: plateNumber.count - 1)
            }

        case NNKeyboardEngine.kSTR_Sure:
            UIApplication.shared.keyWindow?.endEditing(true)
            delegate?.plateDidChange(plateNumber, complete: true)
            return;
            
        default:
//            DDLog("之前:\(key) \(plateNumber) \(plateNumber.count) \(inputIndex)")
            if keyboardView.numType != .newEnergy {
                keyboardView.numType = NNKeyboardEngine.detectNumTypeOf(plateNumber: plateNumber)
            }
            maxCount = (keyboardView.numType == .newEnergy || keyboardView.numType == .wuJing) ? 8 : 7;
            if plateNumber.count == maxCount {
                plateNumber = (plateNumber as NSString).replacingCharacters(in: NSRange(location: inputIndex, length: 1), with: key)
            } else {
                if plateNumber.count > inputIndex {
                    plateNumber = (plateNumber as NSString).replacingCharacters(in: NSRange(location: inputIndex, length: 1), with: key)
                } else {
                    plateNumber += key
                }
            }
        }
        
        if plateNumber.count >= maxCount {
            inputIndex = maxCount - 1
        } else {
            inputIndex = plateNumber.count
        }
        keyboardAccessoryView.inputIndex = inputIndex
        
        DDLog("之后:\(key) \(plateNumber) \(plateNumber.count) \(inputIndex)")
        if plateNumber.count <= maxCount {
            keyboardView.updateKeyboard(isMoreType: isMoreType)
        }

        if !isMoreType {
            delegate?.plateDidChange(plateNumber, complete: (plateNumber.count == maxCount))
        }
    }
   
}


extension NNPlateKeyboard: NNKeyboardAccessoryViewDeleagte{

    func keyboardAccessoryView(inputIndex: Int) {
        self.inputIndex = inputIndex
        keyboardView.updateKeyboard(isMoreType: false)
    }

}


@objc public extension UITextField{
    /// 设置 leftView 图标
    func setupLeftView(image: UIImage?, viewMode: UITextField.ViewMode = .always) {
        if image == nil {
            return
        }
        if leftView != nil {
            leftViewMode = viewMode
            return
        }
     
        leftViewMode = viewMode; //此处用来设置leftview显示时机
        leftView = {
            let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            
            let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: 15, height: 15));
            imgView.image = image
            imgView.contentMode = UIView.ContentMode.scaleAspectFit;
            imgView.center = view.center;
            view.addSubview(imgView);
          
            return view;
        }()
    }
}
