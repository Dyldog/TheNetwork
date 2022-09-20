//
//  DetailInfoSection.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import Foundation
import SwiftUI
import WKView

struct DetailInfoSection: View {
    let properties: [(DisplayableDetail, DisplayableDetail)]
    
    @State var showDisplayable: String?
    
    @State var actionSheetElement: (DisplayableDetail, DisplayableDetail)? { didSet { showActionSheet = true }}
    @State var showActionSheet: Bool = false
    
    @State var listViewModel: EasyListViewModel<WDEntity, Text>? { didSet { showList = true } }
    @State var showList: Bool = false
    
    @State var urlToShow: String? { didSet { showWebview = true } }
    @State var showWebview: Bool = false
    
    

    
    var body: some View {
        Section {
            ForEach(Array(properties.enumerated()), id: \.offset) { offset, element in
                HStack {
                    titleView(for: element.0)
                    valueView(forTitle: element.0, and: element.1)
                    
                    Spacer()
                    
                    Button {
                        print("Tapped \(element.0.id ?? "NOID") \(element.1.id ?? "NOID")")
                        actionSheetElement = element
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .confirmationDialog("Drill Down", isPresented: $showActionSheet, presenting: actionSheetElement) { element in
                if let property = element.0.id {
                    Button("\(property) = *") {
                        listViewModel = EasyListViewModel(
                            title: "\(element.0.text ?? property)",
                            dataFactory: { WDAPI.otherExamples(of: property) }
                        )
                    }
                }
                
                if let value = element.1.id {
                    Button("* = \(value)") {
                        listViewModel = EasyListViewModel(
                            title: "\(element.1.text ?? value)",
                            dataFactory: { WDAPI.otherExamples(equalTo: value) }
                        )
                    }
                }

                if let property = element.0.id, let value = element.1.id {
                    Button("\(property) = \(value)") {
                        listViewModel = EasyListViewModel(
                            title: "\(element.0.text ?? property): \(element.1.text ?? value)",
                            dataFactory: { WDAPI.otherExamples(of: property, equalTo: value) }
                        )
                    }
                }
            }
        }.background(NavigationLink(
            isActive: $showList,
            destination: {
                if let listViewModel = listViewModel {
                    ListView(viewModel: listViewModel)
                } else {
                    Text("Errror")
                }
            },
            label: { EmptyView() }
        ).hidden())
        .background(NavigationLink(
            isActive: $showWebview,
            destination: {
                if let urlToShow = urlToShow {
                    WebView(url: urlToShow)
                } else {
                    Text("Errror")
                }
            },
            label: { EmptyView() }
        ).hidden())
    }
    
    private func titleView(for value: DisplayableDetail) -> AnyView {
        switch value {
        case let .string(string):
            return AnyView(Text(string))
        case .loading:
            return AnyView(ProgressView().padding(.leading))
        case let .displayable(displayable):
            return AnyView(
                Button(displayable.title, action: {
                    showDisplayable = displayable.id
                })
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.blue)
                .navigation(value: displayable.id, binding: $showDisplayable, linked: { displayable.detailView() }))
        }
    }
    
    private func valueView(forTitle titleValue: DisplayableDetail, and valueValue: DisplayableDetail) -> AnyView {
        guard
            let format = titleValue.values(forProperty: .formatterURL).first?.stringValue,
            let valueID = valueValue.text
        else { return titleView(for: valueValue) }
        return AnyView(Button(valueID, action: {
            urlToShow = format.replacingOccurrences(of: "$1", with: valueID.urlSanitised)
        }))
    }
}

//extension View {
//    func navigating<T>(for value: Binding<T>, destination: )
//}
