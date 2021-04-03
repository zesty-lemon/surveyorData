//
//  EntryDataView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 3/28/21.
//
// View to display the data from an individual entry 
import SwiftUI

struct EntryDataView: View {
    @State var entry: Entry
    var body: some View {
        VStack {
            Text("Data for Entry")
            Text(entry.debugDescription)
        }
    }
}

struct EntryDataView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build and run yay")
    }
}
