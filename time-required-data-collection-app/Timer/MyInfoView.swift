//
//  MyInfo.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/4/24.
//

import SwiftUI

struct MyInfoView: View {
    @State var birth : String = ""
    @State var height : String = ""
    @State var weight : String = ""
    
    @State private var selectedSexIndex = 0
    private let sex = ["남성", "여성"]
    
    @State private var selectedSpeedIndex = 0
    private let speed = ["느림", "보통", "빠름"]
    
    var body: some View {
    
        VStack(alignment: .leading){
            Text("출생년도")
            TextField(text: $birth){
                Text("출생년도")
            }
            .frame(width: 200, height: 40)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
            
        }
        .padding()
        
        HStack{
            VStack(alignment: .leading){
                Text("키")
                TextField(text: $height){
                    Text("키")
                }
                .frame(width: 100, height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            }
            .padding()
    
            
            VStack(alignment: .leading){
                Text("몸무게")
                TextField(text: $weight){
                    Text("몸무게")
                }
                .frame(width: 100, height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            }
            .padding()
    
        }
        VStack {
            Picker(selection: $selectedSexIndex, label: Text("")) {
                ForEach(0..<sex.count) { index in
                    Text(self.sex[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        VStack {
            Picker(selection: $selectedSpeedIndex, label: Text("")) {
                ForEach(0..<speed.count) { index in
                    Text(self.speed[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        
        
        Button(action: {
            saveUserInfo()
            printUserInfo()
        }, label: {
            Text("데이터 수집 시작")
        })
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
    func saveUserInfo() {
        // UserDefaults를 사용하여 사용자가 입력한 정보를 저장
        let userInfo = UserInfo(birth: birth, height: height, weight: weight, sex: sex[selectedSexIndex], speed: speed[selectedSpeedIndex])
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: "userInfo")
        }
    }
    
    func printUserInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "userInfo") {
            if let userInfo = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
                print("Birth: \(userInfo.birth)")
                print("Height: \(userInfo.height)")
                print("Weight: \(userInfo.weight)")
                print("Sex: \(userInfo.sex)")
                print("Speed: \(userInfo.speed)")
            }
        } else {
            print("User info not found in UserDefaults")
        }
    }

}



#Preview {
    MyInfoView()
}
