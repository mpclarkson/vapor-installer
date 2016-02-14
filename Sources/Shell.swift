//
//  Shell.swift
//  vapor-installer
//
//  Created by Matthew on 13/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

typealias BashOutput = Int32

struct Shell {
    
    static func exec(args: String...) -> BashOutput {
        
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        
        task.launch()
        task.waitUntilExit()

        return task.terminationStatus
    }
}

