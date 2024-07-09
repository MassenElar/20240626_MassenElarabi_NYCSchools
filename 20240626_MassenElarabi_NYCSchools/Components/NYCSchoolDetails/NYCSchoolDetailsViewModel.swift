//
//  NYCSchoolDetailsViewModel.swift
//  20240626_MassenElarabi_NYCSchools
//
//  Created by Massen Elarabi on 6/26/24.
//

import Foundation

class NYCSchoolDetailsViewModel {
    
    //MARK: - Properties
    let model: NYCSchoolDetailsModel
    
    // MARK: - Initialize
    init(model: NYCSchoolDetailsModel) {
        self.model = model
    }
    
    // MARK: - computed values
    
    var schoolName: String {
        return model.schoolName ?? "N/A"
    }
   
    var overview: String {
        return model.overview ?? "N/A"
    }
    
    var email: String {
        return model.email ?? "N/A"
    }
    
    var phoneNumber: String {
        return model.phoneNumber ?? "N/A"
    }
    
    var faxNumber: String {
        return model.faxNumber ?? "N/A"
    }
    
    var location: String {
        return model.location ?? "N/A"
    }
    
    var satReadingScore: String {
        return model.satReadingScore ?? "N/A"
    }
    
    var satMathScore: String {
        return model.satMathScore ?? "N/A"
    }
    
    var satWritingScore: String {
        return model.satWritingScore ?? "N/A"
    }
    
}
