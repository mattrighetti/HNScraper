//
//  Scanner+ScanBetweenString.swift
//  HNScraper
//
//  Created by Stéphane Sercu on 29/09/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import Foundation
extension Scanner {
    func scanBetweenString(stringA: String, stringB: String, into: inout String?) {
        _ = self.scanUpToString(stringA)
        _ = self.scanString(stringA)
        into = self.scanUpToString(stringB)
    }
}
