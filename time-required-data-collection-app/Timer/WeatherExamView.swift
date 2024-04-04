//
//  WeatherExamView.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/4/24.
//

import SwiftUI
import Alamofire


struct WeatherExamView: View {
    let key = "Q1UlVchU%2BjoTRx0JMz1%2F9P4x%2BVVo5o%2FpfmTSLmb3ubV9Kk%2FtFcpTI7J%2Fy4bfoXpra17LrAVL5nMR%2Br6UVv8VNg%3D%3D"
    let date = Date()
    let dateFormatter = DateFormatter()
    var baseDate: String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    var baseTime: String {
//        dateFormatter.dateFormat = "HHmm"
//        return dateFormatter.string(from: date)
        return "1700"
    }
    var latXlngY = convertGRID_GPS(mode: 0, lat_X: 37.455086, lng_Y: 127.133315)
    
    var requestURL : String { "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?seviceKey=\(key)&numOfRows=10&pageNo=1&base_date=\(baseDate)&base_time=\(baseTime)&nx=\(latXlngY.x)&ny=\(latXlngY.y)"
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear(){
                WeatherDataRequest()
            }
    }
    
    func WeatherDataRequest() {
        print("requestURL : \(requestURL)")
        
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get).responseString { response in
            // 에러 처리
            switch response.result {
            case .success(let value):
                // 성공적인 응답 처리
                print("성공")
                print("value : \(value)")
                let data = value.data(using: .utf8)
                let parser = XMLParser(data: data!)
                let delegate = MyXMLParserDelegate()
                parser.delegate = delegate
                parser.parse()
                
            
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    WeatherExamView()
}
