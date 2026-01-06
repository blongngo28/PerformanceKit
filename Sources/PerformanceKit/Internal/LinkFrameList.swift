//
//  LinkFrameList.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//

import Foundation

/// Node in the linked list for tracking frame timestamps
internal class FrameNode {
    var next: FrameNode?
    weak var previous: FrameNode?
    private(set) var timestamp: TimeInterval
    
    init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }
}

/// Linked list for managing frame timestamps used in FPS calculation
internal class LinkedFramesList {
    private var head: FrameNode?
    private var tail: FrameNode?
    private(set) var count = 0
    
    /// Adds a new frame with the given timestamp
    /// - Parameter timestamp: The frame's timestamp
    func append(frameWithTimestamp timestamp: TimeInterval) {
        let newNode = FrameNode(timestamp: timestamp)
        
        if let lastNode = tail {
            newNode.previous = lastNode
            lastNode.next = newNode
            tail = newNode
        } else {
            head = newNode
            tail = newNode
        }
        
        count += 1
        removeFrameNodes(olderThanTimestampMoreThanSecond: timestamp)
    }
    
    /// Removes frames older than 1 second from the given timestamp
    /// - Parameter timestamp: Reference timestamp
    private func removeFrameNodes(olderThanTimestampMoreThanSecond timestamp: TimeInterval) {
        while let firstNode = head {
            guard timestamp - firstNode.timestamp > 1.0 else { break }
            
            let nextNode = firstNode.next
            nextNode?.previous = nil
            firstNode.next = nil
            head = nextNode
            count -= 1
        }
    }
}
