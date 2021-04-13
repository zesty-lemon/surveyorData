//
//  EntryDataView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/28/21.
//
// View to display the data from an individual entry 
import SwiftUI
import CoreLocation

struct EntryDataView: View {
    @State var entry: Entry
    @Environment(\.presentationMode) var presentationMode
    @State var showingDetail = false
    
    var body: some View {
        ScrollView{
            if entry.survey.containsLocation {
                SingleEntryMapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
                    .ignoresSafeArea(edges: .top)
                    .frame(height:300)
            }
            
            if entry.survey.containsPhoto{
                CircleImageView(image: Image("demo_photo"))
                    .offset(y: -130)
                    .padding(.bottom, -130)
            }
            //            Text(entry.debugDescription)
            // Buttwiser - get it, cause it's like the beer, but instead of beer it's a sexy butt
            //
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
            ForEach(0..<entry.entryData.count) { i in
                HStack{
                    Text("\(entry.survey.entryHeaders[i]): ")
                    Text(entry.entryData[i])
                }
                Divider()
            }
        }
        .navigationTitle("Sample Data")
        .navigationBarItems(trailing: Button(action: {
            showingDetail = true
        }, label: {
            Text("Edit")
        }))
        .sheet(isPresented: $showingDetail) {
            ModifyEntryView(entryToModify: $entry)
        }
    }
}

struct EntryDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build and run yay")
    }
}
