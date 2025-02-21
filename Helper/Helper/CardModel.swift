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
    var colorSection: String = ""
    var groupId: Int = 0
    var image: String = ""
    var cardId: Int = 1
}



