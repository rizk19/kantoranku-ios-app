//
//  GradientView.swift
//  Kantoranku
//
//  Created by Rizki Faris on 25/07/22.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        LinearGradient(
            colors: [.cyan, .green, .blue],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
