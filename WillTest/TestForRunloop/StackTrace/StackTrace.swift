//
//  StackTrace.swift
//  TestForRunloop
//
//  Created by meitu007 on 2020/2/27.
//  Copyright © 2020 meitu. All rights reserved.
//

import Foundation

@_silgen_name("mach_backtrace")
public func backtrace(_ thread: thread_t, stack: UnsafeMutablePointer<UnsafeMutableRawPointer?>!, _ maxSymbols: Int32) -> Int32

@objc public class Backtrace: NSObject {
    
    public static var main_thread_t: mach_port_t?
    
    // 需要先在主线程调用
    public static func setup() {
        main_thread_t = mach_thread_self()
    }
    
    @objc public static func callstack(_ thread: Thread) -> [stack]
}
