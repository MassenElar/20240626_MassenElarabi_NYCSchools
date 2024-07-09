//
//  NYCSchoolsModel.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import Foundation

struct NYCSchoolsModel: Decodable {
    
    var dbn: String
    var schoolName: String
    var overviewParagraph: String
    var location: String
    var phoneNumber: String
    var faxNumber: String?
    var schoolEmail: String?
    var website: String
    
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case overviewParagraph = "overview_paragraph"
        case location
        case phoneNumber = "phone_number"
        case faxNumber = "fax_number"
        case schoolEmail = "school_email"
        case website
    }
}

struct NYCSchoolSatModel: Decodable {
    
    var dbn: String
    var schoolName: String
    var satReadingScore: String
    var satMathScore: String
    var satWritingScore: String
    
    // MARK: - Coding keys
    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case satReadingScore = "sat_critical_reading_avg_score"
        case satMathScore = "sat_math_avg_score"
        case satWritingScore = "sat_writing_avg_score"
    }
}
