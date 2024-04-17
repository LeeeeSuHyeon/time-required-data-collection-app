//
//  WeatherExamView.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/4/24.
//
//
import UIKit
import Alamofire


class WeatherExamView : ObservableObject {
    
    let key = "Q1UlVchU%2BjoTRx0JMz1%2F9P4x%2BVVo5o%2FpfmTSLmb3ubV9Kk%2FtFcpTI7J%2Fy4bfoXpra17LrAVL5nMR%2Br6UVv8VNg%3D%3D"
    let date = Date()
    let dateFormatter = DateFormatter()
    
    
    var baseDate: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        // 오전 12시 (0시)부터 02시 10분까지는 하루 전의 날짜로 반환
        if hour == 0 || (hour == 2 && minute <= 10) {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: date)!
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: yesterday)
        }
        
        // 그 외의 경우는 현재 날짜를 반환
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }

    
    var baseTime: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if hour < 2 || hour == 2 && minute < 10 {
            return "2300"
        } else if hour < 5 || (hour == 5 && minute < 10)  {
            return "0200"
        } else if hour < 8 || (hour == 8 && minute < 10) {
            return "0500"
        } else if hour < 11 || (hour == 11 && minute < 10) {
            return "0800"
        } else if hour < 14 || (hour == 14 && minute < 10) {
            return "1100"
        } else if hour < 17 || (hour == 17 && minute < 10) {
            return "1400"
        } else if hour < 20 || (hour == 20 && minute < 10) {
            return "1700"
        } else if hour < 23 || (hour == 23 && minute < 10) {
            return "2000"
        } else{
            return "2300"
        }
    }

    var latXlngY = convertGRID_GPS(mode: 0, lat_X: 37.455086, lng_Y: 127.133315)
    
    var requestURL : String { "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(key)&pageNo=1&numOfRows=10&base_date=\(baseDate)&base_time=\(baseTime)&nx=\(latXlngY.x)&ny=\(latXlngY.y)"
    }
    
    func WeatherDataRequest(completion: @escaping (Weather?) -> Void){
        
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        print(url)
        
        AF.request(url, method: .get).responseString {response in
            // 에러 처리
            switch response.result {
                case .success(let value):
                    // 성공적인 응답 처리
                    print("성공")
                    print("value : \(value)")
                    let data = value.data(using: .utf8)
                    let parser = XMLParser(data: data!)
                    var temperature = 0.0
                    var precipitationProbability = 0.0
                    var precipitation = 0.0
                    let delegate = MyXMLParserDelegate(completion: { items in
                        for (key, value) in items {
                            if key == "TMP" {
                                if let doubleValue = Double(value) {
                                    temperature = doubleValue
                                }
                            } else if key == "POP" {
                                if let doubleValue = Double(value) {
                                    precipitationProbability = doubleValue
                                }
                            } else if key == "PCP" {
                                let newValue = String(value.dropLast(3))
                                print(newValue) // 출력: "1"
                                if let doubleValue = Double(newValue) {
                                    precipitation = doubleValue
                                }
                            }
                        }
                    })
                    parser.delegate = delegate
                    parser.parse()
                    let weather = Weather(temperature: temperature,
                                         precipitationProbability: precipitationProbability,
                                         precipitation: precipitation)
                   completion(weather)
    
            
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

//import SwiftUI
//import Alamofire
//
//
//struct WeatherExamView: View {
//    let key = "Q1UlVchU%2BjoTRx0JMz1%2F9P4x%2BVVo5o%2FpfmTSLmb3ubV9Kk%2FtFcpTI7J%2Fy4bfoXpra17LrAVL5nMR%2Br6UVv8VNg%3D%3D"
//    let date = Date()
//    let dateFormatter = DateFormatter()
//    var baseDate: String {
//        dateFormatter.dateFormat = "yyyyMMdd"
//        return dateFormatter.string(from: date)
//    }
//    var baseTime: String {
////        dateFormatter.dateFormat = "HHmm"
////        return dateFormatter.string(from: date)
//        return "1700"
//    }
//    var latXlngY = convertGRID_GPS(mode: 0, lat_X: 37.455086, lng_Y: 127.133315)
//    
////    var requestURL = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=Q1UlVchU%2BjoTRx0JMz1%2F9P4x%2BVVo5o%2FpfmTSLmb3ubV9Kk%2FtFcpTI7J%2Fy4bfoXpra17LrAVL5nMR%2Br6UVv8VNg%3D%3D&pageNo=1&numOfRows=10&dataType=XML&base_date=20240405&base_time=1700&nx=63&ny=124"
//    
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            .onAppear(){
//                WeatherDataRequest()
//            }
//    }
//    
//    func WeatherDataRequest() {
//        
//        var requestURL = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=\(key)&pageNo=1&numOfRows=10&dataType=XML&base_date=\(baseDate)&base_time=\(baseTime)&nx=63&ny=124"
//        
//        
//        
//        // API 요청을 보낼 URL 생성
//        guard let url = URL(string: requestURL) else {
//            print("Invalid URL")
//            return
//        }
//        print(url)
//        AF.request(url, method: .get).responseString { response in
//            // 에러 처리
//            switch response.result {
//            case .success(let value):
//                // 성공적인 응답 처리
//                print("성공")
//                print("value : \(value)")
//                let data = value.data(using: .utf8)
//                let parser = XMLParser(data: data!)
//                let delegate = MyXMLParserDelegate()
//                parser.delegate = delegate
//                parser.parse()
//                let items : [String : String] = delegate.items
//                
//                var temperature = 0.0
//                var precipitationProbability = 0.0
//                var precipitation = 0.0
//                for key in items.keys {
//                    if key == "TMP" {
//                        if let value = items[key], let doubleValue = Double(value) {
//                            temperature = doubleValue
//                        }
//                    } else if key == "POP" {
//                        if let value = items[key], let doubleValue = Double(value) {
//                            precipitationProbability = doubleValue
//                        }
//                    } else if key == "PCP" {
//                        if let value = items[key], let doubleValue = Double(value) {
//                            precipitation = doubleValue
//                        }
//                    }
//                }
//                print(temperature, precipitationProbability, precipitation)
//                
//                
//            
//            case .failure(let error):
//                // 에러 응답 처리
//                print("Error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//#Preview {
//    WeatherExamView()
//}
