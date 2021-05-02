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
    var body: some View {
        //change this to be dynamically, which is basically impossible
        NavigationView{
            image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
        .navigationBarTitle(Text("Photo Preview"), displayMode: .inline)
        .navigationBarItems(trailing:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Done").bold()
                                    })
        }
    }
}

struct FillImageView_Previews: PreviewProvider {
    static var previews: some View {
        FillImageView(image: Image("demo_photo"))
    }
}
