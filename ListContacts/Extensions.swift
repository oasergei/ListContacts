//
//  Extensions.swift
//  ListContacts
//
//  Created by Sergey on 12.09.2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit

extension String {
    
    func normalizePhoneNumber() -> String {
        return self.replacingOccurrences(of: "[^+0-9]", with: "", options: .regularExpression)
    }
    
    func convertFromStringToDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date ?? Date())
    }
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
}

extension UIApplication {
    
    func showToastMessage(_ message: String,
                          withDuration duration: TimeInterval = 0.3,
                          timeIntervalToHide: TimeInterval = 3,
                          backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5),
                          textColor: UIColor = .white){
        
        let errorLabelTag = 111111
        let labelIdentifier = "error label"
        
        if let view = UIApplication.shared.keyWindow?.viewWithTag(errorLabelTag) {
            if view.restorationIdentifier == labelIdentifier {
                return
            }
        }
        
        DispatchQueue.main.async {
            let label = UILabel(frame: CGRect(x: 32, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 64, height: 44))
            label.backgroundColor = backgroundColor
            label.text = message
            label.textColor = textColor
            label.textAlignment = .center
            label.tag = errorLabelTag
            label.restorationIdentifier = labelIdentifier
            
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            UIApplication.shared.keyWindow?.addSubview(label)
            
            Timer.scheduledTimer(timeInterval: timeIntervalToHide, target: self, selector: #selector(self.hideErrorLabel), userInfo: nil, repeats: false)
            
            UIView.animate(withDuration: duration) {
                label.frame.origin.y -= label.frame.height * 3
                UIApplication.shared.keyWindow?.layoutIfNeeded()
            }
        }
    }
    
    func showErrorLabel(withText text: String) {
        showToastMessage(text)
    }
    
    @objc private func hideErrorLabel () {
        let errorLabelTag = 111111
        let labelIdentifier = "error label"
        
        if let errorLabel = UIApplication.shared.keyWindow?.viewWithTag(errorLabelTag) {
            if errorLabel.restorationIdentifier != labelIdentifier {
                return
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: {
                    errorLabel.frame.origin.y = UIScreen.main.bounds.height
                }) { done in
                    errorLabel.removeFromSuperview()
                }
            }
        }
    }
}
