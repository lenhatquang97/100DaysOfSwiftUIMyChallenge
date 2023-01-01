import SwiftUI
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View{ 
    func titlestyle1() -> some View{
        self.modifier(Title()) 
    } 
}



struct CustomText: View{
    var text: String
    var body: some View{
        Text(text)
            .padding()
            .background(.orange)
            .containerShape(Capsule())
            .titlestyle1()
            
            
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 10) {
            CustomText(text: "First")
            CustomText(text: "Second")
        }
    }
}
