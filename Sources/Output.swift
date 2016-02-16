//
//  Output.swift
//  vapor-installer
//
//  Created by Matthew on 13/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

public typealias Formatting = [FormatType]

public protocol FormatType {
    var rawValue: Int { get }
}

public enum Text: Int, FormatType {
    case Bold = 1, Dim = 2, Underlined = 4, Blink = 5, Reverse = 7, Hidden = 8
}

public enum Reset: Int, FormatType {
    case All = 0, Bold = 21, Dim = 22, Underlined = 24, Blink = 25, Reverse = 27, Hidden = 28
}

public enum Color: Int, FormatType {
    case Default = 39, Black = 30, Red = 31, Green = 32, Yellow = 33, Blue = 34, Magenta = 35,
    Cyan = 36, LightGray = 37, DarkGray = 90, LightRed = 91, LightGreen = 92,
    LightYellow = 93, LightBlue = 94, LightMagenta = 95, LightCyan = 96, White = 97
}

public enum Background: Int, FormatType {
    case Default = 49, Black = 40, Red = 41, Green = 42, Yellow = 43, Blue = 44, Magenta = 45,
    Cyan = 46, LightGray = 47, DarkGray = 100, LightRed = 101, LightGreen = 102,
    LightYellow = 103, LightBlue = 104, LightMagenta = 105, LightCyan = 106, White = 107
}

public enum AlertType {
    case Info(String), Success(String), Warning(String), Error(String)
    var string: String {
        switch self {
        case Info(let text): return text
        case Success(let text): return text
        case Warning(let text): return text
        case Error(let text): return text
        }
    }
}

public protocol OutputFormatConfiguration {
    
    var infoFormatting: Formatting { get }
    var successFormatting: Formatting { get }
    var warningFormatting: Formatting { get }
    var errorFormatting: Formatting { get }
    var textFormatting: Formatting { get }
}

public struct Output {

    private let infoFormatting: Formatting
    private let successFormatting: Formatting
    private let warningFormatting: Formatting
    private let errorFormatting: Formatting
    private let textFormatting: Formatting
    
    init(config: OutputFormatConfiguration? = nil) {
        infoFormatting = config?.infoFormatting ?? [Background.Blue, Color.White]
        successFormatting = config?.successFormatting ?? [Background.Green, Color.White]
        warningFormatting = config?.warningFormatting ?? [Background.Yellow, Color.White]
        errorFormatting = config?.errorFormatting ?? [Background.Red, Color.White]
        textFormatting = config?.textFormatting ?? [Color.Default]
    }
}

extension Output {
    
    func alert(type: AlertType) {
        let formatting = formattingForAlert(type)
        
        print(formatOutput(type.string, formats: formatting))
    }
    
    func text(string: String, formats: Formatting? = nil, newLine: Bool = true) {
        let formatting = formats ?? textFormatting
        let output = formatOutput(string, formats: formatting)
        
        if newLine {
            print(output)
        }
        else {
            print(output, terminator: "")
        }
    }
    
    func line() {
        print("")
    }
}

//MARK :- Private methods

extension Output {
    
    private func formattingForAlert(type: AlertType) -> Formatting {
        switch type {
        case .Info: return infoFormatting
        case .Success: return successFormatting
        case .Warning: return warningFormatting
        case .Error: return errorFormatting
        }
    }

    private func stringWithPadding(string: String) -> String {
        return "\n\n " + string + "\n"
    }
    
    private func formatOutput(string: String, formats: [FormatType]) -> String {
        
        let codes = formats
            .map { "\($0.rawValue)" }
            .joinWithSeparator(";")
        
        return"\u{001B}[0;\(codes)m\(string)\u{001B}[0m"
        
    }
}
