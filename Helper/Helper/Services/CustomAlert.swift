////
////  CustomAlert.swift
////  Helper
////
////  Created by Катерина Фоменко on 21/03/2025.
////
//
//import Foundation
//import SwiftUI
//
//struct CustomAlert: View {
//    
//    var alertMessage: String
//    @Binding var showAlert: Bool
//    
//    var primaryBtn: (text: String, action: () -> Void)? // "OK"
//    var secondaryBtn: (text: String, action: () -> Void)? // "No"
//    
//    var body: some View {
//        VStack {
//            Text(alertMessage)
//                .font(.headline)
//                .multilineTextAlignment(.center)
//                .padding()
//            
//            HStack {
//                if let primaryBtn = primaryBtn {
//                    Button(primaryBtn.text) {
//                        primaryBtn.action()
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundStyle(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                }
//                if let secondaryBtn = secondaryBtn {
//                    Button(secondaryBtn.text) {
//                        secondaryBtn.action()
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundStyle(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                }
//            }
//            .padding()
//        }
//        .padding()
//        .background(Color.gray)
//        .frame(maxWidth: 300)
//        
//       // .shadow(radius: 10)
//        .cornerRadius(10)
//    }
//    
//    static func showAlert(message: String, showAlert: Binding<Bool>) -> some View {
//        return CustomAlert(alertMessage: message, showAlert: showAlert)
//    }
//}
//#Preview {
//    // Создаем состояние для показа/скрытия алерта
//    @Previewable @State var showAlert = true
//    
//    // Возвращаем представление с CustomAlert
////    return VStack {
////        Text("Пример предварительного просмотра")
////            .padding()
//        
//        // Показываем CustomAlert
//        CustomAlert(
//            alertMessage: "Это тестовое сообщение для предварительного просмотра!",
//            showAlert: $showAlert,
//            primaryBtn: ("OK", { print("OK нажата") }),
//            secondaryBtn: ("Отмена", { print("Отмена нажата") })
//        )
// //   }
// //   .padding()
//}
