//
//  EventFeed.swift
//  FlyerFinal
//
//  Created by Matthew Rice on 11/23/22.
//

import SwiftUI
import EventKit
import FirebaseFirestore

struct EventFeed: View {
    @Binding var darkMode: Bool
    
    @State private var search = ""
    @State private var bar = false
    @State private var addMe = false
    @State private var addEvent = ""
    
    @State private var settings = false
    @State private var admin = false
    @State private var deleting = false
    
    @FocusState private var searchFocus: Bool
    
    @StateObject var eventManager = EventsManager()
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        settings.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .padding(.leading).font(.title2.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    Text("Upcoming Events").font(.title2.weight(.medium))
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
                        if event.end > Date() {
                            HStack {
                                EventBubble(event: event)
                                Spacer()
                                if admin {
                                    Button {
                                        addEvent = event.id
                                        deleting = true
                                    } label: {
                                        Image(systemName: "xmark").font(.title2.weight(.medium)).foregroundColor(.red)
                                    }.alert("Are you sure you want to delete this flyer?", isPresented: $deleting) {
                                        Button("Delete") {
                                            delete()
                                        }
                                        Button("Cancel") {
                                            deleting = false
                                        }
                                    }
                                }
                                Button {
                                    addEvent = event.id
                                    addMe = true
                                } label: {
                                    Image(systemName: "plus")
                                }.font(.title2.weight(.medium)).tint(.primary)
                                    .alert("Are you sure you want to add \(getEvent(eventID: addEvent).title) to your calendar?", isPresented: $addMe) {
                                        Button("Add Event") {
                                            addCalendar(eventCal: getEvent(eventID: addEvent))
                                        }
                                        Button("Cancel") {
                                            addMe = false
                                        }
                                    }
                            }.frame(maxWidth: 360).padding(.top)
                        }
                    }
                }
            }.animation(.easeIn, value: settings)
            if settings {
                SettingsMenu(settings: $settings, admin: $admin, darkMode: $darkMode)
                    .transition(.move(edge: .leading))
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
    
    func delete() {
        let db = Firestore.firestore()
        db.collection("events").document(addEvent).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            }
        }
    }
}

struct EventFeed_Previews: PreviewProvider {
    static var previews: some View {
        EventFeed(darkMode: .constant(false))
    }
}
