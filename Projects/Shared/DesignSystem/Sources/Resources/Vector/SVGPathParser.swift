//
//  SVGPathParser.swift
//  SharedDesignSystem
//
//  Created by Jihun on 2/19/26.
//

import SwiftUI

enum SVGPathParser {
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
        var context = ParserContext(tokens: tokenize(data))
        while context.hasRemainingTokens {
            context.advanceCommandIfNeeded()
            guard let command = context.activeCommand else { break }
            guard apply(command: command, to: &context) else {
                return context.path
            }
        }
        return context.path
    }
    
    // SVG path d 문자열을 command / number 토큰 배열로 분리
    private static func tokenize(_ data: String) -> [Token] {
        var tokens: [Token] = []
        var index = data.startIndex
        
        while index < data.endIndex {
            skipSeparators(in: data, index: &index)
            guard index < data.endIndex else { break }
            
            if let commandToken = readCommandToken(in: data, index: &index) {
                tokens.append(commandToken)
                continue
            }
            
            if let numberToken = readNumberToken(in: data, index: &index) {
                tokens.append(numberToken)
            }
        }
        
        return tokens
    }
}

// MARK: - Private Helpers
private extension SVGPathParser {
    
    // SVG path 문자열을 "명령어(command)"와 "숫자(number)" 토큰으로 분리하기 위한 타입
    enum Token {
        case command(Character)
        case number(CGFloat)
    }
    
    
    struct ParserContext {
        let tokens: [Token]
        var index: Int = 0
        var activeCommand: Character?
        var currentPoint: CGPoint = .zero
        var subPathStart: CGPoint = .zero
        var path = Path()
        
        // 아직 읽지 않은 토큰이 남아있는지 확인합니다.
        var hasRemainingTokens: Bool { index < tokens.count }
        
        // 현재 인덱스가 command 토큰이면 활성 커맨드를 갱신합니다.
        mutating func advanceCommandIfNeeded() {
            guard hasRemainingTokens else { return }
            guard case let .command(command) = tokens[index] else { return }
            activeCommand = command
            index += 1
        }
        
        // 현재 인덱스가 number 토큰인지 확인합니다.
        var hasNumber: Bool {
            guard hasRemainingTokens else { return false }
            if case .number = tokens[index] { return true }
            return false
        }
        
        // number 토큰 하나를 읽고 인덱스를 전진시킵니다.
        mutating func readNumber() -> CGFloat? {
            guard hasRemainingTokens else { return nil }
            guard case let .number(value) = tokens[index] else { return nil }
            index += 1
            return value
        }
        
        // x/y 좌표 두 개를 읽어 상대/절대 기준 CGPoint로 변환합니다.
        mutating func readPoint(isRelative: Bool) -> CGPoint? {
            guard
                let xCoordinate = readNumber(),
                let yCoordinate = readNumber()
            else {
                return nil
            }
            
            if isRelative {
                return CGPoint(
                    x: currentPoint.x + xCoordinate,
                    y: currentPoint.y + yCoordinate
                )
            }
            
            return CGPoint(x: xCoordinate, y: yCoordinate)
        }
    }
    
    // command 문자에 맞는 Path 처리 함수로 분기합니다.
    static func apply(command: Character, to context: inout ParserContext) -> Bool {
        switch command {
        case "M", "m":
            handleMove(command: command, context: &context)
        case "L", "l":
            handleLine(command: command, context: &context)
        case "C", "c":
            handleCurve(command: command, context: &context)
        case "Z", "z":
            handleClose(context: &context)
        default:
            return false
        }
        return true
    }
    
    // MoveTo 커맨드를 처리하고, 이어지는 좌표는 LineTo로 연결합니다.
    static func handleMove(command: Character, context: inout ParserContext) {
        let isRelative = command == "m"
        guard let firstPoint = context.readPoint(isRelative: isRelative) else { return }
        
        context.path.move(to: firstPoint)
        context.currentPoint = firstPoint
        context.subPathStart = firstPoint
        
        while context.hasNumber,
              let point = context.readPoint(isRelative: isRelative) {
            context.path.addLine(to: point)
            context.currentPoint = point
        }
    }
    
    // LineTo 커맨드를 처리해 직선 세그먼트를 추가합니다.
    static func handleLine(command: Character, context: inout ParserContext) {
        let isRelative = command == "l"
        while context.hasNumber,
              let point = context.readPoint(isRelative: isRelative) {
            context.path.addLine(to: point)
            context.currentPoint = point
        }
    }
    
    // Cubic Bezier 커맨드를 처리해 곡선 세그먼트를 추가합니다.
    static func handleCurve(command: Character, context: inout ParserContext) {
        let isRelative = command == "c"
        
        while context.hasNumber {
            guard
                let firstControlPoint = context.readPoint(isRelative: isRelative),
                let secondControlPoint = context.readPoint(isRelative: isRelative),
                let destinationPoint = context.readPoint(isRelative: isRelative)
            else {
                return
            }
            
            context.path.addCurve(
                to: destinationPoint,
                control1: firstControlPoint,
                control2: secondControlPoint
            )
            context.currentPoint = destinationPoint
        }
    }
    
    // ClosePath 커맨드를 처리해 현재 서브패스를 닫습니다.
    static func handleClose(context: inout ParserContext) {
        context.path.closeSubpath()
        context.currentPoint = context.subPathStart
    }
    
    // 공백/콤마 구분자를 건너뛰어 다음 토큰 위치로 이동합니다.
    static func skipSeparators(in data: String, index: inout String.Index) {
        while index < data.endIndex {
            let character = data[index]
            guard character.isWhitespace || character == "," else { break }
            index = data.index(after: index)
        }
    }
    
    // command 문자를 읽어 command 토큰으로 변환합니다.
    static func readCommandToken(
        in data: String,
        index: inout String.Index
    ) -> Token? {
        let character = data[index]
        guard character.isLetter else { return nil }
        
        index = data.index(after: index)
        return .command(character)
    }
    
    // 숫자 문자열을 읽어 number 토큰으로 변환합니다.
    static func readNumberToken(
        in data: String,
        index: inout String.Index
    ) -> Token? {
        let numberStart = index
        var cursor = index
        
        while cursor < data.endIndex {
            let currentCharacter = data[cursor]
            
            if isPartOfNumber(currentCharacter) {
                cursor = data.index(after: cursor)
                continue
            }
            
            if isSign(currentCharacter) {
                if shouldConsumeSign(
                    in: data,
                    cursor: cursor,
                    numberStart: numberStart
                ) {
                    cursor = data.index(after: cursor)
                    continue
                }
                break
            }
            
            break
        }
        
        guard cursor != numberStart else {
            return nil
        }
        
        index = cursor
        let valueString = String(data[numberStart..<cursor])
        guard let value = Double(valueString) else { return nil }
        return .number(CGFloat(value))
    }
    
    // 숫자 본문으로 허용되는 문자(숫자/소수점/지수 표기)인지 확인합니다.
    static func isPartOfNumber(_ character: Character) -> Bool {
        character.isNumber || character == "." || character == "e" || character == "E"
    }
    
    // 부호 문자(+/-)인지 확인합니다.
    static func isSign(_ character: Character) -> Bool {
        character == "-" || character == "+"
    }
    
    // 현재 부호를 숫자 토큰에 포함할지 여부를 판단합니다.
    static func shouldConsumeSign(
        in data: String,
        cursor: String.Index,
        numberStart: String.Index
    ) -> Bool {
        if cursor == numberStart {
            return true
        }
        
        let previousCharacter = data[data.index(before: cursor)]
        return previousCharacter == "e" || previousCharacter == "E"
    }
}
