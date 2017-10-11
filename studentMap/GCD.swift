//
//  GCD.swift
//  studentMap
//
//  Created by Vidya Durvasula on 10/1/17.
//  Copyright © 2017 Vidya Durvasula. All rights reserved.
//

import Foundation
func performUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
