//
//  Platform.swift
//  CrowdCount
//
//  Created by Dimitri Roche on 7/23/18.
//  Copyright © 2018 Dimitri Roche. All rights reserved.
//

public struct Platform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}
