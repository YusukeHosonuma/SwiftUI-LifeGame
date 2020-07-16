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
    case stop
}

class GameManager: ObservableObject {
    private static let baseInterval = 0.05

    var logger = Logger(subsystem: "com.example", category: "GameManager")
    
    @Published var board = Board(size: 13)
    @Published var animationState: AnimationState = .stop
    @Published var speed = 0.5
    
    private var timerPublisher: Cancellable?
    
    func startAnimation() {
        logger.debug(#function)
        logger.debug("\(self.speed, format: .fixed(precision: 3))")
        
        OSLog(subsystem: "foo", category: "eigjdk")
        os_log("")
        
        let interval = Self.baseInterval + (1.0 - self.speed) * 0.8
        timerPublisher = Timer.TimerPublisher(interval: interval, runLoop: .main, mode: .default)
            .autoconnect()
            .sink { _ in
                self.board.next()
            }
        animationState = .inProgress
    }
    
    func pauseAnimation() {
        logger.debug(#function)

        timerPublisher?.cancel()
        animationState = .paused
    }
    
    func stopAnimation() {
        logger.debug(#function)

        timerPublisher?.cancel()
        animationState = .stop
    }
    
    func stepNext() {
        board.next()
    }
    
    func applyPreset(_ preset: BoardPreset) {
        self.board = preset.board
    }
    
    func clear() {
        self.board = Board(size: 13)
    }
}
