//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct ControlView: View {
    @EnvironmentObject var boardRepository: FirestoreBoardRepository
    @EnvironmentObject var historyRepository: FirestoreHistoryRepository

    // TODO:
    // 以下の問題に対する暫定対処（beta4）❗
    // https://qiita.com/usk2000/items/1f8038dedf633a31dd78
    @EnvironmentObject var setting: SettingEnvironment
    @EnvironmentObject var authentication: Authentication
    @EnvironmentObject var boardStore: BoardStore
    @EnvironmentObject var network: NetworkMonitor

    @ObservedObject var viewModel: MainGameViewModel
    
    @State var isPresentedListSheet = false
    
    // MARK: View
    
    var body: some View {
        HStack {
            // TODO: やっつけなのであとでリファクタ
            if !viewModel.playButtonDisabled {
                Button(action: viewModel.tapPlayButton) {
                    Image(systemName: "play.fill")
                }
                .disabled(viewModel.playButtonDisabled)
            } else {
                Button(action: viewModel.tapStopButton) {
                    Image(systemName: "stop.fill")
                }
                .buttonStyle(ButtonStyleCircle(color: .orange))
                .disabled(viewModel.stopButtonDisabled)
            }

            Button(action: viewModel.tapNextButton) {
                Image(systemName: "arrow.right.to.line.alt")
            }
            .disabled(viewModel.nextButtonDisabled)

            Spacer()
            
            Button(action: { isPresentedListSheet.toggle() }) {
                Image(systemName: "list.bullet")
            }
            .sheet(isPresented: $isPresentedListSheet) {
                BoardSelectView(
                    isSignIn: authentication.isSignIn,
                    boardStore: boardStore,
                    isPresented: $isPresentedListSheet
                )
                .environmentObject(setting)
                .environmentObject(authentication)
                .environmentObject(network)
            }
            
            ActionMenu(viewModel: viewModel) {
                Button(action: viewModel.tapNextButton) {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .buttonStyle(ButtonStyleCircle())
    }
}

//struct ControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlView(viewModel: MainGameViewModel())
//            .previewLayout(.sizeThatFits)
//    }
//}
