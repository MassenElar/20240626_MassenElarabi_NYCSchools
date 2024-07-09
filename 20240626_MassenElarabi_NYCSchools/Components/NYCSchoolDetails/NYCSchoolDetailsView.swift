//
//  NYCSchoolDetailsView.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import SwiftUI

struct NYCSchoolDetailsView: View {
    
    // MARK: - Properties
    let viewModel: NYCSchoolDetailsViewModel
    // MARK: - Initializer
    init(viewModel: NYCSchoolDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - UI Components
    var body: some View {
        ScrollView {
            detailsCard
                .padding(20)
            Spacer()
        }
    }
    
    var detailsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.schoolName)
                .font(.largeTitle)
                .foregroundStyle(.blue)
            Divider()
            Text("Overview")
                .font(.headline)
                .foregroundStyle(.gray)
            detailText(viewModel.overview)
            Text("School Info")
                .font(.headline)
                .foregroundStyle(.gray)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    detailText("Phone Number: \(viewModel.phoneNumber)")
                    detailText("Fax Number: \(viewModel.faxNumber)")
                }
                Spacer()
                VStack(alignment: .leading) {
                    detailText("Email: \(viewModel.email)")
                    detailText("Get Direction")
                }
            }
            Text("Sat Scores")
                .font(.headline)
                .foregroundStyle(.gray)
            VStack(alignment: .leading) {
                detailText("Math Sat Score: \(viewModel.satMathScore)")
                detailText("Reading Sat Score: \(viewModel.satReadingScore)")
                detailText("Writing Sat Score: \(viewModel.satWritingScore)")
            }
        }
    }
    
    func detailText(_ text: String) -> some View {
        Text(text)
            .font(.body)
    }
}

#Preview {
    NYCSchoolDetailsView(viewModel: NYCSchoolDetailsViewModel(model: NYCSchoolDetailsModel()))
}
