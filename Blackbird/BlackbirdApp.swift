//
//  BlackbirdApp.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 24/08/2021.
//

import SwiftUI

@main
struct BlackbirdApp: App {
    init() {
            UITableView.appearance().backgroundColor = .clear
        }

    var body: some Scene {
        WindowGroup {
            BackgroundStack()
        }
    }
}
