import SwiftUI

struct IconLibraryView: View {
    @EnvironmentObject var dm: DM
    @Binding var isShowIconGalary: Bool
    @Binding var selectedIconLibrary: String
    
    let columns = [GridItem(.adaptive(minimum: 80), spacing: 5)]
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        let arrayImages = getAllImages(array: dm.parentCardsArray)
        let arrayImagesFiltr = arrayImages.filter { !$0.isEmpty && $0 != "" }
        let arrayImagesFix = arrayImagesFiltr.filter { !$0.contains("img_") }
        
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Маркер для отслеживания прокрутки
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: proxy.frame(in: .named("scroll")).minY
                            )
                    }
                    .frame(height: 1)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(arrayImagesFix, id: \.self) { iconName in
                            CardImageView(
                                imageName: iconName
                            )
                            .onTapGesture {
                                selectedIconLibrary = iconName
                                isShowIconGalary = false
                            }
                        }
                    }
                    .padding(.top, 60)
                }
            }
            .padding()
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
            }
            
            // Фиксированный заголовок
            Text("Icon Library")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.bar)
                .offset(y: max(0, -scrollOffset))
                .animation(.default, value: scrollOffset)
        }
        
        .onAppear {
            debugPrintArrays(arrayImages, arrayImagesFiltr)
        }
    }
    
    private func debugPrintArrays(_ arrayImages: [String], _ arrayImagesFix: [String]) {
        print("arrayImages: \(arrayImages.count)")
        print("arrayImagesFix (filtered): \(arrayImagesFix.count)")
    }
    
    private func getAllImages(array: [CardModel]) -> [String] {
        var childrenArray: [String] = []
        childrenArray += array.compactMap { $0.imageName }
        
        for icon in array {
            if let children = icon.childCards {
                let imagesChildren = children.compactMap { $0.imageName }
                childrenArray += imagesChildren
            }
        }
        return childrenArray
    }
}

// Ключ для отслеживания прокрутки
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    IconLibraryView(
        isShowIconGalary: .constant(true),
        selectedIconLibrary: .constant("sun.max.fill")
    )
    .environmentObject(DM(speechManager: SpeechManager(lang: "en")))
}
