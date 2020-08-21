//
//  LifeGameContext.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/07/17.
//

import Combine
import LifeGame
import Foundation
import SwiftUI
import os

// TODO: 最初のノリで作ったはいいけど完全に負債なので早くリファクタリングして。どうぞ。

final class LifeGameContext {
    private static let _logger = Logger(subsystem: "tech.penginmura.LifeGameApp", category: "UserDefaults") // TODO: refactor
    
    static let shared = LifeGameContext()
    
    var board: AnyPublisher<LifeGameBoard, Never> { _board.eraseToAnyPublisher() }
    var speed: AnyPublisher<Double, Never> { _speed.eraseToAnyPublisher() }
    let isEnabledPlay: PassthroughSubject<Bool, Never> = .init()
    let isEnabledStop: PassthroughSubject<Bool, Never> = .init()
    let isEnabledNext: PassthroughSubject<Bool, Never> = .init()

    fileprivate let _board: CurrentValueSubject<LifeGameBoard, Never>
    private var _setting: SettingEnvironment
    private let _speed: CurrentValueSubject<Double, Never>
    private let _BaseInterval = 0.05
    private var _timerPublisher: Cancellable?
    private var _cancellables: [AnyCancellable] = []
    
    private var _state: LifeGameState = StopState() {
        didSet {
            bind()
        }
    }
    
    private init(setting: SettingEnvironment = .shared) {
        _setting = setting
        _board = .init(LifeGameBoard(size: setting.boardSize))
        _speed = .init(setting.animationSpeed)
        
        _setting.$animationSpeed
            .assign(to: \._speed.value, on: self)
            .store(in: &_cancellables)

        _setting.$boardSize
            .dropFirst()
            .sink { [weak self] size in
                guard let self = self else { return }
                self._board.value.changeBoardSize(to: size)
            }
            .store(in: &_cancellables)
    }

    private func bind() {
        isEnabledPlay.send(_state.play() != nil)
        isEnabledStop.send(_state.stop() != nil)
        isEnabledNext.send(_state.next() != nil)
    }

    func finishConfigure() {
        bind()
    }

    // MARK: - Actions

    func play() {
        guard let execute = _state.play() else { assertionFailure(); return }
        _state = execute(self)
    }
    
    func stop() {
        guard let execute = _state.stop() else { assertionFailure(); return }
        _state = execute(self)
    }
    
    func next() {
        guard let execute = _state.next() else { assertionFailure(); return }
        _state = execute(self)
    }
    
    func pause() {
        guard let execute = _state.pause() else { assertionFailure(); return }
        _state = execute(self)
    }
    
    func resume() {
        guard let execute = _state.resume() else { assertionFailure(); return }
        _state = execute(self)
    }
    
    func generateRandom() {
        _board.value = LifeGameBoard.random(size: _board.value.size)
    }
    
    func setBoard(_ board: Board<Cell>) {
        let newSize = (board.size <= _board.value.size)
            ? _board.value.size
            : PresetBoardSizes.first(where: { board.size < $0 }) ?? board.size // fail-safe
        
        let newBoard = Board(size: newSize, cell: Cell.die).setBoard(toCenter: board)
        _board.value = LifeGameBoard(board: newBoard)
    }
    
    // TODO: remove (meybe...)
    func setPreset(_ preset: BoardPreset) {
        _board.value.clear()
        _board.value.apply(size: preset.board.size, cells: preset.board.cells.map(\.rawValue))
    }
    
    func clear() {
        _board.value.clear()
    }
    
    func toggle(x: Int, y: Int) {
        _board.value.toggle(x: x, y: y)
    }
    
    func changeSpeed(_ speed: Double) {
        _speed.value = speed
        _setting.animationSpeed = speed
        Self._logger.info("[Write] animationSpeed: \(speed, format: .fixed(precision: 2))")
    }
    
    // MARK: File Private - Allow access from states.
    
    fileprivate func startAnimation() {
        let interval = _BaseInterval + (1.0 - _speed.value) * 0.8
        _timerPublisher = Timer.TimerPublisher(interval: interval, runLoop: .current, mode: .common)
            .autoconnect()
            .sink { _ in
                self._board.value.next()
            }
    }
    
    fileprivate func stopAnimation() {
        _timerPublisher?.cancel()
    }
}

typealias StateExecutor = (LifeGameContext) -> LifeGameState

protocol LifeGameState {
    func play()   -> StateExecutor?
    func stop()   -> StateExecutor?
    func next()   -> StateExecutor?
    func pause()  -> StateExecutor?
    func resume() -> StateExecutor?
}

private class BaseState: LifeGameState {
    func play()   -> StateExecutor? { nil }
    func stop()   -> StateExecutor? { nil }
    func next()   -> StateExecutor? { nil }
    func pause()  -> StateExecutor? { nil }
    func resume() -> StateExecutor? { nil }
}

final private class StopState: BaseState {
    override func play() -> StateExecutor? {
        {
            $0.startAnimation()
            return InProgressState()
        }
    }
    
    override func stop() -> StateExecutor? {
        { _ in self }
    }

    override func next() -> StateExecutor? {
        {
            $0._board.value.next()
            return self
        }
    }
    
    override func pause() -> StateExecutor? {
        { _ in self }
    }
    
    override func resume() -> StateExecutor? {
        { _ in self }
    }
}

final private class InProgressState: BaseState {
    override func stop() -> StateExecutor? {
        {
            $0.stopAnimation()
            return StopState()
        }
    }
    
    override func pause() -> StateExecutor? {
        {
            $0.stopAnimation()
            return PauseState()
        }
    }
}

final private class PauseState: BaseState {
    override func resume() -> StateExecutor? {
        {
            $0.startAnimation()
            return InProgressState()
        }
    }
}
