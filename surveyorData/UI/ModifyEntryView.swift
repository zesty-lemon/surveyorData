//
//  ModifyEntryView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/12/21.
//
import SwiftUI
import CoreData
import CoreLocation
// Modifying an existing entry
struct ModifyEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var locationManager = LocationManager()
    
    @Binding var entryToModify: Entry
    
    @State private var dataToAdd: [String] = []
    @State private var entryHeaders: [String] = []
    @State private var entryAdditionFields: [ModifyParametersView] = []
    @State var locationButtonText = "Replace Location"
    
    //image saving properties
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    //store coordinates if user replaces them
    //This way if they click cancel entry is not modified
    
    @State var tempLat: Double?
    @State var tempLong: Double?
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        //gets location from the coordinate manager
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        NavigationView{
            Form{
                //button to save location
                if entryToModify.survey.containsLocation == true {
                    Section(header: Text("Location", comment: "Section Header - Location")) {
                        Button(action: {
                            tempLat = coordinate.latitude
                            tempLong = coordinate.longitude
                            locationButtonText = "Tap to Update"
                        }){
                            HStack(alignment: .center){
                                Text(locationButtonText)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Image(systemName: "map")
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue, lineWidth: 4)
                            )
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                //Button to save Photo
                if entryToModify.survey.containsPhoto == true{
                    Section(header: Text("Photo", comment: "Section Header - Picture")) {
                        if image != nil {
                            image!
                                .resizable()
                                .scaledToFit()
                                .onTapGesture { self.showImagePicker.toggle() }
                            Text("Tap Photo to Replace")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .foregroundColor(.blue)
                        } else {
                            Button(action: { self.showImagePicker.toggle() }) {
                                HStack(alignment: .center){
                                    Text("Replace Photo")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Image(systemName: "camera.fill")
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue, lineWidth: 4)
                                )
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }
                Section(header: Text("Data", comment: "Section Header - Data")) {
                    List(entryAdditionFields, id: \.id){ field in
                        field
                    }
                }
            }
            .fullScreenCover(isPresented: $showImagePicker,
                                     onDismiss: loadImage) {ImagePicker(image: self.$inputImage).edgesIgnoringSafeArea(.all)}
            .navigationBarTitle(Text("Edit Sample Data"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Cancel").bold()
                                    }, trailing:
                                        Button(action: {
                                            modifyEntry()
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Save").bold()
                                        })
        }
        .onAppear{
            setup()
        }
    }
    
    func setup(){
        dataToAdd = entryToModify.entryData
        entryHeaders = entryToModify.survey.entryHeaders
        for i in 0..<dataToAdd.count {
            entryAdditionFields.append(ModifyParametersView(index: i,entryData: $dataToAdd, entryHeaders: $entryHeaders))
        }
    }
    
    func modifyEntry(){
        entryToModify.entryData = dataToAdd
        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
        //only modify location if it has been set here
        if(tempLat != nil && tempLong != nil){
            //apple requires default value, which I have set to zero
            entryToModify.lat = tempLat ?? 0
            entryToModify.long = tempLong ?? 0
            print("Location Set")
        }
        if(inputImage != nil){
            entryToModify.image = pickedImage
        }
        //set photo equal to the photo from here
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ModifyEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build & Run")
    }
}
