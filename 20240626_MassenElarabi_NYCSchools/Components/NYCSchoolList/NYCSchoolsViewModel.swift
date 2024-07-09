//
//  NYCSchoolsViewModel.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import Foundation
import Combine

class NYCSchoolsViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var schoolsList: [NYCSchoolsModel] = []
    @Published var schoolSatDetails: [NYCSchoolSatModel] = []
    @Published var selectedSchool: NYCSchoolDetailsModel?
    var schoolDetails: [NYCSchoolDetailsModel] = []
    var errorPresented: Bool = false
    private let webService: NYCSchoolsWebServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let NYCSchoolsUrlString: String = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    let NYCSchoolsSatDetails: String = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
    
    // MARK: - Initializer
    init(webService: NYCSchoolsWebServiceProtocol = NYCSchoolsWebService()) {
        self.webService = webService
    }
    
    // MARK: - functions
    
    /// Fetch NYC schools
    func fetchSchoolsList() {
        webService.fetchNYCSchools(urlString: NYCSchoolsUrlString)
            .mapError { [weak self] (error) -> Error in
                print(error.localizedDescription)
                self?.errorPresented = true
                return error
            }
            .sink { _ in
                // Blank Closure - reason: publisher-sink closure to execute on completion
            } receiveValue: { [weak self] schoolsData in
                guard let self = self else { return }
                self.schoolsList = schoolsData
                self.fetchSatScores()
            }
            .store(in: &cancellables)
    }
    
    /// Fetch NYC schools sat scores
    func fetchSatScores() {
        webService.fetchSchoolSatDetails(urlString: NYCSchoolsSatDetails)
            .mapError { [weak self] (error) -> Error in
                print(error.localizedDescription)
                self?.errorPresented = true
                return error
            }
            .sink { _ in
                // Blank Closure - reason: publisher-sink closure to execute on completion
            } receiveValue: { [weak self] satData in
                guard let self = self else { return }
                self.schoolSatDetails = satData
                self.processSchoolDetails(schoolModel: schoolsList, schoolsSatModel: schoolSatDetails)
            }
            .store(in: &cancellables)
    }
    
    /// create dictionary of schools sat details
    
    func processSchoolDetails(schoolModel: [NYCSchoolsModel],
                              schoolsSatModel: [NYCSchoolSatModel]) {
        for school in schoolModel {
            if let schoolSat = schoolsSatModel.filter({ $0.dbn == school.dbn }).first {
                let details = NYCSchoolDetailsModel(dbn: school.dbn,
                                                    schoolName: school.schoolName,
                                                    overview: school.overviewParagraph,
                                                    email: school.schoolEmail,
                                                    phoneNumber: school.phoneNumber,
                                                    faxNumber: school.faxNumber,
                                                    location: school.location,
                                                    satReadingScore: schoolSat.satReadingScore,
                                                    satMathScore: schoolSat.satMathScore,
                                                    satWritingScore: schoolSat.satWritingScore)
                schoolDetails.append(details)
            }
        }
    }
}
