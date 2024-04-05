//
//  MyInfo.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/4/24.
//

import SwiftUI

struct MyInfoView: View {
    @State private var birthYear = 2000
    @State private var height = 173
    @State private var weight = 65
    
    @State private var selectedGenderIndex = 0
    private let gender = ["남성", "여성"]
    
    @State private var selectedSpeedIndex = 0
    private let speed = ["느림", "보통", "빠름"]
    
    @State private var userInfoSaved = false // 사용자 정보가 저장되었는지 여부를 나타내는 상태 변수
    
    // 입력 필드의 유효성을 확인하여 버튼을 활성화/비활성화할 수 있는 computed property
//    var isButtonEnabled: Bool {
//        // 모든 입력 필드가 비어있지 않고, 선택된 성별과 속도가 있다면 버튼을 활성화
//        return birth != "" && height != "" &&  weight != ""
//    }

    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading){
                    Text("출생년도")
                    Picker("출생년도", selection: $birthYear) {
                        ForEach(1900..<2024, id: \.self) { year in
                            Text("\(year)")
                        }
                    }
                    .frame(width: 200, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                    
                }
                .padding()
                
                HStack{
                    VStack(alignment: .leading){
                        Text("키")
                        Picker("키", selection: $height) {
                            ForEach(100..<250, id: \.self) { height in
                                Text("\(height) cm")
                            }
                        }
                        .frame(width: 100, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    }
                    .padding()
                    
                    
                    VStack(alignment: .leading){
                        Text("몸무게")
                        Picker("몸무게", selection: $weight) {
                            ForEach(30..<200, id: \.self) { weight in
                                Text("\(weight) kg")
                            }
                        }
                        .frame(width: 100, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    }
                    .padding()
                    
                }
                VStack {
                    Picker(selection: $selectedGenderIndex, label: Text("성별")) {
                        ForEach(0..<gender.count) { index in
                            Text(self.gender[index]).tag(index)
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
                
                // NavigationLink를 사용하여 userInfoSaved가 true일 때 TimerView로 이동
                Button(action: {
                    saveUserInfo()
                    printUserInfo()
                    userInfoSaved = true
                }) {
                    Text("데이터 수집 시작")
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .background(NavigationLink(
                    destination: TimerView(),
                    isActive: $userInfoSaved, // userInfoSaved가 true일 때 자동으로 TimerView로 이동
                    label: { EmptyView() }
                ))

            }
        }
    }
    
    func saveUserInfo() {
        // UserDefaults를 사용하여 사용자가 입력한 정보를 저장
        let userInfo = UserInfo(birthYear: birthYear, height: height, weight: weight, gender: selectedGenderIndex, walkSpeed: selectedSpeedIndex)
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: "userInfo")
        }
    }
    
    func printUserInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "userInfo") {
            if let userInfo = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
                print("Birth: \(userInfo.birthYear)")
                print("Height: \(userInfo.height)")
                print("Weight: \(userInfo.weight)")
                print("Gender: \(userInfo.gender)")
                print("Speed: \(userInfo.walkSpeed)")
            }
        } else {
            print("User info not found in UserDefaults")
        }
    }

}



#Preview {
    MyInfoView()
}
