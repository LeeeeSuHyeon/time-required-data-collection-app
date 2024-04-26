//
//  MainView.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/26/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack{
            Image("Gach")
                .resizable()
                .scaledToFit()
            Spacer()

            Text("'가천대학교 교내 이동 시간 데이터를 활용한 AI 예측 최적 경로 추천 및 AR 내비게이션 서비스 개발'을 위해 AI 모델의 학습 데이터(출생년도, 성별, 키, 몸무게, 기온, 강수량, 강수확률, 실제 소요된 시간)를 수집하기 위한 데이터 수집용 애플리케이션입니다.")
        }
    }
}

#Preview {
    MainView()
}
