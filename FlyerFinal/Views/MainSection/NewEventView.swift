//
//  NewEventView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/25/22.
//

import SwiftUI

struct NewEventView: View {
    @Binding var newFlyer: Bool
    @Binding var viewType: String
    
    var body: some View {
        ZStack {
            Color("main").ignoresSafeArea()
            
            VStack {
                
                
                HStack {
                    Text("New Event")
                        .foregroundColor(.primary).font(.title2).padding([.leading,.top])
                    Spacer()
                }
                Picker(selection: $viewType, label: Text("New Type")) {
                    Text("Flyer").tag("flyer")
                    Text("Event").tag("event")
                }.pickerStyle(SegmentedPickerStyle()).frame(maxWidth: 400).padding(.bottom,5)
                
                Divider()
                
                ScrollView {
                    Text("Add something here")
                }
            }
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(newFlyer: .constant(true), viewType: .constant("event"))
    }
}
