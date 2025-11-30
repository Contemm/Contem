//
//  MockStyle.swift
//  Contem
//
//  Created by 이상민 on 11/17/25.
//

import Foundation

struct MockStyle{
    static let sample = StyleEntity(
        postId: "TEST_001",
        category: "look",
        title: "The Bold and The Simple",
        price: 19000,
        content: "Weave them together or wear them separately, it’s your call. Day or night, this is your look.",
        value1: "x0.52y0.88:x0.23y0.20",
        value2: "x0.68y0.40",
        value3: "x0.15y0.70:x0.42y0.52",
        value4: "",
        value5: "",
        createdAt: "2024-11-18T14:22:05.422Z",
        creator: StyleCreatorEntity(
            userId: "TEST_001",
            nick: "Test",
            profileImage: ""
        ),
        files: ["look1", "look2", "look3"],
        likes: ["TEST_002", "TEST_003", "TEST_004"],
        commentCount: 248
    )
}
