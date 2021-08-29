//
//  Unique.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 28/08/2021.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
