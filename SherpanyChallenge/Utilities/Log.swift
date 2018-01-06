//
//  Log.swift
//  SherpanyChallenge
//
//  Created by Mikolaj Kalinowski on 06/01/2018.
//  Copyright © 2018 Higher Order. All rights reserved.
//

import Foundation
import os

func log(_ message: CustomStringConvertible,
         type: OSLogType = .debug,
         filename: String = #file,
         line: Int = #line,
         function: String = #function) {
    print("\((filename as NSString).lastPathComponent):\(line) \(function):\r\(message)\n")
}
