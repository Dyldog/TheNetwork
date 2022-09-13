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
                ForEach(viewModel.data) { person in
                    NavigationLink {
                        person.detailView()
                    } label: {
                        viewModel.display(person)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            
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
