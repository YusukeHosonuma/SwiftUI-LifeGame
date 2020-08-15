//
//  NWPathMonitor+Publisher.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/15.
//

import Combine
import Foundation
import Network

extension NWPathMonitor {
    func publisher(queue: DispatchQueue = DispatchQueue.main) -> NWPathMonitor.Publisher {
        Publisher(monitor: self, queue: queue)
    }
    
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath {
        private let subscriber: S
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
        private var isStarted = false
        
        init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        func request(_ demand: Subscribers.Demand) {
            precondition(demand == .unlimited, "This subscription is only supported to `Demand.unlimited`.")
            
            guard !isStarted else { return }
            isStarted = true
            
            monitor.pathUpdateHandler = { [unowned self] path in
                _ = self.subscriber.receive(path)
            }
            monitor.start(queue: queue)
        }
        
        func cancel() {
            monitor.cancel()
        }
    }
    
    struct Publisher: Combine.Publisher {
        typealias Output = NWPath
        typealias Failure = Never
        
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
        
        init(monitor: NWPathMonitor, queue: DispatchQueue) {
            self.monitor = monitor
            self.queue = queue
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, monitor: monitor, queue: queue)
            subscriber.receive(subscription: subscription)
        }
    }
}
