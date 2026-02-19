//
//  SVGPathParser.swift
//  SharedDesignSystem
//
//  Created by Jihun on 2/19/26.
//

import SwiftUI

enum SVGPathParser {
    // SVG path 문자열을 "명령어(command)"와 "숫자(number)" 토큰으로 분리하기 위한 타입
    private enum Token {
        case command(Character)
        case number(CGFloat)
    }
    
    // 동일한 SVG path 문자열 파싱 비용을 줄이기 위한 캐시
    private static var cache: [String: Path] = [:]
    
    // 외부 진입점: SVG path d 문자열을 SwiftUI Path로 변환 (캐시 사용)
    static func path(from icon: TXVector.Icon) -> Path {
        if let cachedPath = cache[icon.rawValue] {
            return cachedPath
        }
        
        let parsedPath = parse(icon.pathData)
        cache[icon.rawValue] = parsedPath
        return parsedPath
    }
    
    // tokenize된 토큰을 순회하면서 실제 SwiftUI Path를 구성
    private static func parse(_ data: String) -> Path {
        let tokens = tokenize(data)
        
        var index = 0
        var activeCommand: Character?
        var currentPoint = CGPoint.zero
        var subPathStart = CGPoint.zero
        var path = Path()
        
        // 다음 토큰이 숫자인지 확인 (같은 커맨드 반복 여부 판단)
        func hasNumber() -> Bool {
            guard index < tokens.count else { return false }
            if case .number = tokens[index] {
                return true
            }
            return false
        }
        
        // 숫자 토큰 하나를 읽고 index를 전진
        func readNumber() -> CGFloat? {
            guard index < tokens.count else { return nil }
            if case let .number(value) = tokens[index] {
                index += 1
                return value
            }
            return nil
        }
        
        // x,y 두 숫자를 읽어 CGPoint 생성 (상대/절대 좌표 처리)
        func readPoint(relative: Bool) -> CGPoint? {
            guard let x = readNumber(), let y = readNumber() else {
                return nil
            }
            
            if relative {
                return CGPoint(x: currentPoint.x + x, y: currentPoint.y + y)
            } else {
                return CGPoint(x: x, y: y)
            }
        }
        
        // 토큰을 순차적으로 읽으면서 현재 활성 커맨드에 따라 Path 생성
        while index < tokens.count {
            if case let .command(command) = tokens[index] {
                activeCommand = command
                index += 1
            }
            
            guard let command = activeCommand else {
                break
            }
            
            switch command {
            // MoveTo: 서브패스 시작점 이동 (첫 점 이후 숫자는 LineTo로 처리)
            case "M", "m":
                let isRelative = command == "m"
                guard let firstPoint = readPoint(relative: isRelative) else { break }
                
                path.move(to: firstPoint)
                currentPoint = firstPoint
                subPathStart = firstPoint
                
                while hasNumber(), let point = readPoint(relative: isRelative) {
                    path.addLine(to: point)
                    currentPoint = point
                }
                
            // LineTo: 현재 위치에서 직선 연결
            case "L", "l":
                let isRelative = command == "l"
                
                while hasNumber(), let point = readPoint(relative: isRelative) {
                    path.addLine(to: point)
                    currentPoint = point
                }
                
            // Cubic Bezier: 두 개의 컨트롤 포인트와 목적지로 곡선 추가
            case "C", "c":
                let isRelative = command == "c"
                
                while hasNumber() {
                    guard
                        let control1 = readPoint(relative: isRelative),
                        let control2 = readPoint(relative: isRelative),
                        let destination = readPoint(relative: isRelative)
                    else { break }
                    
                    path.addCurve(
                        to: destination,
                        control1: control1,
                        control2: control2
                    )
                    currentPoint = destination
                }
                
            // ClosePath: 현재 서브패스를 시작점으로 닫기
            case "Z", "z":
                path.closeSubpath()
                currentPoint = subPathStart
                
            default:
                // 지원하지 않는 커맨드가 들어오면 파싱을 멈춥니다.
                return path
            }
        }
        
        return path
    }
    
    // SVG path d 문자열을 command / number 토큰 배열로 분리
    private static func tokenize(_ data: String) -> [Token] {
        var tokens: [Token] = []
        var index = data.startIndex
        
        // 문자열을 한 글자씩 순회하며 토큰 추출
        while index < data.endIndex {
            let char = data[index]
            
            if char.isWhitespace || char == "," {
                index = data.index(after: index)
                continue
            }
            
            if char.isLetter {
                tokens.append(.command(char))
                index = data.index(after: index)
                continue
            }
            
            // 숫자 파싱 시작: 부호, 소수점, 지수표기(e/E)까지 포함하여 하나의 숫자로 읽음
            let numberStart = index
            var cursor = index
            
            while cursor < data.endIndex {
                let current = data[cursor]
                
                if current.isNumber || current == "." {
                    cursor = data.index(after: cursor)
                    continue
                }
                
                if current == "-" || current == "+" {
                    if cursor == numberStart {
                        cursor = data.index(after: cursor)
                        continue
                    }
                    
                    let previous = data[data.index(before: cursor)]
                    if previous == "e" || previous == "E" {
                        cursor = data.index(after: cursor)
                        continue
                    }
                    break
                }
                
                if current == "e" || current == "E" {
                    cursor = data.index(after: cursor)
                    continue
                }
                
                break
            }
            
            let valueString = String(data[numberStart..<cursor])
            if let value = Double(valueString) {
                tokens.append(.number(CGFloat(value)))
            }
            
            index = cursor
        }
        
        return tokens
    }
}
