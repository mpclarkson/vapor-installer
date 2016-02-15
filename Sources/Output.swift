//
//  Output.swift
//  vapor-installer
//
//  Created by Matthew on 13/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

enum OutputType: String {
    case Info, Success, Warning, Error
}

struct Output {
    
    private func printToConsole(string: String, type: OutputType) {
        switch type {
        case .Info: print("\u{001B}[0;34m\(string)\u{001B}[0m")
        case .Success: print("\u{001B}[0;32m\(string)\u{001B}[0m")
        case .Warning: print("\u{001B}[0;33m\(string)\u{001B}[0m")
        case .Error: print("\u{001B}[0;31mError: \(string)\u{001B}[0m")
        }
    }
    
    func info(string: String) {
        printToConsole(string, type: .Info)
    }
    
    func success(string: String) {
        printToConsole(string, type: .Success)
    }
    
    func error(string: String) {
        printToConsole(string, type: .Error)
    }
    
    func warning(string: String) {
        printToConsole(string, type: .Warning)
    }
    
}
