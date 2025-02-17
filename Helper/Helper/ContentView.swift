//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

struct ContentView: View {
    
    static var widthStackLV: CGFloat = 95
    // @State var colums = Array(repeating: GridItem(.flexible()), count: 4)
    // @State var colums2 = Array(repeating: GridItem(.flexible()), count: 4)
    @State var columsMain = [GridItem(.adaptive(minimum: widthStackLV), spacing: 5)]
    @State var columsTop2 = [GridItem(.adaptive(minimum: 50, maximum: 50))]
    @State var columsTop = [GridItem(.fixed(100))]
   
        var body: some View {
        
         
             
            //GeometryReader { geometry in
                VStack(spacing: 0)  {
                    ScrollView(.horizontal) {
                        SelectedItemsView(columsMain: $columsTop)
                            .frame(width: 90)
                    }
                    .frame(height: 120)
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 30)
                    
                    ScrollView {
                        CardGridView(colums: $columsMain)
                   
                    }
                }
            }
        }
    


#Preview {
    
    ContentView()
}
