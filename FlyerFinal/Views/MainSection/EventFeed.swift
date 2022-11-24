//
//  EventFeed.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/23/22.
//

import SwiftUI
import EventKit

struct EventFeed: View {
    @State private var search = ""
    @State private var bar = false
    
    @FocusState private var searchFocus: Bool
    
    @StateObject var eventManager = EventsManager()
    var body: some View {
        ZStack {
            Color("main").ignoresSafeArea()
            VStack {
                HStack {
                    Text("Upcoming Events").font(.title2.weight(.medium)).padding(.leading)
                    Spacer()
                    HStack {
                        Button {
                            bar.toggle()
                        } label: {
                            if !bar {
                                Image(systemName: "magnifyingglass").padding(8)
                                    .background(.secondary)
                                    .cornerRadius(20)
                                    .font(.title3)
                            }
                            else {
                                Text("Close").padding(8)
                                    .background(.secondary)
                                    .cornerRadius(20)
                                    .font(.title3)
                            }
                        }.tint(.primary)
                    }
                }.padding([.top,.trailing])
                if bar {
                    HStack {
                        Image(systemName: "magnifyingglass").padding(.trailing,4)
                        TextField("Serach", text: $search)
                            .focused($searchFocus)
                            .foregroundColor(.primary)
                            .textFieldStyle(.plain)
                            .placeholder(when: search.isEmpty) {
                                Text("Search")
                                    .foregroundColor(.primary)
                            }
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                    }.padding(8).background(.secondary)
                        .cornerRadius(20)
                        .font(.title3)
                        .frame(maxWidth: 400)
                }
                Divider()
                ScrollView {
                    ForEach(eventManager.events,id: \.id) {event in
                        HStack {
                            EventBubble(event: event)
                            Spacer()
                            Button {
                                addCalendar(eventCal: event)
                            } label: {
                                Image(systemName: "plus")
                            }.tint(.primary).fontWeight(.bold)
                        }.frame(maxWidth: 360).padding(.top)
                    }
                }
            }
        }
    }
    func addCalendar(eventCal:Event) {
        let eventStore : EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = eventCal.title
                event.startDate = eventCal.date
                event.endDate = eventCal.end
                event.notes = eventCal.location
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else {
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
}

struct EventFeed_Previews: PreviewProvider {
    static var previews: some View {
        EventFeed()
    }
}
