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
            }
            VStack {
                if newFlyer {
                    NewFlyerView(newFlyer: $newFlyer)
                        .transition(.move(edge: .bottom))
                }
            }
        }.safeAreaInset(edge: .bottom) {
            HStack(spacing: 25) {
                if newFlyer {
                    Button {
                        newFlyer = false
                        userHub = false
                    } label: {
                        Image(systemName: "newspaper.circle")
                            .foregroundColor(.secondary)
                    }
                    Image(systemName: "plus.circle")
                        .foregroundColor(.primary)
                    Button {
                        newFlyer = false
                        userHub = true
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.secondary)
                    }
                }
                else if userHub {
                    Button {
                        userHub = false
                    } label: {
                        Image(systemName: "newspaper.circle")
                            .foregroundColor(.secondary)
                    }
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.secondary)
                    }
                    Image(systemName: "magnifyingglass.circle")
                        .foregroundColor(.primary)
                }
                else {
                    Image(systemName: "newspaper.circle")
                        .foregroundColor(.primary)
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.secondary)
                    }
                    Button {
                        userHub = true
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.secondary)
                    }
                }
            }.font(.system(size: 40))
                .padding(.horizontal,8)
                .padding(.vertical,5)
                .background(.ultraThickMaterial)
                .cornerRadius(20)
        }.animation(.spring(), value: userHub)
            .animation(.easeIn, value: newFlyer)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
