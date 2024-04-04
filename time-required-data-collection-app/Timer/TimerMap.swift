//
//  NaverMap.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/02.
//

import SwiftUI
import NMapsMap


struct TimerMap: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation: CLocation
    let route : [CLLocation]
    
    var body: some View {
        TimerMapView(coreLocation : coreLocation, route: route)
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                print("TimerMapView Called - coreLocation \(String(describing: coreLocation.location))")
            }
    }
}



struct TimerMapView: UIViewRepresentable {
    
    @ObservedObject var coreLocation: CLocation
    let route : [CLLocation]
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let mapView = NMFNaverMapView() // 지도 객체 생성
        
        mapView.showCompass = true // 나침반
        mapView.showScaleBar = true // 축척 바
        mapView.showZoomControls = true // 줌 버튼
        mapView.showLocationButton = true // 현위치 버튼
        
        let marker = NMFMarker() // 마커 설정
        marker.position = NMGLatLng(lat: route[0].coordinate.latitude, lng: route[0].coordinate.longitude) // 마커 위치 지정
        marker.mapView = mapView.mapView // 마커를 표시할 뷰 지정
        // marker.mapView = nil  // 제거
        
        // 마커 이미지 지정
        let marker1 = NMFMarker()
        marker1.position = NMGLatLng(lat: route[route.count - 1].coordinate.latitude, lng: route[route.count - 1].coordinate.longitude)
//        marker1.iconImage = NMFOverlayImage(name: "image_name")
        marker1.iconImage = NMF_MARKER_IMAGE_RED    // 마커 아이콘 빨간색으로 지정
        marker1.mapView = mapView.mapView
        
        
        // 경로 표시
        let pathOverlay = NMFPath()
        
        
//        pathOverlay.path = NMGLineString(points: [
//            NMGLatLng(lat: 37.450501, lng: 127.129618), // 가천관 입구
//            NMGLatLng(lat: 37.450864, lng: 127.129756),   // 가천관 대각 쪽
//            NMGLatLng(lat: 37.450912, lng: 127.130210), // 가천관 옆 입구 삼거리 앞
//            NMGLatLng(lat: 37.451217, lng: 127.130801), // 오르막 쪽
//            NMGLatLng(lat: 37.451869, lng: 127.131138),  // 동산 삼거리 횡단보드 전
//            NMGLatLng(lat: 37.451834, lng: 127.131236), // 횡단보드 건너고
//            NMGLatLng(lat: 37.452233, lng: 127.131658), // 교대 앞
//            NMGLatLng(lat: 37.452656, lng: 127.132799), // 중도 앞
//            NMGLatLng(lat: 37.452468, lng: 127.132850) // 중도 입구
//        ])
        
        var pathPoints: [NMGLatLng] = []
        for location in route {
            let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            pathPoints.append(latLng)
        }


        pathOverlay.path = NMGLineString(points: pathPoints)
        
        
        
        pathOverlay.width = 5 // 경로 두께 설정
        pathOverlay.outlineWidth = 2.5 // 테두리 두께
        
        pathOverlay.patternIcon = NMFOverlayImage(name: "path_pattern") // 경로 패턴 지정
        pathOverlay.patternInterval = 5 // 패턴 간격 (0일 경우 그려지지 않음)
        
        pathOverlay.progress = 0.5 // 진척률 50%로 지정하는 예제
        
        pathOverlay.color = UIColor.green // 지나갈 경로 녹색
        pathOverlay.passedColor = UIColor.gray // 지나온 경로 회색

        pathOverlay.mapView = mapView.mapView

//        pathOverlay.mapView = nil // 경로 삭제
        
        
        // 위치 정보가 제대로 전달되었는지 확인하고 전달된 경우에만 위도와 경도를 사용합니다.
        if let location = coreLocation.location {
            let latitude = location.coordinate.latitude // 현재 위도
            let longitude = location.coordinate.longitude // 현재 경도
            
            mapView.mapView.locationOverlay.hidden = true // 위치 오버레이 활성화
            mapView.mapView.locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude) // 현재위치로 오버레이 설정
            mapView.mapView.positionMode = .compass // 위치 추적 활성화, 현위치 오버레이, 카메라 좌표, 헤딩이 사용자 위치 및 방향을 따라 움직임
            
            let cameraUpdate =  NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude)) // 현재 위치로 카메라 위치 변경,
            mapView.mapView.moveCamera(cameraUpdate)
            print("position : ", coreLocation.location)
            

        }
        
        return mapView
    }

    func updateUIView(_ mapView: NMFNaverMapView, context: Context) {
        
    }
}
