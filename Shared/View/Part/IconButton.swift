//
//  IconButton.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI

struct IconButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(systemName: "play.fill", action: {})
    }
}
