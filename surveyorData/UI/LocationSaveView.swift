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
    @ObservedObject private var locationManager = LocationManager()
    @Binding var lat: Double
    @Binding var long: Double
    @State var buttonTitle: String = "Save Location"
    
    var body: some View {
        //forced unwrapping is ok here, because I check it is not null already
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
       return VStack{
            Button(buttonTitle){
                lat = coordinate.latitude
                long = coordinate.longitude
            //storeLoc()
            buttonTitle = "Location Saved. Click to replace"
        }
        }
    }
    public func storeLoc(){
        lat = 41.7658
        long = 72.6734
    }
}

struct LocationSaveView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Build & run instead")
    }
}
