//
//  NYCSchoolViewModelTests.swift
//  20240626_MassenElarabi_NYCSchoolsTests
//
//  Created by Massen Elarabi on 7/8/24.
//

import XCTest
import Combine
@testable import _0240626_MassenElarabi_NYCSchools


final class NYCSchoolViewModelTests: XCTestCase {
   
    
    var sut: NYCSchoolsViewModel!

    override func setUp() {
        super.setUp()
        sut = NYCSchoolsViewModel(webService: MockSuccessWebService())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchSchoolsSuccess() {
        sut.fetchSchoolsList()
        XCTAssertNotNil(sut.schoolsList)
        XCTAssertEqual(sut.schoolsList.count, 2)
        XCTAssertEqual(sut.schoolsList.first?.dbn, "111")
        XCTAssertEqual(sut.schoolsList[1].dbn, "222")
    }
    
    func testFetchSatScoresSuccess() {
        sut.fetchSchoolsList()
        XCTAssertNotNil(sut.schoolSatDetails)
        XCTAssertEqual(sut.schoolSatDetails.count, 3)
        XCTAssertEqual(sut.schoolSatDetails.first?.dbn, "111")
        XCTAssertEqual(sut.schoolSatDetails[1].dbn, "222")
    }
    
    func testProcessSchoolDetails() {
        sut.fetchSchoolsList()
        XCTAssertNotNil(sut.schoolDetails)
        XCTAssertEqual(sut.schoolDetails.count, 2)
        XCTAssertEqual(sut.schoolDetails.first?.dbn, "111")
        XCTAssertEqual(sut.schoolDetails[1].dbn, "222")
    }
    
    func testFetchSatScoresFailure() {
        sut = NYCSchoolsViewModel(webService: MockFailureWebService())
        sut.fetchSatScores()
        XCTAssertEqual(sut.schoolsList.count, 0)
        XCTAssertTrue(sut.errorPresented)
    }
    
    func testFetchSchoolsFailure() {
        sut = NYCSchoolsViewModel(webService: MockFailureWebService())
        sut.fetchSchoolsList()
        XCTAssertEqual(sut.schoolSatDetails.count, 0)
        XCTAssertTrue(sut.errorPresented)
    }
}
