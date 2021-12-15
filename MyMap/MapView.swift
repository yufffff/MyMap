//
//  MapView.swift
//  MyMap
//
//  Created by 深井裕貴 on 2021/07/19.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // 検索キーワード
    let searchKey: String
    // マップ種類
    let mapType: MKMapType
    // 表示するViewを作成する時に実行
    func makeUIView(context: Context) -> MKMapView {
        // MKMapViewのインスタンス生成
        MKMapView()
    }
    
    // 表示したViewが更新されるたびに実行
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 入力された文字をデバッグエリアに表示
        print(searchKey)
        
        // マップ種類の設定
        uiView.mapType = mapType
        // CLGeocoderインスタンスを取得
        let geocoder = CLGeocoder()
        
        // 入力された文字から位置情報を取得
        geocoder.geocodeAddressString(searchKey, completionHandler: {
            (placemarks, error) in
            // リクエストの結果が存在し、1件目の情報から位置情報を取り出す
            if let unwrapPlacemarks = placemarks ,
               let firstPlacemark = unwrapPlacemarks.first ,
               let location = firstPlacemark.location {
                
                // 位置情報から緯度経度をtargetCoodinateに取り出す
                let targetCoordinate = location.coordinate
                
                // 緯度経度をデバッグエリアに表示
                print(targetCoordinate)
                
                // MKPointAnnotationインスタンスを取得し、ピンを生成
                let pin = MKPointAnnotation()
                // ピンの置く場所に緯度経度を設定
                pin.coordinate = targetCoordinate
                // ピンのタイトルを設定
                pin.title = searchKey
                // ピンを地図に置く
                uiView.addAnnotation(pin)
                // 緯度経度を中心にして半径500mの範囲を表示
                uiView.region = MKCoordinateRegion(
                    center: targetCoordinate,
                    latitudinalMeters: 500.0,
                    longitudinalMeters: 500.0)
            }
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(searchKey: "博多", mapType: .standard)
    }
}
