//
//  Installer.swift
//  vapor-installer
//
//  Created by Matthew on 13/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

private struct Constants {
    static let defaultName = "VaporApp"
    static let repositoryName = "vapor-example"
    static let defaultVersion = "master"
    static let repository = "https://github.com/tannernelson/" + Constants.repositoryName
}

enum Command: String {
    case New = "new"
}

enum CommandError: ErrorType {
    case InvalidCommand(String), InvalidNumberOfArguments(Int)
    var message: String {
        switch self {
        case InvalidCommand(let string): return "'\(string)' is not a valid command. Valid options are: 'new'"
        case InvalidNumberOfArguments: return "Incorrect number of arguments provided."
        }
    }
}

enum Result {
    case Success, Error(String)
    var message: String? {
        switch self {
        case .Error(let string): return string
        default: return nil
        }
    }
}

struct VaporCommand {
    
    private let command: Command
    private let name:String
    
    private let fileManager = NSFileManager.defaultManager()
    private let output = Output()
    
    private var path: String { return "\(fileManager.currentDirectoryPath)/\(name)" }
    private var url: NSURL { return NSURL(string: Constants.repository + ".git")! }
    
    init() throws {
        
        let count = Process.arguments.count
        if count != 3 {
            throw CommandError.InvalidNumberOfArguments(count)
        }
        
        let cmd = Process.arguments[1]
        guard let command = Command.init(rawValue: cmd) else {
            throw CommandError.InvalidCommand(cmd)
        }
        
        self.command = command
        self.name = Process.arguments[2]
    }
    
    func run() -> Result {
        switch command {
        case .New: return createNewProject()
        }
    }
}

//MARK : Create project methods

extension VaporCommand {

    private func createNewProject() -> Result {
        
        //Check if the folder already exists
        if alreadyExists() {
            return Result.Error("The folder \"\(name)\" already exists!")
        }
        
        //Create the project folder
        output.alert(.Info("Creating project \"\(name)\"..."))
        
        if !createFolder() {
            return Result.Error("The folder \"\(name)\" could not be created.")
        }
        
        //Clone the repo into the project folder
        let status = Git.clone(url, folder: path)
        
        if status != 0 {
            let _ = try? fileManager.removeItemAtPath(path)
            return Result.Error("The project could not be created.")
        }
        
        //Update project name in the associated files
        return updateFilesWithProjectName()

    }
  
    private func alreadyExists() -> Bool {
        var dir: ObjCBool = false
        
        return fileManager.fileExistsAtPath(path, isDirectory: &dir)
    }
    
    private func updateFilesWithProjectName() -> Result {
        let files = ["Package.swift", "Dockerfile", "Procfile", "Deploy/run.sh"]
        
        var err: ErrorType?
        
        files.forEach {
            do {
                let packageFileName = path + "/" + $0
                let package = try String(contentsOfFile: packageFileName)
                let updatedPackage = package.stringByReplacingOccurrencesOfString(Constants.defaultName, withString: name)
                try updatedPackage.writeToFile(packageFileName, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {
                err = error
            }
        }
        
        return err != nil ? .Error("\(err!)") : .Success
    }
    
    private func createFolder() -> Bool {
        do {
            try fileManager.createDirectoryAtPath(path, withIntermediateDirectories:true, attributes: nil)
            return true
        }
        catch {
            return false
        }
    }
}
