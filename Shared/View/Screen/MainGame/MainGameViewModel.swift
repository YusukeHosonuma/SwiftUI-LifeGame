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

final class MainGameViewModel: ObservableObject {
    @Published var board: LifeGameBoard
    @Published var speed: Double = 0
    @Published var playButtonDisabled: Bool = true
    @Published var stopButtonDisabled: Bool = true
    @Published var nextButtonDisabled: Bool = true

    init() {
        let board = LifeGameBoard(size: 13) // TODO: refactor

        self.board = board
        _context = LifeGameContext.shared
        bind()
    }
    
    private func bind() {
        _context.board.assign(to: &$board)
        _context.speed.assign(to: &$speed)
        _context.isEnabledPlay.map { !$0 }.assign(to: &$playButtonDisabled)
        _context.isEnabledStop.map { !$0 }.assign(to: &$stopButtonDisabled)
        _context.isEnabledNext.map { !$0 }.assign(to: &$nextButtonDisabled)
        
        // TODO: これはやはり微妙感
        $speed
            .removeDuplicates()
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink(receiveValue: _context.changeSpeed)
            .store(in: &_cancellables)
        
        _context.finishConfigure()
    }
    
    // MARK: - Private

    private var _context: LifeGameContext
    private var _cancellables: [AnyCancellable] = []
    private let _logger = Logger(subsystem: "tech.penginmura.LifeGameApp", category: "ContentViewModel")

    // MARK: - Actions
    
    func tapCell(x: Int, y: Int) {
        _context.toggle(x: x, y: y)
    }
    
    func tapPlayButton() {
        _context.play()
    }
    
    func tapStopButton() {
        _context.stop()
    }
    
    func tapNextButton() {
        _context.next()
    }
    
    func tapRandomButton() {
        _context.generateRandom()
    }
    
    func selectPreset(_ preset: BoardPreset) {
        _context.setPreset(preset)
    }

    func tapClear() {
        _context.clear()
    }

    func onSliderChanged(_ ediging: Bool) {
        if ediging {
            _context.pause()
        } else {
            _context.resume()
        }
    }
}
