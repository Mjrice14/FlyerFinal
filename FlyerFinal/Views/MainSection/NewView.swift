//
//  NewView.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/25/22.
//

import SwiftUI

struct NewView: View {
    @Binding var newFlyer: Bool
    @State private var newType = "flyer"
    
    var body: some View {
        VStack {
            if newType == "flyer" {
                NewFlyerView(newFlyer: $newFlyer, viewType: $newType)
            }
        }
    }
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        NewView(newFlyer: .constant(true))
    }
}
