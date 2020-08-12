//
//  BoardSelectDisplayStyleController.swift
//  LifeGameApp (iOS)
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

import Combine

final class BoardSelectDisplayStyleController: ObservableObject {
    @Published var isGrid = true
    @Published var isList = false
    @Published private(set) var currentStyle: BoardSelectStyle = .grid
    
    private var setting: SettingEnvironment?
    private var cancellables: [AnyCancellable] = []
    
    init() {
        // Note:
        // Grid / List が排他的になるように制御する。
        $isGrid
            .filter { $0 }
            .sink { [weak self] _ in
                self?.isList = false
                self?.currentStyle = .grid
            }
            .store(in: &cancellables)
        $isList
            .filter { $0 }
            .sink { [weak self] _ in
                self?.isGrid = false
                self?.currentStyle = .list
            }
            .store(in: &cancellables)
    }
    
    func inject(setting: SettingEnvironment) {
        guard self.setting == nil else { return }
        self.setting = setting
        
        switch setting.boardSelectDisplayStyle {
        case .grid: self.isGrid = true
        case .list: self.isList = true
        }
        
        $currentStyle
            .assign(to: \.boardSelectDisplayStyle, on: setting)
            .store(in: &cancellables)
    }
}
