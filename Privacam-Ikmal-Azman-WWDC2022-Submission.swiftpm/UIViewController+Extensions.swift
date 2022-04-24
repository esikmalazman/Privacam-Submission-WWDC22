//
//  File.swift
//  UIKit App
//
//  Created by Ikmal Azman on 20/04/2022.
//

import UIKit.UIViewController

extension UIViewController {
    
    /// Contraints using safe area guide of root view
    var guide : UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
    /// Constraints using margin of the root view
    var margins : UILayoutGuide {
        return view.layoutMarginsGuide
    }

    func mainThread(_ completion : @escaping ()->Void) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func backgroundThread(_ qos : DispatchQoS.QoSClass = .background ,_ completion : @escaping ()->Void) {
        DispatchQueue.global(qos: qos).async {
            completion()
        }
    }
    
    func createSimpleButton(_ title : String,textColor : UIColor = .black,  bgColor : UIColor = .white, cornerRadius : CGFloat = 8) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = bgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = cornerRadius
        return button
    }
    
    func createSimpleLabel(_ text : String, alignment : NSTextAlignment = .center, textColor : UIColor, numberOfLines : Int = 0) -> UILabel {
        let label = UILabel()
        label.textAlignment = alignment
        label.textColor = textColor
        label.text = text
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createSimpleUIView(_ color : UIColor = .white) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func createSimpleAlertController(title : String = "", message : String, style : UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { _ in }
        alert.addAction(action)
        
        return alert
    }
}
