//
//  GameManager.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/15.
//

import SwiftUI
import LifeGame
import Combine
import os

enum AnimationState {
    case inProgress
    case paused
    case stoped
}

final class ContentViewModel: ObservableObject {
    @Published var board: LifeGameBoard = .init(size: 13)
    @Published var animationState: AnimationState = .stoped
    @Published var speed = 0.5
    @Published var playButtonDisabled: Bool = true
    @Published var stopButtonDisabled: Bool = true
    @Published var nextButtonDisabled: Bool = true

    init() {
        $animationState
            .sink { state in
                self.playButtonDisabled = state != .stoped
                self.stopButtonDisabled = state != .inProgress
                self.nextButtonDisabled = state != .stoped
            }
            .store(in: &_cancellables)
    }
    
    // MARK: - Private
    
    private let BaseInterval = 0.05
    private let _logger = Logger(subsystem: "tech.penginmura.LifeGameApp", category: "ContentViewModel")
    private var _timerPublisher: Cancellable?
    private var _cancellables: [AnyCancellable] = []
    
    // MARK: - Actions
    
    func tapCell(x: Int, y: Int) {
        board.toggle(x: x, y: y)
    }
    
    func tapPlayButton() {
        startAnimation()
    }
    
    func tapStopButton() {
        stopAnimation()
    }
    
    func tapNextButton() {
        board.next()
    }
    
    func selectPreset(_ preset: BoardPreset) {
        self.board = preset.board
    }
    
    func tapClear() {
        self.board = .init(size: 13)
    }

    func onSliderChanged(_ ediging: Bool) {
        if ediging && animationState == .inProgress {
            pauseAnimation()
        } else {
            if animationState == .paused {
                startAnimation()
            }
        }
    }
    
    // MARK: - Private
    
    private func startAnimation() {
        _logger.notice("Animation: Start - speed: \(self.speed, format: .fixed(precision: 3))")
        
        let interval = BaseInterval + (1.0 - self.speed) * 0.8
        _timerPublisher = Timer.TimerPublisher(interval: interval, runLoop: .main, mode: .default)
            .autoconnect()
            .sink { _ in
                self.board.next()
            }
        animationState = .inProgress
    }

    private func stopAnimation() {
        _logger.notice("Animation: Stop")

        _timerPublisher?.cancel()
        animationState = .stoped
    }
    
    private func pauseAnimation() {
        _logger.notice("Animation: Pause")
        
        _timerPublisher?.cancel()
        animationState = .paused
    }
}
