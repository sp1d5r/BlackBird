//
//  Placeholder.swift
//  Blackbird
//
//  Created by Almaz Ahmad on 25/08/2021.
//

import Foundation
import SwiftUI

public struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder).fontWeight(.medium)
                    .padding(.horizontal, 15).foregroundColor(.white)
            }
            content
            .foregroundColor(Color.white)
            .padding(5.0)
        }
    }
}
