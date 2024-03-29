//
//  surveyDataView.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//
import UIKit //used for the share sheet
import SwiftUI
import Foundation
import MapKit
// This page shows all the entries in a survey
// It also handles export operations
enum SurveyModalView {
    case insertion
    case map
}
//entries within survey
struct surveyDataView: View {
    @Environment(\.managedObjectContext) var moc //maybe replace with viewContext?
    @Environment(\.presentationMode) var presentationMode
    @State var parentSurvey: Survey
    @State var showingDetail = false
    @State var entries: [Entry]
    @State var exportItems: [Any] = []
    @State var modalView: SurveyModalView = .insertion
    @State var isSheetShown = false
    
    @State var needsRefresh: Bool = true {
        didSet{
            print("It's set")
            if needsRefresh {
                print("needs refresh")
                refresh()
                needsRefresh = false
            }
        }
    }
    var body: some View {
        VStack {
            if entries.count == 0 {
                VStack{
                    Text("No Samples").font(.largeTitle)
                    Text("Add a sample using the Plus button")
                        .navigationTitle(parentSurvey.surveyTitle)
                        .navigationBarItems(trailing: Button(action: {
                            self.modalView = .insertion //set modal view to be the photo case
                            self.isSheetShown = true
                            //showingDetail = true
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: CGFloat(Constants.iconSize)))
                        }))
                        .sheet(isPresented: $isSheetShown, onDismiss: {
                            self.isSheetShown = false
                        }, content: {
                            if self.modalView == .insertion {
                                entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                            }
                        })
                    //                        .sheet(isPresented: $showingDetail) {
                    //                            entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                    //                        }
                }
            }
            else {
                VStack{
                    //need a hstack of buttons here with actions like export etc
                    VStack{
                        Text("Samples in \(parentSurvey.surveyTitle)")
                            .font(.title)
                            .padding()
                        HStack{
                            Button(action: {
                                shareCSV(toExport: exportData())
                                //exportData()
                            }) {
                                HStack{
                                    Text("Export")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Image(systemName: "tray.and.arrow.up.fill")
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.green, lineWidth: 4)
                                )
                            }
                            //only show map button if there are coordinates saved
                            if (parentSurvey.containsLocation){
                                Button(action: {
                                    self.modalView = .map //set modal view to be the photo case
                                    self.isSheetShown = true
                                }) {
                                    HStack{
                                        Text("Map")
                                            .fontWeight(.bold)
                                            .foregroundColor(.green)
                                        Image(systemName: "map.fill")
                                    }
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.green, lineWidth: 4)
                                    )
                                }
                            }
                        }
                        Divider()
                    }
                   // .padding()
                    
                    //Show all samples in a given survey
                    List{
                        ForEach(entries, id: \.id) { entry in
                            NavigationLink(destination:EntryDataView(entry: entry)
                            ){
                                HStack {
                                    Text("Sample \(entry.humanReadableID) - \(formatTime(entry.timeStamp)) on \(formatDate(entry.timeStamp))")
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .onDelete(perform: deleteEntry(at:))
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle(parentSurvey.surveyTitle)
                    .navigationBarItems(trailing: Button(action: {
                        self.modalView = .insertion //set modal view to be the photo case
                        self.isSheetShown = true
                        //showingDetail = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: CGFloat(Constants.iconSize)))
                    }))
                    .sheet(isPresented: $isSheetShown, onDismiss: {
                        self.isSheetShown = false
                    }, content: {
                        if self.modalView == .insertion {
                            entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                        }
                        else if self.modalView == .map{
                            SamplesMapView(inputCoordinates: getAllCoordinates())
                        }
                    })
                    //                    .sheet(isPresented: $showingDetail) {
                    //                        entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                    //                    }
                }
            }
            
        }
    }
    func getAllCoordinates() -> [CLLocationCoordinate2D]{
        var coordinates = [CLLocationCoordinate2D]()
        for eachEntry in parentSurvey.entries(){
            if parentSurvey.containsLocation {
                coordinates.append(CLLocationCoordinate2D(latitude: eachEntry.lat, longitude: eachEntry.long))
            }
        }
        return coordinates
    }
    func exportData() -> URL{
        //need to pass sample ID Numbers
        //need to handle making filenames
        //need to include locations
        //Need if include photos is checked than photo name
        //need to pass back a URL
        //just name it after surveyname with spaces stripped, and when creating survey check there are no duplicate names
        let sFileName = "\(parentSurvey.surveyTitle).csv"
        //document directory path
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //create nsurl object, append filename to url
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
        let output = OutputStream.toMemory()
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        //CSV File Top Stuff
        csvWriter?.writeField("Survey: ")
        csvWriter?.writeField("\(parentSurvey.surveyTitle)")
        csvWriter?.finishLine()
        //this can be hardcoded because default is WGS84 and cannot be changed
        if parentSurvey.containsLocation {
            csvWriter?.writeField("Coordinate System:")
            csvWriter?.writeField("WGS84")
        }
        csvWriter?.finishLine()
        
        //Setup columns in CSV from entryHeaders
        csvWriter?.writeField("Sample ID")
        for(field) in parentSurvey.entryHeaders{
            csvWriter?.writeField(field)
        }
        if parentSurvey.containsLocation {
            csvWriter?.writeField("lat")
            csvWriter?.writeField("long")
        }
        csvWriter?.finishLine()
        
        //Get data in format to import to CSV
        var arrSurveyData = [[String]]()
        
        //read in all entry values into 2d array
        //this array will be converted to CSV later
        for eachEntry in parentSurvey.entries(){
            //case when samples have lat long
            if parentSurvey.containsLocation {
                var tempArr = [String]()
                tempArr.append(String(Int(eachEntry.humanReadableID)))
                tempArr.append(contentsOf: eachEntry.entryData)
                tempArr.append("\(eachEntry.lat)")
                tempArr.append("\(eachEntry.long)")
                arrSurveyData.append(tempArr)
            }
            //when samples don't have lat long
            else{
                arrSurveyData.append(eachEntry.entryData)
            }
        }
        //Import data to the CSV file
        for(elements) in arrSurveyData.enumerated(){
            //for all the data in each row
            for i in 0..<elements.element.count {
                csvWriter?.writeField(elements.element[i])
            }
            csvWriter?.finishLine()
        }
        csvWriter?.closeStream()
        
        // Save CSV
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        do{
            try buffer.write(to: documentURL)
        }
        catch
        {
            print("save error")
        }
        return documentURL
    }
    //returns a date formatted as a string
    func formatDate(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: date)
    }
    func formatTime(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    func refresh(){
        //entries = parentSurvey.entries()
        needsRefresh = false
        print("Refreshed")
    }
    func deleteEntry(at offsets: IndexSet) {
        for index in offsets {
            let user = entries[index]
            moc.delete(user)
            entries.remove(at: index)
        }
        try? moc.save()
    }
    func shareCSV(toExport: Any){
        let infoU = toExport
        let av = UIActivityViewController(activityItems: [infoU], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
