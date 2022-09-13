//
//  NetworkApp.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import SwiftUI
import Combine

@main
struct NetworkApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    ListView(
                        viewModel: EasyListViewModel<WDEntity, VStack>(
                            title: "WIKI",
                            dataFactory: { WDAPI.search(for: "Australia") },
                            display: { value in
                                VStack(alignment: .leading) {
                                    Text(value.title)
                                    if let value = value.descriptions.en?.value {
                                        Text(value)
                                    }
                                }
                            }
                        ).apiSearch {
                            WDAPI.search(for: $0)
                        }
                    )
                }
                .tabItem { Label("WikiData", systemImage: "globe") }
            
//                NavigationView {
//                    ListView(viewModel: EasyListViewModel<SWPerson>(path: "people"))
//                }
//                .tabItem { Label("People", systemImage: "person") }
//
                NavigationView {
                    ListView(viewModel: SWAPIListViewModel<SWFilm>(path: "films"))
                }
                .tabItem { Label("Star Wars", systemImage: "film") }
//
//                NavigationView {
//                    ListView(viewModel: EasyListViewModel<SWPlanet>(path: "planets"))
//                }
//                .tabItem { Label("Planets", systemImage: "globe.asia.australia") }
//
//                NavigationView {
//                    ListView(viewModel: EasyListViewModel<SWStarship>(path: "starships"))
//                }
//                .tabItem { Label("Starships", systemImage: "airplane.departure") }
//
//                NavigationView {
//                    ListView(viewModel: EasyListViewModel<SWVehicle>(path: "vehicles"))
//                }
//                .tabItem { Label("Vehicles", systemImage: "car") }
//
//                NavigationView {
//                    ListView(viewModel: EasyListViewModel<SWSpecies>(path: "species"))
//                }
//                .tabItem { Label("Species", systemImage: "pawprint.fill") }
            }
        }
    }
}
