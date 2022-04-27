//
//  GameManager.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/24.
//

import SwiftUI
import LifeGame
import Combine
import Core

private let BaseInterval = 0.05

extension GameManager {
    enum State {
        case stop
        case play
        case pause
        
        var canPlay: Bool { self == .stop }
        var canStop: Bool { self == .play }
        var canNext: Bool { self == .stop }
    }
}

final class GameManager: ObservableObject {
    static let shared = GameManager()

    @Published var isPlaying: Bool = false
    @Published var speed: Double = 0.5
    @Published var scale: CGFloat = 1.0
    @Published var state: State = .stop

    private let boardManager: BoardManager = .shared
    private let setting: SettingEnvironment = .shared
    private let patternService: PatternService = .shared
    private var timerPublisher: Cancellable?

    init() {
        setting.$animationSpeed.assign(to: &$speed)
    }
    
    func next() {
        boardManager.next()
    }
    
    func play() {
        state = .play
        startAnimation()
    }
    
    func stop() {
        state = .stop
        stopAnimation()
    }
    
    func clear() {
        boardManager.clear()
    }
    
    func generateRandom() {
        boardManager.generateRandom()
    }
    
    func setBoard(_ board: Board<Cell>) {
        boardManager.setBoard(board: board)
    }
    
    func speedChanged(_ ediging: Bool) {
        if ediging {
            if state == .play {
                stopAnimation()
                state = .pause
            }
        } else {
            if state == .pause {
                startAnimation()
                state = .play
            }
            setting.animationSpeed = speed
        }
    }
    
    func setPattern(_ item: PatternItem) {
        self.patternService.recordHistory(patternID: item.patternID)
        self.setBoard(item.board)
    }
    
    func setPattern(from patternURL: URL) -> AnyPublisher<(), Never> {
        patternService.fetch(from: patternURL)
            .compactMap { $0 }
            .map(setPattern)
            .eraseToAnyPublisher()
    }
    
    // MARK: Private
    
    private func startAnimation() {
        let interval = BaseInterval + (1.0 - speed) * 0.8
        timerPublisher = Timer.TimerPublisher(interval: interval, runLoop: .current, mode: .common)
            .autoconnect()
            .sink { _ in
                BoardManager.shared.next()
            }
        isPlaying = true
    }
    
    private func stopAnimation() {
        timerPublisher?.cancel()
        isPlaying = false
    }
}
