//
//  String+Extension.swift
//  Contem
//
//  Created by 이상민 on 11/26/25.
//

import Foundation

extension String{
    //00년 00월 00일
    func toKoreanDateFormat() -> String{
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
            .withTimeZone
        ]
        
        guard let data = isoFormatter.date(from: self) else{ return "..." }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "YY년 M월 d일"
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return outputFormatter.string(from: data)
    }
}
