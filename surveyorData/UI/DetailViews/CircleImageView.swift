import SwiftUI
struct CircleImageView: View {
    var image: Image
    
    var body: some View {
        //change this to be dynamically, which is basically impossible
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 5)
                    .frame(width: 200)
//        GeometryReader { geo in
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: geo.size.width/2)
//                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                .overlay(Circle().stroke(Color.white, lineWidth: 4))
//            //.position(x: geo.size.width / 2)
//        }
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(image: Image("demo_photo"))
    }
}
