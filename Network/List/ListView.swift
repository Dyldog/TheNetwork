//
//  ContentView.swift
//  Network
//
//  Created by Dylan Elliott on 12/9/2022.
//

import SwiftUI
import Combine

struct ListView<VM: ListViewModel & ObservableObject>: View {
    @StateObject var viewModel: VM
    
    var body: some View {
        ZStack {
            List {
                Section() {
                    TextField("Search", text: $viewModel.searchText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(0)
                }
                
                Section() {
                    ForEach(viewModel.data) { person in
                        NavigationLink {
                            person.detailView()
                        } label: {
                            viewModel.display(person)
                        }
                    }
                }
            }
            
            if viewModel.loading {
                ProgressView()
            }
        }
        .navigationTitle(viewModel.title)
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: SWAPIListViewModel<SWPerson>(path: "people"))
    }
}
