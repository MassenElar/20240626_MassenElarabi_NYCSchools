//
//  MockWebService.swift
//  20240626_MassenElarabi_NYCSchoolsTests
//
//  Created by Massen Elarabi on 7/8/24.
//

import Foundation
import Combine
@testable import _0240626_MassenElarabi_NYCSchools

extension NYCSchoolsModel {
    static func build() -> [NYCSchoolsModel] {
        let school1 = NYCSchoolsModel(dbn: "111",
                                      schoolName: "School1",
                                      overviewParagraph: "text",
                                      location: "loacation1",
                                      phoneNumber: "1122334455",
                                      website: "www.test1.com")
        let school2 = NYCSchoolsModel(dbn: "222",
                                      schoolName: "School2",
                                      overviewParagraph: "text",
                                      location: "loacation2",
                                      phoneNumber: "1122334455",
                                      website: "www.test2.com")
        return [school1, school2]
    }
}

extension NYCSchoolSatModel {
    static func build() -> [NYCSchoolSatModel] {
        let school1 = NYCSchoolSatModel(dbn: "111",
                                        schoolName: "School1",
                                        satReadingScore: "400",
                                        satMathScore: "300",
                                        satWritingScore: "400")
        let school2 = NYCSchoolSatModel(dbn: "222",
                                        schoolName: "School2",
                                        satReadingScore: "400",
                                        satMathScore: "300",
                                        satWritingScore: "400")
        let school3 = NYCSchoolSatModel(dbn: "333",
                                        schoolName: "School3",
                                        satReadingScore: "400",
                                        satMathScore: "300",
                                        satWritingScore: "400")
        return [school1, school2, school3]
    }
}

struct MockSuccessWebService: NYCSchoolsWebServiceProtocol {
    
    func fetchNYCSchools(urlString: String) -> AnyPublisher<[NYCSchoolsModel], Error> {
        return AnyPublisher(Just(NYCSchoolsModel.build()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchSchoolSatDetails(urlString: String) -> AnyPublisher<[NYCSchoolSatModel], Error> {
        return AnyPublisher(Just(NYCSchoolSatModel.build()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
}

struct MockFailureWebService: NYCSchoolsWebServiceProtocol {
    func fetchNYCSchools(urlString: String) -> AnyPublisher<[_0240626_MassenElarabi_NYCSchools.NYCSchoolsModel], Error> {
        return Fail(error: APIError.httpStatusCode(400)).eraseToAnyPublisher()
    }
    
    func fetchSchoolSatDetails(urlString: String) -> AnyPublisher<[_0240626_MassenElarabi_NYCSchools.NYCSchoolSatModel], Error> {
        return Fail(error: APIError.httpStatusCode(400)).eraseToAnyPublisher()
    }
}
