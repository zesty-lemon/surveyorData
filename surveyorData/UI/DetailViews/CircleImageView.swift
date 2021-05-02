import SwiftUI
struct CircleImageView: View {
    var image: Image
    @State private var isActive : Bool = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: FillImageView(image: image), isActive: self.$isActive) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .frame(width: 200)
    }
        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(image: Image("demo_photo"))
    }
}
