//
//  ControlView.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/02.
//

import SwiftUI

struct ControlView: View {
    @StateObject var boardRepository = FirestoreBoardRepository()
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
                BoardListView(isPresented: $isPresentedListSheet,
                              boardDocuments: boardRepository.items)
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
