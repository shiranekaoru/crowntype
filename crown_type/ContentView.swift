//
//  ContentView.swift
//  crown_type
//
//  Created by shirane kaoru on 2023/10/06.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var startFlag = false
    @State private var end = false
    @State private var startTime:Date = Date()
    @State private var CPM:String = ""
    @State var inputName = ""
    @ObservedObject private var connector = WatchConnector()
    var body: some View {
        VStack {
            
//            connector.data_print()
            Text(CPM)
                .bold()
            
//            Button(action: {
//                if !startFlag{
//                    startTime = Date()
//                    startFlag = true
//                    
//                }else{
//                    startFlag = false
//                    let timeInterval = Date().timeIntervalSince(startTime)
//                    let time = Int(timeInterval)
//
//                    let d = time / 86400
//                    let h = time / 3600 % 24
//                    let m = time / 60 % 60
//                    let s = time % 60
//
//                    // ミリ秒
//                    let ms = Int(timeInterval * 100) % 100
//
//                    CPM = String(format: "%d日%d時間%d分%d.%d秒", d, h, m, s, ms)
//                }
//            }){
//                Text("Next")
//                    .bold()
//                    .padding()
//                    .frame(width:100,height:50)
//                    .foregroundColor(Color.blue)
//                    .border(Color.red,width:3)
//            }
            
            

            

            
        }
        .padding()
    }
}

class CSVFileManager{
    
    var filename: String
    var fileManager: FileManager
    
    var folder_name = "crown_type"
    //初期化:filenameのファイルがなかった場合新たにファイルを作製
    init(filename: String) {
        //fileの設定
        self.filename = filename
        fileManager = FileManager.default
        let docPath = NSHomeDirectory() + "/Documents/" + folder_name
        let filePath = docPath + "/" + self.filename
        //csvデータに書き込むデータを定義
        let csv = "CPM,TER\r\n"
        let data = csv.data(using: .utf8)
        
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: docPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            // エラーの場合
    
        }
        //ファイルが存在するかチェック
        if !fileManager.fileExists(atPath: filePath){
            fileManager.createFile(atPath: filePath, contents:data,attributes: [:])
        }else{
            print("すでに存在します")
        }
    }
    
    //csvファイル書き込み
    func write(content: String){
        let path = NSHomeDirectory() + "/Documents/" + folder_name + "/" + self.filename
        let old_datas = self.read()
        let datas = old_datas + content
        do{
            try datas.write(toFile: path, atomically: true,encoding: .utf8)
        }catch{
            print("failure")
        }
        
    }
    
    //csvファイル読み込み
    func read() -> String{
        
        let path = NSHomeDirectory() + "/Documents/" + folder_name + "/" + self.filename
        
        do{
            let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return csvString
        }catch let error as NSError{
            print("エラー：\(error)")
            return ""
        }
    }
    
}


class WatchConnector: NSObject,ObservableObject,WCSessionDelegate{
    @Published var receivedMessage = ""
    @Published var timestamp = "0.0"
    @Published var count = 0
    @Published var file_name = ""
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("didReceiveMessage: \(message)")
//        var str = String(message["COUNT"])
        let file_name = "layout3_pra.csv"
        let file = CSVFileManager(filename: file_name)
        DispatchQueue.main.async {
            
            //csvファイルに書き込むために文字列を作成
            self.receivedMessage += "\(message["CPM"] as! String),"
            self.receivedMessage += "\(message["TER"] as! Double),"
//            self.count = message["WA"] as! Int
//            file.write(content:self.receivedMessage)
            print(self.receivedMessage)
            file.write(content:self.receivedMessage)
        }
    }
    
    //iPhoneに出力させる関数
    func data_print()->Text{
//        addfile(datas:self.receivedMessage)
        return Text(self.receivedMessage)
    }
}
