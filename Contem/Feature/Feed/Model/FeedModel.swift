//
//  FeedModel.swift
//  Contem
//
//  Created by HyoTaek on 11/12/25.
//

import Foundation

struct FeedModel: Identifiable, Hashable {
    let id = UUID()
    let thumbnailImages: [String]
    let author: Author
    let likeCount: Int
    let title: String
    let hashTags: [String]
    let imageAspectRatio: Double // 이미지의 가로/세로 비율 (width / height)
}

struct Author: Identifiable, Hashable {
    let id = UUID()
    let profileImage: String
    let nickname: String
}

// MARK: - Dummy Data
extension FeedModel {
    static let dummyData: [FeedModel] = [
        FeedModel(
            thumbnailImages: [
                "banner_1"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=1", nickname: "패션러버"),
            likeCount: 1234,
            title: "피드 제목1",
            hashTags: ["#데일리룩", "#오늘의패션", "#OOTD"],
            imageAspectRatio: 0.75
        ),
        FeedModel(
            thumbnailImages: [
                "banner_2"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=2", nickname: "패션헌터"),
            likeCount: 892,
            title: "피드 제목2",
            hashTags: ["#스트릿패션", "#패션코디", "#패션스타일"],
            imageAspectRatio: 1.2
        ),
        FeedModel(
            thumbnailImages: [
                "banner_3"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=3", nickname: "스타일리스트"),
            likeCount: 2156,
            title: "피드 제목3",
            hashTags: ["#겨울패션", "#니트코디", "#따뜻한스타일"],
            imageAspectRatio: 0.9
        ),
        FeedModel(
            thumbnailImages: [
                "banner_4"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=4", nickname: "패션피플"),
            likeCount: 3421,
            title: "피드 제목4",
            hashTags: ["#미니멀패션", "#심플룩", "#깔끔한스타일"],
            imageAspectRatio: 1.1
        ),
        FeedModel(
            thumbnailImages: [
                "banner_5"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=5", nickname: "패션디렉터"),
            likeCount: 567,
            title: "피드 제목5",
            hashTags: ["#캐주얼룩", "#편안한패션", "#일상룩"],
            imageAspectRatio: 0.8
        ),
        FeedModel(
            thumbnailImages: [
                "banner_1"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=6", nickname: "옷장정리의달인"),
            likeCount: 4532,
            title: "피드 제목6",
            hashTags: ["#빈티지패션", "#레트로룩", "#복고스타일"],
            imageAspectRatio: 1.3
        ),
        FeedModel(
            thumbnailImages: [
                "banner_2"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=7", nickname: "패션블로거"),
            likeCount: 1876,
            title: "피드 제목7",
            hashTags: ["#모던룩", "#세련된스타일", "#트렌디"],
            imageAspectRatio: 0.85
        ),
        FeedModel(
            thumbnailImages: [
                "banner_3"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=8", nickname: "쇼핑홀릭"),
            likeCount: 2341,
            title: "피드 제목8",
            hashTags: ["#명품패션", "#럭셔리룩", "#하이엔드"],
            imageAspectRatio: 1.0
        ),
        FeedModel(
            thumbnailImages: [
                "banner_4"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=9", nickname: "룩북메이커"),
            likeCount: 5678,
            title: "피드 제목9",
            hashTags: ["#오피스룩", "#직장인패션", "#정장코디"],
            imageAspectRatio: 0.7
        ),
        FeedModel(
            thumbnailImages: [
                "banner_5"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=10", nickname: "패션마니아"),
            likeCount: 987,
            title: "피드 제목10",
            hashTags: ["#데님룩", "#청바지코디", "#캐주얼"],
            imageAspectRatio: 1.15
        ),
        FeedModel(
            thumbnailImages: [
                "banner_1"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=11", nickname: "코디마스터"),
            likeCount: 3210,
            title: "피드 제목11",
            hashTags: ["#원피스룩", "#페미닌룩", "#여성스러운"],
            imageAspectRatio: 0.95
        ),
        FeedModel(
            thumbnailImages: [
                "banner_2"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=12", nickname: "트렌드세터"),
            likeCount: 6543,
            title: "피드 제목12",
            hashTags: ["#가디건코디", "#니트웨어", "#포근한룩"],
            imageAspectRatio: 1.25
        ),
        FeedModel(
            thumbnailImages: [
                "banner_3"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=13", nickname: "패셔니스타"),
            likeCount: 1456,
            title: "피드 제목13",
            hashTags: ["#블랙룩", "#올블랙", "#모노톤"],
            imageAspectRatio: 0.78
        ),
        FeedModel(
            thumbnailImages: [
                "banner_4"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=14", nickname: "옷잘입는사람"),
            likeCount: 2789,
            title: "피드 제목14",
            hashTags: ["#화이트룩", "#올화이트", "#깨끗한룩"],
            imageAspectRatio: 1.05
        ),
        FeedModel(
            thumbnailImages: [
                "banner_5"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=15", nickname: "스타일아이콘"),
            likeCount: 4321,
            title: "피드 제목15",
            hashTags: ["#아우터룩", "#자켓코디", "#겨울외투"],
            imageAspectRatio: 0.88
        ),
        FeedModel(
            thumbnailImages: [
                "banner_1"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=16", nickname: "패션인플루언서"),
            likeCount: 876,
            title: "피드 제목16",
            hashTags: ["#액세서리코디", "#패션소품", "#스타일링"],
            imageAspectRatio: 1.1
        ),
        FeedModel(
            thumbnailImages: [
                "banner_2"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=17", nickname: "옷장부자"),
            likeCount: 3456,
            title: "피드 제목17",
            hashTags: ["#신발코디", "#슈즈룩", "#풋웨어"],
            imageAspectRatio: 0.82
        ),
        FeedModel(
            thumbnailImages: [
                "banner_3"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=18", nickname: "코디네이터"),
            likeCount: 7890,
            title: "피드 제목18",
            hashTags: ["#가방코디", "#백스타그램", "#패션백"],
            imageAspectRatio: 1.4
        ),
        FeedModel(
            thumbnailImages: [
                "banner_4"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=19", nickname: "패션크리에이터"),
            likeCount: 2134,
            title: "피드 제목19",
            hashTags: ["#레이어드룩", "#겹쳐입기", "#레이어링"],
            imageAspectRatio: 0.92
        ),
        FeedModel(
            thumbnailImages: [
                "banner_5"
            ],
            author: Author(profileImage: "https://i.pravatar.cc/150?img=20", nickname: "룩킹굿"),
            likeCount: 1567,
            title: "피드 제목20",
            hashTags: ["#컬러코디", "#컬러풀", "#알록달록"],
            imageAspectRatio: 1.18
        )
    ]
}

