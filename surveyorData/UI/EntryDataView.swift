//
//  EntryDataView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/28/21.
//
// View to display the data from an individual entry 
import SwiftUI
import CoreLocation

enum ModalView {
    case photo
    case edit
}
struct EntryDataView: View {
    @State var entry: Entry
    @Environment(\.presentationMode) var presentationMode
    @State var modalView: ModalView = .edit
    @State var isSheetShown = false
    
    var body: some View {
        ScrollView{
            if entry.survey.containsLocation {
                SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: entry.lat, longitude:entry.long))
                    .ignoresSafeArea(edges: .top)
                    .frame(height:300)
            }
            if entry.survey.containsPhoto{
//                CircleImageView(image: Image(uiImage: UIImage(data: entry.image ?? Data()) ?? UIImage()))
                //clickable photo that shows the photo in full screen
                Button(action: {
                    self.modalView = .photo //set modal view to be the photo case
                    self.isSheetShown = true
                }){
                    Image(uiImage: UIImage(data: entry.image ?? Data())!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 5)
                        .frame(width: 200)
                }
                    .offset(y: -130)
                    .padding(.bottom, -180)
            }
            VStack(alignment: .leading) {
                Text("Sample Data")
                    .font(.title)
                    .foregroundColor(Color.black)
                HStack {
                    Text("Date Added")
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(entry.timeStamp.addingTimeInterval(600), style: .date)
                }
                .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                HStack {
                    Text("Time Added")
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(entry.timeStamp.addingTimeInterval(600), style: .time)
                }
                .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                Divider()
            }
            .padding()
            // need to check for off by one errors
            //Text(entry.debugDescription)
            ForEach(0..<entry.entryData.count) { i in
                HStack{
                    Text("\(entry.survey.entryHeaders[i]): ")
                    Text(entry.entryData[i])
                    .multilineTextAlignment(.leading)
                }
                Divider()
            }
        }
        .navigationTitle("Sample Data")
        .navigationBarItems(trailing: Button(action: {
            self.modalView = .edit
            self.isSheetShown = true
        }, label: {
            Text("Edit")
        }))
        // switch between showing edit view and photo view
        .sheet(isPresented: $isSheetShown, onDismiss: {
            self.isSheetShown = false
        }, content: {
            if self.modalView == .edit {
                ModifyEntryView(entryToModify: $entry)
            } else if self.modalView == .photo {
                FillImageView(image: Image(uiImage: UIImage(data: entry.image ?? Data()) ?? UIImage()))
            }
        })
    }
}

struct EntryDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build and run yay")
    }
}
