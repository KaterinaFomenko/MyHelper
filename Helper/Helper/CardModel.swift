//
//  CardModel.swift
//  Helper
//
//  Created by Катерина Фоменко on 12/02/2025.
//

import Foundation
import SwiftUI

struct CardModel: Identifiable {
    var id = UUID()
    var title: String = ""
    var image: String = ""
    var colorSection: Color = .white
    var groupId: Int = 0
}


