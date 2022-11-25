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
    @State private var addMe = false
    @State private var addEvent = ""
    
    @FocusState private var searchFocus: Bool
    
    @StateObject var eventManager = EventsManager()
    var body: some View {
        ZStack {
            Color("main").ignoresSafeArea()
            VStack {
                HStack {
                    Text("Upcoming Events").font(.title2.weight(.medium)).padding(.leading)
                    Spacer()
//                    Button {
//                        bar.toggle()
//                    } label: {
//                        if !bar {
//                            Image(systemName: "magnifyingglass")
//                                .font(.title3)
//                        }
//                        else {
//                            Text("Close")
//                                .font(.title3)
//                        }
//                    }.tint(.primary)
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
                    }.padding(5).background(.secondary)
                        .cornerRadius(20)
                        .font(.title3)
                        .frame(maxWidth: 400)
                }
                Divider()
                ScrollView {
                    ForEach(eventManager.events,id: \.id) {event in
                        if event.date > Date() {
                            HStack {
                                EventBubble(event: event)
                                Spacer()
                                Button {
                                    addEvent = event.id
                                    addMe = true
                                } label: {
                                    Image(systemName: "plus")
                                }.tint(.primary).fontWeight(.bold)
                                    .confirmationDialog("Are you sure you want to add \(getEvent(eventID: addEvent).title) to your calendar?", isPresented: $addMe, titleVisibility: .visible) {
                                        Button("Add Event") {
                                            addCalendar(eventCal: getEvent(eventID: addEvent))
                                        }
                                    }
                            }.frame(maxWidth: 360).padding(.top)
                        }
                    }
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    searchFocus = false
                }.tint(.blue)
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
    
    func getEvent(eventID:String) -> Event {
        for event in eventManager.events {
            if event.id == eventID {
                return event
            }
        }
        
        return Event(id: "ql0WXSB04YSsrD8bBIM3", title: "Football Game", location: "AT&T Stadium", date: Date(), end: Date().addingTimeInterval(1000))
    }
}

struct EventFeed_Previews: PreviewProvider {
    static var previews: some View {
        EventFeed()
    }
}
