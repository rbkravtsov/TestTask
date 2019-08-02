//
//  UIImage+Own.swift
//  VQ_videoeditor_app
//
//  Created by Roman Kravtsov on 14/07/2019.
//  Copyright © 2019 Roman Kravtsov. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum equalizerImage: String, CaseIterable {
        case sound1
        case sound2
        case sound3
        
        static func getRandomEqualizerImage() -> UIImage? {
            
            if let soundImageName = equalizerImage.allCases.randomElement()?.rawValue {
                return UIImage(named: soundImageName)
            } else {
                return nil
            }
            
        }
    }
}
