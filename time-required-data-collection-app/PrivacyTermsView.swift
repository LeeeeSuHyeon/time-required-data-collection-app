//
//  PrivacyTermsView.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/26/24.
//

import SwiftUI

struct PrivacyTermsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var longText =
    """

    가천대학교 교내 이동 시간 데이터를 활용한 AI 예측 최적 경로 추천 및 AR 내비게이션 서비스를 위해 데이터 수집만을 목적으로 둔 본 애플리케이션에 대한 개인정보 이용 약관입니다.
    
    1. 데이터 수집 목적:
    - 이 앱은 AI 모델의 학습을 위해 데이터 수집만을 위한 목적으로 사용됩니다.
    - 현재 많은 사람들이 지도 앱의 도보 내비게이션 기능을 이용하고 있습니다. 그러나 기존 앱의 내비게이션 기능은 주로 사람의 평균 속도만을 고려하여 소요시간을 예상합니다. 그러나 사람의 나이, 성별, 키, 몸무게에 따라 걸음 속도가 달라지며, 날씨 조건에 따라도 속도가 영향을 받을 것으로 예상됩니다. 따라서 이러한 데이터를 수집하여 AI 모델을 학습시키고, 현재 날씨 및 사용자의 신체적 특징에 따라 개인화된 소요시간을 제공하는 것이 목적입니다.
    
    2. 데이터 활용:
    - 이 앱은 데이터 수집용 앱으로, '가천대학교 교내 이동 시간 데이터를 활용한 AI 예측 최적 경로 추천 및 AR 내비게이션 서비스 개발'을 위해 AI 모델의 학습 데이터를 수집합니다.
    - 사용자 데이터는 제3자와 공유되지 않고 AI 학습 데이터로만 사용됩니다. 대상 사용자는 가천대학교 학생이 주로 대상이며, 위치 정보는 내비게이션 서비스를 위해 사용됩니다. 사용자의 현재 위치를 실시간으로 감시하는 것이 아니며, 내비게이션 서비스를 위해 미리 저장된 위치 정보를 활용합니다.
    
    3. 데이터 익명화:
    - 이 앱은 사용자의 개인 식별 정보를 수집하지 않습니다.
    - 사용자의 키, 몸무게, 성별, 나이 등의 데이터는 익명화 처리되어 개인을 식별할 수 없는 형태로 저장 및 활용됩니다.
    
    4. 동의 철회 방법:
    사용자는 언제든지 데이터 수집에 대한 동의를 철회할 수 있습니다. 동의 철회를 원할 경우, tngus0673@gachon.ac.kr로 문의주시면 도와드리겠습니다.
    
    동의: 본 내용을 읽고 이해했으며, 개인정보 수집에 동의합니다.
    
    """
    
    var body: some View {
        VStack {
            HStack() {
                Text("개인정보 이용 약관")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.7)
                                .frame(width: 30, height: 30)
                        )
                })
                .padding(.trailing, 25)
            }
            .padding(.top)

            ScrollView {
                Text(longText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .padding(.trailing)
            }
            
        }
        
    }
    
}

#Preview {
    PrivacyTermsView()
}



//1. 데이터 수집 목적
//1.1 본 애플리케이션은 AI 모델의 학습을 위해 사용자 데이터를 수집합니다.
//1.2 수집되는 데이터에는 출생년도, 성별, 키, 몸무게, 기온, 강수량, 강수확률, 실제 소요된 시간이 포함됩니다.
//
//2. 데이터 활용
//2.1 수집된 데이터는 AI 모델 학습을 위해 사용됩니다.
//2.2 이를 통해 사용자 개인의 신체적 특징과 현재 날씨 상황을 고려하여 개인화된 소요 시간을 제공합니다.
//
//3. 데이터 익명화
//3.1 수집된 데이터는 익명화 처리되며, 개인을 식별할 수 없는 형태로 저장 및 활용됩니다.
//
//4. 데이터 공유
//4.1 사용자 데이터는 제3자와 공유되지 않으며, AI 모델 학습용 데이터로만 사용됩니다.
//
//5. 위치 정보
//5.1 앱은 사용자의 현재 위치를 추적하며, 내비게이션 서비스를 위해 교내에 미리 저장된 위치 정보를 활용합니다.
//5.2 위치 정보는 실시간으로 감시되지 않으며, 앱을 사용하는 동안에만 사용됩니다.
//
//6. 동의 철회
//6.1 사용자는 언제든지 데이터 수집에 대한 동의를 철회할 수 있습니다.
//
