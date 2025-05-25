//
//  DeviceLayoutHelper.swift
//  Helper
//
//  Created by Катерина Фоменко on 25/05/2025.
//

import Foundation
import SwiftUICore
import UIKit

class DeviceLayoutHelper: ObservableObject {
    
    @Published var verticalSizeClass: UserInterfaceSizeClass?
    @Published var horizontalSizeClass: UserInterfaceSizeClass?
    
    static let shared = DeviceLayoutHelper()
    
//    func isPortrait(for size: CGSize) -> Bool {
//        size.height > size.width
//    }
//    
//    var isTablet: Bool {
//        UIDevice.current.userInterfaceIdiom == .pad &&
//        horizontalSizeClass == .regular &&
//        verticalSizeClass == .regular
//    }
//    
//    // Размеры карточек
//    func baseSize(for size: CGSize) -> CGFloat {
//        if isTablet {
//            return size.width / 1.8
//        } else {
//            return size.width / 1.3
//        }
//    }
//    
//    func baseSizeImage(for size: CGSize) -> CGFloat {
//        if isTablet {
//            return size.width / 2.2
//        } else {
//            return size.width / 2
//        }
//    }
    
    func baseSize(for size: CGSize) -> CGFloat {
        if size.width >= 768 {
            return size.width / 1.8 // iPad или широкое окно
        } else {
            return size.width / 1.3 // iPhone
        }
    }
    
    func baseSizeImage(for size: CGSize) -> CGFloat {
        if size.width >= 768 {
            return size.width / 2.2
        } else {
            return size.width / 2
        }
    }

    
}
