//
//  surveyDataView.swift
//  surveyorData
//  Created by Giles Lemmon on 3/16/21.
//

import SwiftUI
//entries within survey
struct surveyDataView: View {
    @Environment(\.managedObjectContext) var moc //maybe replace with viewContext?
    @State var parentSurvey: Survey
    @State var showingDetail = false
    @State var entries: [Entry]
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
            //Text(parentSurvey.debugDescription)
            if entries.count == 0 {
                VStack{
                    Text("No Samples").font(.largeTitle)
                    Text("Add a sample using the Plus button")
                        .navigationTitle(parentSurvey.surveyTitle)
                        .navigationBarItems(trailing: Button(action: {
                            showingDetail = true
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: CGFloat(Constants.iconSize)))
                        }))
                        .sheet(isPresented: $showingDetail) {
                            entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                        }
                }
            }
            else {
                VStack{
                    VStack{
                        Button("Generate CSV"){
                            exportData()
                        }
                        Text("Statistics")
                            .font(.title)
                            .foregroundColor(Color.black)
                        HStack {
                            Text("Number of samples: ")
                                .multilineTextAlignment(.center)
                            //Spacer()
                            Text(" \(String(parentSurvey.entries().count))")
                        }
                        .font(/*@START_MENU_TOKEN@*/.subheadline/*@END_MENU_TOKEN@*/)
                        Divider()
                    }
                    .padding()
                    //here, put little statistics showing like number of samples collected, etc
                    Text("Samples in \(parentSurvey.surveyTitle)")
                        .font(.title)
                    List{
                        ForEach(entries, id: \.id) { entry in
                            NavigationLink(destination:EntryDataView(entry: entry)
                            ){
                                HStack {
                                    Text("Sample: \(entry.timeStamp)")
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }
                        .onDelete(perform: deleteEntry(at:))
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle(parentSurvey.surveyTitle)
                    .navigationBarItems(trailing: Button(action: {
                        showingDetail = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: CGFloat(Constants.iconSize)))
                    }))
                    .sheet(isPresented: $showingDetail) {
                        entryInsertion(parentSurvey: $parentSurvey, needsRefresh: $needsRefresh,parentEntryList: $entries)
                    }
                }
            }
            
        }
    }
    func exportData(){
        //need to pass sample ID Numbers
        //need to handle making filenames
        //Need if include photos is checked than photo name
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
        csvWriter?.finishLine()
        
        //Setup columns in CSV from entryHeaders
        for(field) in parentSurvey.entryHeaders{
            csvWriter?.writeField(field)
        }
        csvWriter?.finishLine()
        
        //Get data in format to import to CSV
        var arrSurveyData = [[String]]()
        //need some error checking here, to check for off by one errors
        //read in all entry values into 2d array
        for eachEntry in parentSurvey.entries(){
            arrSurveyData.append(eachEntry.entryData)
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
            print("little error boi")
        }
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
}

struct surveyDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("No Preview Build & Run Instead")
    }
}
