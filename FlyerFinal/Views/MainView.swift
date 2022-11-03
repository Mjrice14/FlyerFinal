//
//  MainView.swift
//  FlyerFinal
//
//  Created by macOS on 11/1/22.
//

import SwiftUI

struct MainView: View {
    @State private var userHub = false
    @State private var newFlyer = false
    
    var body: some View {
        ZStack {
            FlyerFeed()
            VStack {
                if userHub {
                    UserFeed()
                        .transition(.move(edge: .trailing))
                }
                if newFlyer {
                    NewFlyerView(newFlyer: $newFlyer)
                }
            }
        }.safeAreaInset(edge: .bottom) {
            if !newFlyer {
                HStack(spacing: 25) {
                    if !userHub {
                        Image(systemName: "newspaper.circle")
                        
                        Button {
                            userHub = true
                        } label: {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.secondary)
                            
                        }
                    }
                    else {
                        Button {
                            userHub = false
                        } label: {
                            Image(systemName: "newspaper.circle")
                                .foregroundColor(.secondary)
                            
                        }
                        Image(systemName: "magnifyingglass.circle")
                    }
                }.font(.system(size: 40))
                    .padding(.horizontal,8)
                    .padding(.vertical,5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                if !userHub {
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus").padding(8).font(.system(size: 36)).foregroundColor(.primary).background(.ultraThinMaterial, in: Circle())
                    }.offset(x: 150)
                }
            }
        }.animation(.spring(), value: userHub)
            .animation(.easeIn, value: newFlyer)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
