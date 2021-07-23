//
//  HomeViewController.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/6.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

class HomeViewController: UIViewController {
    
    lazy var controller = NNPlateKeyboardController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white

        title = "车牌键盘"
        
        navigationItem.rightBarButtonItems = ["车牌键盘"].map({
            UIBarButtonItem(obj: $0) { item in
                let vc = NNPlateKeyboardController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        textField.frame = CGRect.make(10, 20, kScreenWidth - 20, 35)
        view.addSubview(textField)
        
        textField.becomeFirstResponder()
        view.getViewLayer()
    }
    //MARK: -lazy

    lazy var textField: UITextField = {
        let view = UITextField()
        
        return view
    }()

}

