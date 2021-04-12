//
//  LocationSaveView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/9/21.
//

import SwiftUI
import Foundation
import MapKit
// need to start process to collect location when the entryInsertion page loads for the first time,
// that way the user does not have to wait

struct LocationSaveView: View {
    @Binding var lat: Double
    @Binding var long: Double
    @State var buttonTitle: String = "Save Location"
    
    var body: some View {
        VStack{
            Button(buttonTitle){
            storeLoc()
            buttonTitle = "Location Saved. Click to replace"
        }
        }
    }
    public func storeLoc(){
        //do nothing
        lat = 41.7658
        long = 72.6734
    }
}

struct LocationSaveView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build & run instead")
    }
}
