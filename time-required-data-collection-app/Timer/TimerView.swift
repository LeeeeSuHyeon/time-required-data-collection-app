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
    
    @ObservedObject var cLocation = CLocation()
//    @ObservedObject var cLocation : CLLocation?
    
    @State var time : Int = 0
    
    let route = PathData().test

    
    let csv = CsvFileParsing(fileName: "point")
    var nodes : [Node] {
        csv.csvData
    }

    var body: some View {
        if cLocation.location != nil && nodes != []{
            Text("노드 간 소요시간 확인 : \(time)")
            
            VStack{
                ForEach(0..<cLocation.timeList.count, id: \.self) { index in
                    Text("노드 \(index) - 노드\(index + 1): \(self.cLocation.timeList[index])초")
                        .onAppear(){
                            if index != 0 {
                                let param = TimerRequest(
                                    point1_x: Double(route[index - 1].coordinate.latitude),
                                    point1_y: Double(route[index - 1].coordinate.longitude),
                                    point2_x: Double(route[index].coordinate.latitude),
                                    point2_y: Double(route[index].coordinate.longitude),
                                    takeTime: Double(self.cLocation.timeList[index])
                                )
                                print("param \(param)")
                                postData(parameter : param)
                            }
                        }
                    
                    if(route.count - 1 == index){
                        Text("모든 노드 종료")
                            .onAppear(){
                                let param = TimerRequest(
                                    point1_x: Double(route[index - 1].coordinate.latitude),
                                    point1_y: Double(route[index - 1].coordinate.longitude),
                                    point2_x: Double(route[index].coordinate.latitude),
                                    point2_y: Double(route[index].coordinate.longitude),
                                    takeTime: Double(self.cLocation.timeList[index])
                                )
                                print("param \(param)")
                                postData(parameter : param)
                            
                            }
                    }
                    
                }
                .padding()
            }
            .onReceive(cLocation.timer.$seconds) { second in
                self.time = second
            }
            
            Spacer()
            TimerMap(coreLocation: cLocation, nodes : nodes)
                .frame(height: 400)
                .edgesIgnoringSafeArea(.bottom)
                
        }
    }
    
    func postData(parameter : TimerRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "https://fd54-210-119-237-65.ngrok-free.app/saveTime") else {
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
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
}

#Preview {
    TimerView()
}
