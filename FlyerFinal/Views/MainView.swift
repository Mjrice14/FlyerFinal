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
    @State private var eventHub = false
    
    var body: some View {
        ZStack {
            FlyerFeed()
            VStack {
                if userHub {
                    UserFeed()
                }
            }
            VStack {
                if eventHub {
                    EventFeed()
                }
            }
            VStack {
                if newFlyer {
                    NewFlyerView(newFlyer: $newFlyer)
                        .transition(.move(edge: .trailing))
                }
            }
        }.safeAreaInset(edge: .bottom) {
            HStack(spacing: 20) {
                if newFlyer {
                    Button {
                        newFlyer = false
                        userHub = false
                        eventHub = false
                    } label: {
                        Image(systemName: "newspaper.circle")
                            .foregroundColor(.primary)
                    }
                    Button {
                        userHub = false
                        eventHub = true
                        newFlyer = false
                    } label: {
                        Image(systemName: "calendar.circle")
                            .foregroundColor(.primary)
                    }
                    Image(systemName: "plus.square.fill")
                        .foregroundColor(.primary)
                    Button {
                        newFlyer = false
                        userHub = true
                        eventHub = false
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.primary)
                    }
                }
                else if userHub {
                    Button {
                        userHub = false
                        eventHub = false
                        newFlyer = false
                    } label: {
                        Image(systemName: "newspaper.circle")
                            .foregroundColor(.primary)
                    }
                    Button {
                        userHub = false
                        eventHub = true
                        newFlyer = false
                    } label: {
                        Image(systemName: "calendar.circle")
                            .foregroundColor(.primary)
                    }
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus.square")
                            .foregroundColor(.primary)
                    }
                    Image(systemName: "magnifyingglass.circle.fill")
                        .foregroundColor(.primary)
                }
                else if eventHub {
                    Button {
                        userHub = false
                        eventHub = false
                        newFlyer = false
                    } label: {
                        Image(systemName: "newspaper.circle")
                            .foregroundColor(.primary)
                    }
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.primary)
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus.square")
                            .foregroundColor(.primary)
                    }
                    Button {
                        userHub = true
                        eventHub = false
                        newFlyer = false
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.primary)
                    }
                }
                else {
                    Image(systemName: "newspaper.circle.fill")
                        .foregroundColor(.primary)
                    Button {
                        newFlyer = false
                        userHub = false
                        eventHub = true
                    } label: {
                        Image(systemName: "calendar.circle")
                            .foregroundColor(.primary)
                    }
                    Button {
                        newFlyer = true
                    } label: {
                        Image(systemName: "plus.square")
                            .foregroundColor(.primary)
                    }
                    Button {
                        userHub = true
                        newFlyer = false
                        eventHub = false
                    } label: {
                        Image(systemName: "magnifyingglass.circle")
                            .foregroundColor(.primary)
                    }
                }
            }.font(.system(size: 40))
                .padding(.horizontal,8)
                .padding(.vertical,5)
                .background(.ultraThickMaterial)
                .cornerRadius(20)
        }.animation(.easeIn, value: newFlyer)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
