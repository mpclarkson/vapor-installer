//
//  Git.swift
//  vapor-installer
//
//  Created by Matthew on 13/02/2016.
//  Copyright © 2016 Matthew Clarkson. All rights reserved.
//

import Foundation

struct Git {
    
    static func clone(url: NSURL, folder: String) -> BashOutput {
        return Shell.exec("git", "clone", "\(url.absoluteString)", "\(folder)")
    }

}