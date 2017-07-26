//
//  Assessments.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import UIKit

let librarianSuccess = NSLocalizedString("Ahh . . . that librarian *does* seem suspicious! What kind of name is \"Mr. Nefarian\" anyway? It sounds like it came from a video game. It *must* be him! You walk to the reference desk.\n\n[Next Page](@next)", comment:"Solution for Look to N")
let novelsSuccess = NSLocalizedString("Hmm . . . nothing looks unusual here—there are just a lot of glossy covers and expensive-looking magazines. Better try somewhere else.", comment:"Novels message")
let newspapersSuccess = NSLocalizedString("You don't find anything mysterious in the pile of newspapers on the table—just a sticky candy wrapper. Better try somewhere else.", comment:"Newspapers message")

public func assessmentPoint(investigationType: InvestigationType) -> PlaygroundPage.AssessmentStatus {
    
    var successMessage = ""
    
    switch investigationType {
    case .librarian:
        successMessage = librarianSuccess
    case .novels:
        successMessage = novelsSuccess
    case .newspapers:
        successMessage = newspapersSuccess
    }
    
    return .pass(message: successMessage)
}
