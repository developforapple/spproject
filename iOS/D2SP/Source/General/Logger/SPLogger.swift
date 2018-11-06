//
//  SPLogger.swift
//  D2SP
//
//  Created by bo wang on 2018/11/5.
//  Copyright © 2018 wwwbbat. All rights reserved.
//

import Foundation
import CocoaLumberjack

@objc class SPLogger: NSObject {

    @objc static let logger = SPLogger.init()

    private override init() {
        self.logFormatter = SPLogFormatter.init()
        self.loggerQueue = DispatchQueue.init(label: "SP")
    }

    @objc func setup() {
        let fileLogger = DDFileLogger.init()!
        fileLogger.rollingFrequency = 60 * 60 * 24 * 5
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)

        DDLog.add(self)
    }

    var logFormatter: DDLogFormatter
    var loggerQueue: DispatchQueue
}

extension SPLogger: DDLogger {


    func log(message logMessage: DDLogMessage) {

    }

    func didAdd() {

    }

    func didAdd(in queue: DispatchQueue) {

    }

    func willRemove() {

    }

    func flush() {

    }
}

class SPLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        return nil
    }
}
