//
//  TestView.swift
//  time-required-data-collection-app
//
//  Created by 이수현 on 4/22/24.
//

import SwiftUI

struct TestView: View {
    @State var isOn = false
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack{
                Button(action: {
                    isOn = true
                }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
                
                NavigationLink(destination: MyInfoView(), isActive: $isOn) {
                    EmptyView()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    TestView()
}
