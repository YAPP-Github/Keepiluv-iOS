//
//  String+Extensions.swift
//  SharedUtil
//
//  Created by 정지훈 on 2/23/26.
//

import Foundation

extension String {
    public var dateDisplayString: Self {
        let components = self.split(separator: "-").compactMap { Int($0) }
        guard components.count == 3 else { return self }
        
        // components[0]: 년, [1]: 월, [2]: 일
        return Self(format: "%d년 %d월 %d일", components[0], components[1], components[2])
    }
}
