//
//  ContentView.swift
//  LifeGameApp (macOS)
//
//  Created by Yusuke Hosonuma on 2020/08/07.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MainGameViewModel
    @EnvironmentObject var setting: SettingEnvironment

    var zoomLevel: Int

    private var cellWidth: CGFloat {
        CGFloat(20 + (zoomLevel - 5) * 2)
    }

    var body: some View {
        NavigationView {
            ZStack {
                BoardView(board: viewModel.board,
                          cellWidth: cellWidth,
                          cellPadding: 1,
                          lightModeCellColor: setting.lightModeColor,
                          darkModeCellColor: setting.darkModeColor,
                          tapCell: viewModel.tapCell)
                VStack {
                    Spacer()
                    HStack {
                        Text("Generation: \(viewModel.board.generation)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .padding()
            }
            PresetListView()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
