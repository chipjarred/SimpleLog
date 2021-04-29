// Copyright 2021 Chip Jarred
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

@usableFromInline internal var loggers: [Log] = []

// -------------------------------------
@usableFromInline internal var runningDebugBuildInXCTest: Bool
{
    #if DEBUG
    let pInfo = ProcessInfo.processInfo
    return pInfo.environment["XCTestConfigurationFilePath"] != nil
    #else
    return false
    #endif
}


// -------------------------------------
public func addLog(_ log: Log) {
    loggers.append(log)
}

// -------------------------------------
@inlinable
public func log(
    _ message: String,
    function: StaticString = #function,
    file: StaticString = #fileID,
    line: UInt = #line)
{
    log(
        .info, message,
        function: function,
        file: file,
        line: line
    )
}

// -------------------------------------
@inlinable
public func log(
    _ level: LogLevel,
    _ message: @autoclosure () -> String,
    function: StaticString = #function,
    file: StaticString = #fileID,
    line: UInt = #line)
{
    var isDebugBuild: Bool
    {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    let msg: String = level == .debug && isDebugBuild
        ? ":\(file):\(line):\(function): \(message())"
        : message()
    
    loggers.forEach { $0.append(level: level, message: msg) }
    
    #if DEBUG
    if !runningDebugBuildInXCTest
    {
        switch level
        {
            case .critical:
                assertionFailure(msg)
            default: break
        }
    }
    #endif
}
