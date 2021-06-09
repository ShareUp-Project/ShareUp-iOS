//
//  Category.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/25.
//

import Foundation

enum Category: String {
    case default0 = "default"
    case first = "first"
    case paper1 = "paper1"
    case paper2 = "paper2"
    case paper3 = "paper3"
    case vinyl1 = "vinyl1"
    case vinyl2 = "vinyl2"
    case vinyl3 = "vinyl3"
    case can1 = "can1"
    case can2 = "can2"
    case can3 = "can3"
    case glass1 = "glass1"
    case glass2 = "glass2"
    case glass3 = "glass3"
    case styrofoam1 = "styrofoam1"
    case styrofoam2 = "styrofoam2"
    case styrofoam3 = "styrofoam3"
    case clothing1 = "clothing1"
    case clothing2 = "clothing2"
    case clothing3 = "clothing3"
    case plastic1 = "plastic1"
    case plastic2 = "plastic2"
    case plastic3 = "plastic3"
}

extension Category {
    func toDescription() -> [String] {
        switch self {
        case .default0:
            return ["첫 걸음", "업사이클에 관심을 갖고 쉐어업 서비스를 이용해주셔서 감사드립니다!", " "]
        case .first:
            return ["삐약 삐약", "시작이 반이라고들 하죠. 당신의 첫 번째 업사이클을 축하드립니다!", "(첫 게시물 작성 시 달성)"]
        case .paper1:
            return ["A4 용지", "당신의 작은 활동이 세상을 변화시키고 있어요! 파이팅!", "(종이 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .paper2:
            return ["이면지", "앗, 방금 나무 살리는 소리 안들렸나요? 당신의 핸드폰에서 들린 것 같은데!", "(종이 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .paper3:
            return ["재생지", "우와! 종이 업사이클을 이렇게 많이 하시다니 감동입니다! 앞으로도 당신의 업사이클을 응원해요!", "(종이 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .vinyl1:
            return ["편의점 봉투", "그거 알고있나요? 방금 당신이 비닐이 목에 걸려 죽을뻔한 동물 5마리를 살려준것을요!", "(비닐 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .vinyl3:
            return ["재활용 비닐", "비닐로 20개의 새활용을 했다고요? 앞으로도 지금처럼 저희한테 비법좀 전수해주세요!", "(비닐 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .vinyl2:
            return ["깨끗한 비닐", "뭐라고요? 비닐 새활용을 10개나 했다고요? 잘했어요. 앞으로도 계속 해주세요!", "(비닐 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .can1:
            return ["폐알루미늄캔", "우와! 방금 당신이 한해동안 사용되는 6억개의 캔 중 5개를 새활용했어요!", "(캔 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .can2:
            return ["철캔", "어디서 5,000년 젊어지는 소리 안들리나요? 알루미늄캔 하나가 땅속에서 분해되는데 500년이나 걸린대요!", "(캔 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .can3:
            return ["금속캔", "음료를 너무 많이 드시는거 아닌가요? 뭐, 어때요! 이렇게 새활용을 많이 해주시는데!", "(캔 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .glass1:
            return ["깨진 유리", "유리로 5개의 새활용을! 유리 특성상 깨지기 쉽고, 새활용 중 쉽게 부상을 입을 수 있으니 주의하세요!", "(유리 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .glass2:
            return ["내열 유리", "내열(전자레인지용) 유리들은 재활용이 불가하다는거 알고있으셨나요? 이미 안다고요? 그럼 재활용 말고 새활용 부탁드립니다!", "(유리 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .glass3:
            return ["친환경 유리", "당신 덕분에 폐유리들도 새활용을 만나 재활용이 가능한 친환경 유리로 변하고있어요!", "(유리 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .styrofoam1:
            return ["컵라면 용기", "스티로폼 새활용에 벌써 5개나 성공하셨군요! 재질 특성상 새활용이 어려울순 있어도 조금만 더 파이팅 해봐요!", "(스티로폼 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .styrofoam2:
            return ["코팅 스티로폼", "코팅 스티로폼은 재활용이 안된다고 해요! 앞으론 재활용 말고 새활용으로 환경을 살려봐요!", "(스티로폼 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .styrofoam3:
            return ["A등급 인코트", "정말요? 벌써 스티로폼으로 20개의 새활용을 했다고요? 지구가 건강해지는 소리가 여기까지 들리네요!", "(스티로폼 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .clothing1:
            return ["헌옷", "헌 옷들에게 또다른 생명을 불어넣는 당신! 옷들이 감사해하는 소리가 여기까지 들리네요!", "(의류 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .clothing2:
            return ["리폼 옷", "당신은 리폼의 달인! 이정도면 장사해도 되겠는데요?", "(의류 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .clothing3:
            return ["의류 수거함", "당신은 살아있는 의류 수거함! 헌옷이 당신과 만나면 반짝반짝한 새활용 제품으로 재탄생 한다면서요?","(의류 카테고리 게시물 20개 이상 작성 시 달성)"]
        case .plastic1:
            return ["생수병", "", "(플라스틱 카테고리 게시물 5개 이상 작성 시 달성)"]
        case .plastic2:
            return ["", "", "(플라스틱 카테고리 게시물 10개 이상 작성 시 달성)"]
        case .plastic3:
            return ["", "", "(플라스틱 카테고리 게시물 20개 이상 작성 시 달성)"]
        }
    }
}
