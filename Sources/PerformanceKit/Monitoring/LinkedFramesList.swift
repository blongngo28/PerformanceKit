//
//  LinkedFramesList.swift
//  PerformanceKit
//
//  Created by Nazar Velkakayev on 06.01.2026.
//


import QuartzCore

/// Node for linked list implementation used in FPS calculation.
///
/// This internal class represents a single frame timestamp in a doubly-linked list
/// used for efficient FPS calculation over a sliding time window.
internal class FrameNode {
    /// Reference to the next frame node in the list.
    var next: FrameNode?
    
    /// Weak reference to the previous frame node in the list.
    weak var previous: FrameNode?
    
    /// The timestamp when this frame occurred.
    private(set) var timestamp: TimeInterval
    
    /// Creates a new frame node with the specified timestamp.
    ///
    /// - Parameter timestamp: The timestamp when the frame occurred.
    init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }
}

/// Doubly-linked list for efficient FPS calculation over a sliding window.
///
/// This internal class maintains a sliding window of frame timestamps from the
/// last second, allowing for accurate FPS calculation by counting frames
/// within the one-second window.
internal class LinkedFramesList {
    private var head: FrameNode?
    private var tail: FrameNode?
    private(set) var count = 0
    
    /// Adds a new frame timestamp to the list.
    ///
    /// This method adds a new frame node to the end of the list and removes
    /// any frames that are older than one second from the current timestamp.
    ///
    /// - Parameter timestamp: The timestamp of the new frame.
    func append(frameWithTimestamp timestamp: TimeInterval) {
        let newNode = FrameNode(timestamp: timestamp)
        
        if let lastNode = self.tail {
            newNode.previous = lastNode
            lastNode.next = newNode
            self.tail = newNode
        } else {
            self.head = newNode
            self.tail = newNode
        }
        
        self.count += 1
        self.removeFrameNodes(olderThanTimestampMoreThanSecond: timestamp)
    }
    
    /// Removes frame nodes that are older than one second from the given timestamp.
    ///
    /// This method maintains the sliding window by removing frames that fall
    /// outside the one-second window, ensuring the FPS calculation is accurate
    /// for the most recent second.
    ///
    /// - Parameter timestamp: The current timestamp to compare against.
    private func removeFrameNodes(olderThanTimestampMoreThanSecond timestamp: TimeInterval) {
        while let firstNode = self.head {
            guard timestamp - firstNode.timestamp > 1.0 else {
                break
            }
            
            let nextNode = firstNode.next
            nextNode?.previous = nil
            firstNode.next = nil
            self.head = nextNode
            
            self.count -= 1
        }
    }
}
