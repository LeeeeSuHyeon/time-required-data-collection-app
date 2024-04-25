//
//  TimerView.swift
//  Location_Example
//
//  Created by 이수현 on 3/29/24.
//

import SwiftUI
import Alamofire
import CoreLocation

struct TimerView: View {
    
    @ObservedObject var cLocation: CLocation
    @ObservedObject var weatherExamView = WeatherExamView()
    
    @State var time : Int = 0
    @State var timeList : [NodeTime] = []
    
    @State var weather: Weather?
    @State var count = 0
    
    @State private var showAlert = false // 상태 변수 추가
    @State var endButton = false    // 수집 종료 버튼
    
    init(){
        cLocation = CLocation()
    }
    
    // Weather 데이터를 가져오는 함수 호출
    func fetchWeather() {
        weatherExamView.WeatherDataRequest { newWeather in
            if let newWeather = newWeather {
              self.weather = newWeather
              print("weather: \(newWeather)")
              print("userInfo: \(String(describing: userInfo))")
          }
        }
    }
    
    var userInfo : UserInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "userInfo") {
            if let userInfo = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
                print("TimerView - UserInfo Success")
                return userInfo
            } else {return nil}
        } else {
            print("TimerView - UserInfo Failure")
            return nil
        }
    }
    
    let csv = CsvFileParsing(fileName: "point3")
    var nodes : [Node] {
        csv.csvData
    }

    var body: some View {
        if cLocation.location != nil && nodes != [] {
            Text("노드 간 소요시간 확인 : \(time)")
                .onAppear(){
                    fetchWeather()
                }
            if weather != nil{
                Text("기온: \(Int(weather?.temperature ?? 0))도, 강수량: \(String(format: "%.1f", weather?.precipitation ?? 0))mm, 강수 확률: \(Int(weather?.precipitationProbability ?? 0))%")
                Text("데이터 측정 개수(DB 저장 성공) : \(count)개")
//                Text("강수량 : \(weather?.precipitation ?? 0)")
//                Text("강수확률 : \(weather?.precipitationProbability ?? 0)")
//                Text("위도 : \(String(cLocation.location!.coordinate.latitude))")
//                Text("경도 : \(String(cLocation.location!.coordinate.longitude))")
//                Text("고도 : \(String(cLocation.location!.altitude))")
                ScrollView{
                    VStack{
                        ForEach(timeList, id: \.self) { list in
                            Text("\(list.node1) - \(list.node2): \(list.takeTime)초")
                                .onAppear(){
                                    if timeList.count > 1{
                                        let param = saveTimeRequest(
                                            node1: list.node1,
                                            node2: list.node2,
                                            birthYear: userInfo?.birthYear ?? 0,
                                            gender: userInfo?.gender ?? 0,
                                            height: Double(userInfo?.height ?? 0),
                                            weight: Double(userInfo?.weight ?? 0),
                                            walkSpeed: userInfo?.walkSpeed ?? 0,
                                            temperature: weather?.temperature ?? 0,
                                            precipitationProbability: weather?.precipitationProbability ?? 0,
                                            precipitation: weather?.precipitation ?? 0,
                                            takeTime: Double(list.takeTime)
                                        )
                                        print("param \(param)")
                                        postData(parameter : param)
                                    }
                                } // end of onAppear()
                                .padding()
                        } // end of ForEach
                    } // end of VStack
                    .onReceive(cLocation.timer.$seconds) {second in
                        self.time = second
                    }
                    .onReceive(cLocation.$timeList){ timeList in
                        self.timeList = timeList
                    }
                } // end of ScrollView
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("서버 연결 실패"), message: Text("서버에 연결할 수 없습니다."), dismissButton: .default(Text("확인")))
                }
                .alert(isPresented: $endButton) {
                    Alert(
                        title: Text("데이터 수집 종료"),
                        message: Text("데이터 수집에 도움을 주셔서 감사드립니다.\n\n종료하시겠습니까?"),
                        primaryButton: .default(Text("확인")) {
                            cLocation.locationManager.stopUpdatingLocation()
                            cLocation.stopTimer()
                        },
                        secondaryButton: .cancel(Text("취소")) // 취소 버튼
                    )
                }
                .navigationTitle("데이터 수집")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("수집 종료") {
                            endButton = true
                            print(endButton)
                        }
                    }
                }
        } // end of if weather != nil
        else{
            ProgressView(label: {
                Text("날씨 데이터 불러오는 중")
            })
        }
              
        Spacer()
        TimerMap(coreLocation: cLocation, nodes : nodes)
            .frame(height: 300)
            .edgesIgnoringSafeArea(.bottom)

        } // end of if
        else{
            ProgressView(label: {
                Text("위치 서비스 활성화 중")
            })
                .onAppear(){
                    cLocation.setupLocationManager()
                }
        }
    } // end of body
    
    func postData(parameter : saveTimeRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/api/data/get") else {
            print("Invalid URL")
            return
        }
        
        // Alamofire를 사용하여 post 요청 생성
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default).responseString { response in
            // 에러 처리
            switch response.result {
            case .success(let value):
                // 성공적인 응답 처리
//                self.responseData = value
                print("성공")
                count += 1
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
                showAlert = true
            } // end of switch
        } // end of AF.request
    } // end of postData()
} // end of TimerView()
