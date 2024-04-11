

import UIKit
import CoreLocation

struct CsvFileParsing {
    // CSV 파일의 경로
    let csvFilePath: String?

    // CSV 파일을 읽어서 저장할 데이터 모델
    var csvData: [Node] = []
    var locationData : [CLLocation] = []

    // 초기화자
    init(fileName: String) {
        self.csvFilePath = Bundle.main.path(forResource: fileName, ofType: "csv")
        if let filePath = csvFilePath {
            do {
                let csvString = try String(contentsOfFile: filePath)
                csvData = parseCSV(csvString: csvString)
                initializeLocationData()
            } catch {
                print("Error reading CSV file: \(error.localizedDescription)")
            }
        } else {
            print("CSV file not found.")
        }
    }

    // CSV 형식의 문자열을 파싱하여 Node 배열로 반환
    private func parseCSV(csvString: String) -> [Node] {
        var csvData: [Node] = []
        let rows = csvString.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count >= 5, let latitude = Double(columns[0]), let longitude = Double(columns[1]) {
                let node = Node(latitude: latitude, longitude: longitude, name: columns[4])
                csvData.append(node)
            }
        }
        return csvData
    }
    
    // csvData를 이용하여 locationData 초기화
    private mutating func initializeLocationData() {
        locationData = csvData.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
    }
}


//
//import SwiftUI
//
//struct CsvFileParsing: View {
//    // CSV 파일의 경로
//    let csvFilePath = Bundle.main.path(forResource: "point", ofType: "csv")
//    let weather = WeatherExamView()
//
//    // CSV 파일을 읽어서 저장할 데이터 모델
//    @State private var csvData: [Node] = []
//    
//    var body: some View {
//        VStack {ㅁ
//            // CSV 파일에서 읽은 데이터 표시
//            List {
//                ForEach(csvData, id: \.self) { row in
//                    Text("\(row.id) \(row.name) \(row.latitude) \(row.longitude)")
//                }
//            }
//            .onAppear {
//                // 파일에서 데이터 읽기
//                if let filePath = csvFilePath {
//                    do {
//                        let csvString = try String(contentsOfFile: filePath)
//                        csvData = parseCSV(csvString: csvString)
//                    } catch {
//                        print("Error reading CSV file: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//
//    // CSV 형식의 문자열을 파싱하여 2차원 배열로 반환
//    func parseCSV(csvString: String) -> [Node] {
//        var csvData: [Node] = []
//        let rows = csvString.components(separatedBy: "\n")
//        for row in rows {
//            let columns = row.components(separatedBy: ",")
//            if columns[0] != "" {
//                let node = Node(latitude: Double(columns[0]) ?? 0, longitude: Double(columns[1]) ?? 0, id: Int(columns[2]) ?? 0, name: columns[3])
//                print(node)
//                csvData.append(node)
//            }
//        }
//        return csvData
//    }
//}
//
