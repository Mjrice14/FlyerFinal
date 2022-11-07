//
//  UserFeed.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI

struct UserFeed: View {
    var body: some View {
        ZStack {
            //Color.primary.ignoresSafeArea()
            Color("main").ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("User Serach").font(.title2.weight(.medium))
                        .padding([.leading,.top])
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct UserFeed_Previews: PreviewProvider {
    static var previews: some View {
        UserFeed()
    }
}
