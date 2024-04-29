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
    
    @State var isReadyWeather = false
    @State private var showAlert = false // 상태 변수 추가
    @State var endButton = false    // 수집 종료 버튼
    let width = UIScreen.main.bounds.width / 3.6
    
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
                isReadyWeather = true
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
            if !isReadyWeather {
                ProgressView()
                    .onAppear(){
                        fetchWeather()
                    }
            }
            else{
                if weather != nil{
                    HStack(spacing : 20){
                        Text("기온: \(Int(weather?.temperature ?? 0))도")
                        Text("강수량: \(String(format: "%.1f", weather?.precipitation ?? 0))mm")
                        Text("강수확률: \(Int(weather?.precipitationProbability ?? 0))%")
                    }
                    .padding()
                    .border(.gray)
                    
                    Text("데이터 측정 개수: \(count)개")
                        .padding()

                    Text("소요 시간: \(time)초")
                        .padding(.bottom, 10)
                

                    ScrollView{
                        VStack(alignment: .leading, spacing: 0){
                            // 헤더 행
                            HStack {
                                Text("출발노드")
                                    .bold()
                                    .frame(width: width, height: 30)
                                    .padding(.horizontal, 5)
                                    .border(Color.black)
                                    .background(.gray.opacity(0.3))
                                Text("도착노드")
                                    .bold()
                                    .frame(width: width, height: 30)
                                    .padding(.horizontal, 5)
                                    .border(Color.black)
                                    .background(.gray.opacity(0.3))
                                Text("소요시간")
                                    .bold()
                                    .frame(width: width, height: 30)
                                    .padding(.horizontal, 5)
                                    .border(Color.black)
                                    .background(.gray.opacity(0.3))

                            }
                            
                            ForEach(timeList, id: \.self) { list in
                                HStack{
                                    CellView(content: list.node1, width: width)
                                    CellView(content: list.node2, width: width)
                                    CellView(content: "\(list.takeTime)초", width: width)
                                }
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
                            } // end of ForEach
                        } // end of VStack
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding()
                        .border(.gray)
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


struct CellView: View {
    let content: String
    let width: CGFloat
    
    var body: some View {
        Text(content)
            .font(.system(size: 12))
            .frame(width: width, height: 30)
            .padding(.horizontal, 5)
            .border(Color.black)
    }
}
