//
//  NYCSchoolsView.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import SwiftUI

struct NYCSchoolsView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: NYCSchoolsViewModel
    @State var isActive: Bool = false
    
    // MARK: - Initializer
    init(viewModel: NYCSchoolsViewModel = NYCSchoolsViewModel()) {
        self.viewModel = viewModel
        self.viewModel.fetchSchoolsList()
    }
    
    // MARK: - UI Components
    var body: some View {
        VStack(spacing: 0) {
            Text("NYC School List")
                .font(.largeTitle)
                .padding()
            Divider()
            schoolList
        }
    }
    
    var schoolList: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.schoolDetails, id: \.dbn) { school in
                    schoolRow(schoolName: school.schoolName ?? "N/A")
                        .onTapGesture {
                            viewModel.selectedSchool = school
                            self.isActive.toggle()
                        }
                }
            }
            .padding()
            .background(
                NavigationLink(destination: detailsView,
                               isActive: $isActive) {
                    // blank closure
                }
            )
        }
    }
    
    @ViewBuilder
    var detailsView: some View {
        if let schoolDetails = viewModel.selectedSchool {
            NYCSchoolDetailsView(viewModel: NYCSchoolDetailsViewModel(model: schoolDetails))
        }
    }
    
    func schoolRow(schoolName: String) -> some View {
        VStack {
            Text(schoolName)
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.black, lineWidth: 1)
                .shadow(color: .black, radius: 8)
        )
    }
}

#Preview {
    NYCSchoolsView()
}
