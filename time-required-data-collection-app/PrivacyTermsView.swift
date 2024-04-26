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

    가천대학교 교내 이동 시간 데이터를 활용한 AI 예측 최적 경로 추천 및 AR 내비게이션 서비스를 위한, 개인정보 이용 약관입니다.
    
    1. 데이터 수집 목적
    1.1 본 애플리케이션은 AI 모델의 학습을 위해 사용자 데이터를 수집합니다.
    1.2 수집되는 데이터에는 출생년도, 성별, 키, 몸무게, 기온, 강수량, 강수확률, 실제 소요된 시간이 포함됩니다.
    
    2. 데이터 활용
    2.1 수집된 데이터는 AI 모델 학습을 위해 사용됩니다.
    2.2 이를 통해 사용자 개인의 신체적 특징과 현재 날씨 상황을 고려하여 개인화된 소요 시간을 제공합니다.
    
    3. 데이터 익명화
    3.1 수집된 데이터는 익명화 처리되며, 개인을 식별할 수 없는 형태로 저장 및 활용됩니다.
    
    4. 데이터 공유
    4.1 사용자 데이터는 제3자와 공유되지 않으며, AI 모델 학습용 데이터로만 사용됩니다.
    
    5. 위치 정보
    5.1 앱은 사용자의 현재 위치를 추적하며, 내비게이션 서비스를 위해 교내에 미리 저장된 위치 정보를 활용합니다.
    5.2 위치 정보는 실시간으로 감시되지 않으며, 앱을 사용하는 동안에만 사용됩니다.
    
    6. 동의 철회
    6.1 사용자는 언제든지 데이터 수집에 대한 동의를 철회할 수 있습니다.

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
