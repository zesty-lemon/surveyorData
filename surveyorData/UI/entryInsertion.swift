//
//  entryInsertion.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//
import SwiftUI
import CoreData

struct entryInsertion: View {
    //@ObservedObject var parentSurvey = Survey()
    @Binding var parentSurvey: Survey
    //@Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var locationManager = LocationManager()
    @State var buttonTitle: String = "Save Location"
    @Binding var needsRefresh: Bool
    @Binding var parentEntryList: [Entry]
    @State private var dataToAdd = [String]()
    @State private var entryHeaders: [String] = []
    @State private var entryAdditionFields:
        [EntryParameterView] = []
    @State var entryLat: Double = 0
    @State var entryLong: Double = 0
    
    //image saving properties
    @State private var image: Image?
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    //    func save() {
    //        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
    //        //  Save to Core Data
    //    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        return NavigationView{
            VStack {
                Form{
                    //save location button
                    if parentSurvey.containsLocation == true{
                        Section(header: Text("Location", comment: "Section Header - Location")) {
                            //LocationSaveView(lat: $entryLat, long: $entryLong)
                            Button(action: {
                                entryLat = coordinate.latitude
                                entryLong = coordinate.longitude
                                buttonTitle = "Tap to Replace"
                            }){
                                HStack(alignment: .center){
                                    Text(buttonTitle)
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
                    if parentSurvey.containsPhoto == true{
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
                                        Text("Select Photo")
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
                    Section(header: Text("Data", comment: "Section Header - Picture")) {
                        List(entryAdditionFields, id: \.id){ field in
                            field
                        }
                    }
                }
                .fullScreenCover(isPresented: $showImagePicker,
                                         onDismiss: loadImage) {ImagePicker(image: self.$inputImage).edgesIgnoringSafeArea(.all)}
//                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
            }
            .navigationBarTitle(Text("Add a sample"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Cancel").bold()
                                    }, trailing:
                                        Button(action: {
                                            createEntry()
                                            needsRefresh = true
                                            presentationMode.wrappedValue.dismiss()
                                        }) {
                                            Text("Save").bold()
                                        })
        }
        .onAppear{
            setupEntry()
        }
    }
    func setupEntry(){
        for i in 0..<parentSurvey.entryHeaders.count {
            dataToAdd.append("")
            entryHeaders.append(parentSurvey.entryHeaders[i])
            entryAdditionFields.append(EntryParameterView(index: dataToAdd.count-1,entryData: $dataToAdd, entryHeaders: $entryHeaders))
        }
    }
    func createEntry(){
        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntry = Entry(context: viewContext)
        newEntry.timeStamp = Date()
        newEntry.entryData = dataToAdd
        newEntry.survey = parentSurvey //set reference to it's parent survey
        print("parent id was \(parentSurvey.highestEntryId)")
        var tempHighestId = parentSurvey.highestEntryId + 1
        parentSurvey.highestEntryId = Int16(tempHighestId)
        newEntry.humanReadableID = parentSurvey.highestEntryId
        print("parent id is now \(parentSurvey.highestEntryId)")
        if parentSurvey.containsLocation == true{
            newEntry.lat = entryLat
            newEntry.long = entryLong
        }
        newEntry.image = pickedImage
        parentSurvey.addToEntry(newEntry)
        parentEntryList.append(newEntry)
        do {
            //save to database
            try viewContext.save()
            
        } catch {
            print("ERROR: ",error)
        }
        
    }
    
}

struct entryInsertion_Previews: PreviewProvider {
    static var previews: some View {
        Text ("No Preview Build Instead")
    }
}
