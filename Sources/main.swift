//
//  main.swift
//  vapor-installer
//
//  Created by Matthew on 12/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

let output = Output()

do {
    
    let command = try VaporCommand()
    let result = command.run()
    
    switch result {
    case .Success: output.alert(.Success("Project created successfully!"))
    case .Error: output.alert(.Error(result.message!))
    }

}
catch {

    var message = "Something went wrong."
    if let error = error as? CommandError {
       message = error.message
    }
    
    output.alert(.Error(message))
}


