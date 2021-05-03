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
    @State private var isShareSheetShowing = false
    @State private var isSheetShowing = false
    @State var items: [Any] = []
    var body: some View {
        //change this to be dynamically, which is basically impossible
        NavigationView{
            VStack{
                Button(action: {
                    //shareButton()
                    items.removeAll()
                    items.append(image)
                    isSheetShowing.toggle()
                }) {
                    HStack{
                        Text("Share Photo")
                            .fontWeight(.bold)
                        Image(systemName: "tray.and.arrow.up.fill")
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 3)
                    )
                }
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
        .sheet(isPresented: $isSheetShowing, content: {
            ShareSheet(items: items)
        })
    }
    // export image button
    func shareButton(){
        isShareSheetShowing.toggle()
        let url = URL(string: "https://apple.com")
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    struct ShareSheet: UIViewControllerRepresentable {
        var items : [Any]
        func makeUIViewController(context: Context) -> some UIViewController {
            let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return controller
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            //do nothing
        }
    }
}

struct FillImageView_Previews: PreviewProvider {
    static var previews: some View {
        FillImageView(image: Image("demo_photo"))
    }
}
