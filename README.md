# time-required-data-collection-app

## 'Gach.가자' 프로젝트의 AI 모델 학습 데이터 수집용 애플리케이션
----
> AI 모델 학습 데이터 수집용 애플리케이션 'GachData'
>
>  👉 'GachData' 앱스토어 : https://apps.apple.com/kr/app/gachdata/id6499307485
> 
>  👉 'Gach.가자' 레포지토리 : https://github.com/GachonMapProject/GachMap

![gachData](https://github.com/user-attachments/assets/fddd82fc-dbbc-4052-aef0-e82712632288)
![수집](https://github.com/user-attachments/assets/765bdb0f-1e66-4d1d-b38b-cf6c665a2243)
![데이터 수집](https://github.com/user-attachments/assets/f52a55f1-8665-45ed-adea-a8ddda329821)

## 목차
- [1. 프로젝트 소개](#프로젝트-소개)
  - [1.1. 프로젝트 배경](#프로젝트-배경)
  - [1.2. 프로젝트 설명](#프로젝트-설명)
- [2. 개발 환경 및 기술 스택](#개발-환경-및-기술-스택)
- [3. 개발 기간](#개발-기간)
- [4.성과](#성과)
- [5.시연 영상 v1.0](#시연-영상-v1.0)

----

## 프로젝트 소개
- 가천대학교 교내 이동 시간 데이터를 활용한 AI 예측 최적 경로 추천 및 AR 내비게이션 서비스 개발'을 위해 AI 모델의 학습 데이터(출생년도, 성별, 키, 몸무게, 걸음속도, 기온, 강수량, 강수확률, 실제 소요된 시간)를 수집하기 위한 데이터 수집용 애플리케이션입니다.
- 이 앱은 AI 모델 학습을 위해 데이터 수집만을 위한 목적으로 사용됩니다.

  
### 프로젝트 배경
- 현재 많은 사람들이 지도앱의 도보 내비게이션 기능을 이용하고 있습니다. 그러나 기존 앱의 내비게이션 기능의 예상 소요시간은 단지, 사람의 평균 속도만을 이용해 소요시간을 예상합니다.
- 그러나 사람의 나이, 성별, 키, 몸무게에 따라 걸음 속도가 다르며, 비 또는 눈이 오는 날에는 속도가 더 느려질 것입니다.
- 따라서 이러한 데이터를 바탕으로 실제 두 지점 사이의 거리와 경사도에 따라 실제 소요된 시간을 이용하여 AI 모델을 학습시킬 것입니다. 그러면 현재 날씨 및 사람의 신체적 특징에 따라 개인화된 소요시간을 사용자가 얻을 수 있습니다. 

### 프로젝트 설명
- 사용자 데이터는 제3자와 공유되지 않고 AI학습 데이터로만 사용됩니다. 
- 위치 정보는 Swift의 CoreLocation 라이브러리를 이용하여 디바이스의 내장된 GPS를 이용하여 사용자의 현재위치를 추적합니다.
  
1. 내비게이션 서비스를 위해 교내에 미리 200곳 정도의 위치(위도, 경도, 고도)를 기록해두었습니다.
2. 사용자가 1번 위치의 5m 이내에 접근하면 타이머를 시작합니다. 이후 2번 위치의 5m 이내에 접근하면 타이머를 종료하여 1번 위치부터 2번 위치까지의 소요시간을 측정합니다.
3. 사용자 정보(출생년도, 성별, 키, 몸무게, 걸음속도), 날씨(기온, 강수량, 강수확률), 소요시간, 두 개의 위치 ID를 서버에 전송합니다.
4. 서버에서 두 위치 ID의 위도, 경도, 고도를 이용해 위치 사이의 거리와 경사도를 구하고 전송 받은 데이터와 함께 DB에 저장합니다.
5. AI 모델 학습의 Input으로 '출생년도', '성별', '키', '몸무게', '걸음속도', '기온', '강수량', '강수확률', '거리', '경사도'를 사용합니다.
6.  AI 모델 학습의 Output으로 '실제 소요시간'을 사용하여 모델을 학습시킵니다.


## 개발 환경 및 기술 스택

- **프로그래밍 언어** : Swift
- **개발 도구** : Xcode
- **버전 관리** : Git, GitHub
- **커뮤니케이션 도구** : Notion
- **라이브러리 및 프레임워크** : SwiftUI, CoreLocation, Alamofire, NMapsMap
- **패키지 관리 도구** : CocoaPods
- **사용 API** : 기상청 단기예보 API

## 개발 기간 
### 2024.04.04 ~ 2024.04.29


## 성과
- 12명의 인원이 참여하여 801개의 데이터 수집.
- 이 데이터는 Gach.가자 앱의 AI 소요시간 예측 모델의 데이터를 활용됨

## 시연 영상 v1.0
### 👉 현재 v1.2
![RPReplay_Final1713705520-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/a1f6feb1-9c45-4eee-b7ef-61a49522724b)

![RPReplay_Final1713705520-ezgif com-video-to-gif-converter (1)](https://github.com/user-attachments/assets/9c44be25-d3fc-46fd-a585-6b26849dd657)


