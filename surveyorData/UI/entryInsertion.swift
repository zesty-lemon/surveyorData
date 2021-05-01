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
    func save() {
        let pickedImage = inputImage?.jpegData(compressionQuality: 1.0)
        //  Save to Core Data
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    //https://www.simpleswiftguide.com/how-to-present-sheet-modally-in-swiftui/
    
    var body: some View {
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        return NavigationView{
                VStack {
                    Form{
                        if parentSurvey.containsLocation == true{
                            //LocationSaveView(lat: $entryLat, long: $entryLong)
                            Button(buttonTitle){
                                entryLat = coordinate.latitude
                                entryLong = coordinate.longitude
                            buttonTitle = "Location Saved. Click to replace"
                            }
                        }
                        if parentSurvey.containsPhoto == true{
                            Section(header: Text("Picture", comment: "Section Header - Picture")) {
                                if image != nil {
                                    image!
                                        .resizable()
                                        .scaledToFit()
                                        .onTapGesture { self.showImagePicker.toggle() }
                                } else {
                                    Button(action: { self.showImagePicker.toggle() }) {
                                        Text("Select Image", comment: "Select Image Button")
                                            .accessibility(identifier: "Select Image")
                                    }
                                }
                            }
                        }
                        List(entryAdditionFields, id: \.id){ field in
                            field
                        }
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage) { ImagePicker(image: self.$inputImage) }
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
            entryAdditionFields.append(EntryParameterView(index: dataToAdd.count-1,entryData: $dataToAdd, entryHeaders: $entryHeaders, entryDataTypes: $parentSurvey.entryDataTypes))
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
