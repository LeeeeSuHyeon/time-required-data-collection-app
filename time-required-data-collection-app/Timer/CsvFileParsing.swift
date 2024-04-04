import SwiftUI

struct CsvFileParsing: View {
    // CSV 파일의 경로
    let csvFilePath = Bundle.main.path(forResource: "point", ofType: "csv")

    // CSV 파일을 읽어서 저장할 데이터 모델
    @State private var csvData: [[String]] = []

    var body: some View {
        VStack {
            // CSV 파일에서 읽은 데이터 표시
            List {
                ForEach(csvData, id: \.self) { row in
                    Text(row.joined(separator: ", "))
                }
            }
            .onAppear {
                // 파일에서 데이터 읽기
                if let filePath = csvFilePath {
                    do {
                        let csvString = try String(contentsOfFile: filePath)
                        csvData = parseCSV(csvString: csvString)
                    } catch {
                        print("Error reading CSV file: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // CSV 형식의 문자열을 파싱하여 2차원 배열로 반환
    func parseCSV(csvString: String) -> [[String]] {
        var csvData: [[String]] = []
        let rows = csvString.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            csvData.append(columns)
        }
        return csvData
    }
}

