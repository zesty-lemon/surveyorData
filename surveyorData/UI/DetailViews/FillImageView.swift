//
//  FillImageView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 5/2/21.
//

import SwiftUI

struct FillImageView: View {
    var image: Image
    @Environment(\.presentationMode) var presentationMode
    @State var items: [Any] = []
    var body: some View {
        //change this to be dynamically, which is basically impossible
        NavigationView{
            VStack{
//                Button(action: {
//                    sharePhoto(Info: "test")
//                }) {
//                    HStack{
//                        Text("Share Photo")
//                            .fontWeight(.bold)
//                        Image(systemName: "tray.and.arrow.up.fill")
//                    }
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.blue, lineWidth: 3)
//                    )
//                }
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
            }
            .navigationBarTitle(Text("Photo Preview"), displayMode: .inline)
            .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Done").bold()
                                    })
        }
    }
    
    //issues come from sharing a photo within the modal sheet.  Maybe I can call dismiss on this sheet, and set a flag in the parent view that itself calls the sharePhoto method.  
//    func sharePhoto(Info: String){
//        let infoU = Info
//        let av = UIActivityViewController(activityItems: [infoU], applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
//    }
}

struct FillImageView_Previews: PreviewProvider {
    static var previews: some View {
        FillImageView(image: Image("demo_photo"))
    }
}
