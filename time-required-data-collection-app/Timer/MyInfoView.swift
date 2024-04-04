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
    
    @State private var userInfoSaved = false // 사용자 정보가 저장되었는지 여부를 나타내는 상태 변수
    
    // 입력 필드의 유효성을 확인하여 버튼을 활성화/비활성화할 수 있는 computed property
     var isButtonEnabled: Bool {
         // 모든 입력 필드가 비어있지 않고, 선택된 성별과 속도가 있다면 버튼을 활성화
         return birth != "" && height != "" &&  weight != ""
     }

    var body: some View {
        NavigationView {
            VStack{
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
                
                // NavigationLink를 사용하여 userInfoSaved가 true일 때 TimerView로 이동
                NavigationLink(
                    destination: TimerView(),
                    isActive: $userInfoSaved, // userInfoSaved가 true일 때 자동으로 TimerView로 이동
                    label: {
                        Button(action: {
                            saveUserInfo()
                            printUserInfo()
                            userInfoSaved = true
                        }, label: {
                            Text("데이터 수집 시작")
                        })
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .disabled(!isButtonEnabled) // 버튼을 비활성화할지 여부를 isButtonEnabled에 따라 결정
                    }
                )

            }
            
        }.onAppear(){
//            if let savedData = UserDefaults.standard.data(forKey: "userInfo") {
//                if let userInfo = try? JSONDecoder().decode(UserInfo.self, from: savedData) {
//                    print("Birth: \(userInfo.birth)")
//                    print("Height: \(userInfo.height)")
//                    print("Weight: \(userInfo.weight)")
//                    print("Sex: \(userInfo.sex)")
//                    print("Speed: \(userInfo.speed)")
//                    userInfoSaved = true
//                }
//            }
        }
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
