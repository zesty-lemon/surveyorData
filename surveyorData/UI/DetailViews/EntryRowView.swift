//
//  EntryRowView.swift
//  surveyorData
//
//  Created by Giles Lemmon on 4/12/21.
//

import SwiftUI

struct EntryRowView: View {
    var parameterName: String
    var parameterValue: String
    var body: some View {
        HStack{
            Text("\(parameterName) : ")
            Text("\(parameterValue)")
        }
    }
}

struct EntryRowView_Previews: PreviewProvider {
    static var previews: some View {
        EntryRowView(parameterName: "Age", parameterValue: "32")
    }
}
