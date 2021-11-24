//
//  HealthStat.swift
//  Fit Vein
//
//  Created by Łukasz Janiszewski on 24/11/2021.
//

import Foundation
import HealthKit

struct HealthStat: Identifiable {
    let id = UUID()
    let stat: HKQuantity?
    let date: Date
}
