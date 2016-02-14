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
    case .Success: output.success("Project created successfully!")
    case .Error: output.error(result.message!)
    }

}
catch {

    if let error = error as? CommandError {
       output.error(error.message)
    }
    else {
       output.error("Something went wrong.")
    }
}


