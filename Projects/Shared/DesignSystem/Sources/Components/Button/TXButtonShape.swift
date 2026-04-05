//
//  TXButtonShape.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 4/3/26.
//

import SwiftUI

public enum TXButtonShape {
    case rect(style: TXRectStyle, size: TXRectSize, state: TXRectState)
    case square(style: TXSquareStyle, size: TXSquareSize, state: TXSquareState)
    case round(style: TXRoundStyle, size: TXRoundSize, state: TXRoundState)
    case circle(style: TXCircleStyle, size: TXCircleSize, state: TXCircleState)
    
    // MARK: - Rect
    public enum TXRectStyle {
        case basic(text: String)
    }
    
    public enum TXRectSize {
        case l
        case m
        case s
    }

    public enum TXRectState {
        case standard
        case line
        case disabled
    }
    
    // MARK: - Square
    public enum TXSquareStyle {
        case lineIcon(icon: Image)
        case lineText(text: String)
    }
    
    public enum TXSquareSize {
        case m
    }
    
    public enum TXSquareState {
        case standard
    }
    
    // MARK: - Round
    public enum TXRoundStyle {
        case illustLight(text: String)
        case lillustDark(text: String)
    }
    
    public enum TXRoundSize {
        case l
        case m
        case s
    }
    
    public enum TXRoundState {
        case standard
    }
    
    // MARK: - Circle
    public enum TXCircleStyle {
        case basic
        case glass
    }
    
    public enum TXCircleSize {
        case m
        case s
    }
    
    public enum TXCircleState {
        case standard
        case disabled
        case line
    }
}
