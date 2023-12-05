//
//  ContentView.swift
//  crown_type Watch App
//
//  Created by shirane kaoru on 2023/10/06.
//

import SwiftUI
import Foundation
import WatchConnectivity

struct StartListView: View {
    @State private var Rotation_Dir = false
    @State private var Vive = false

    @State private var CROWN_CNT = 15.0
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(
                    destination: ConfigView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT,Vive:$Vive),
                    label: {Text("config")})
                NavigationLink(
                    destination: DemoView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT,Vive:$Vive),
                    label: {Text("demo")})
                NavigationLink(
                    destination: PracticeView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT,Vive:$Vive),
                    label: {Text("practive")})
                NavigationLink(
                    destination: TestView(Rotation_Dir: $Rotation_Dir, CROWN_CNT: $CROWN_CNT),
                    label: {Text("test")})
            }.navigationTitle("Option")
        }
    }
}



var crownAcc = 0.0
var crownOffset = 0.0
var crownOldOffset = 0.0
var Diff = 0.0
var crownSpeed = 0.0
var upperFlag = false
var downFlag = false
var DeleteFlag = false
var DirFlag = false
var OntimeDirFlag = false
var changeDir = false
var startFlag = false
var end = false
var startTime:Date = Date()


//     var vowels:[String] = ["あ","か","さ","た","な","は","ま","や","ら","わ"]
var vowels:[String] = ["あ行","か行","さ行","た行","な行","は行","ま行","や行","ら行","わ行","\",゜"]
var consonant: [[String]] = [
    ["あ行","あ","い","う","え","お"],
    ["か行","か","き","く","け","こ"],
    ["さ行","さ","し","す","せ","そ",""],
    ["た行","た","ち","つ","て","と"],
    ["な行","な","に","ぬ","ね","の"],
    ["は行","は","ひ","ふ","へ","ほ"],
    ["ま行","ま","み","む","め","も"],
    ["や行","や","ゆ","よ"],
    ["ら行","ら","り","る","れ","ろ"],
    ["わ行","わ","を","ん"],
    ["\",゜","\"","゜","小"]
//        ["あ","い","う","え","お"],
//        ["か","き","く","け","こ"],
//        ["さ","し","す","せ","そ"],
//        ["た","ち","つ","て","と"],
//        ["な","に","ぬ","ね","の"],
//        ["は","ひ","ふ","へ","ほ"],
//        ["ま","み","む","め","も"],
//        ["や","ゆ","よ"],
//        ["ら","り","る","れ","ろ"],
//        ["わ","を","ん"],
//        ["゛","゜"]
]

var dakuon: [[String:String]] = [
    ["か":"が","き":"ぎ","く":"ぐ","け":"げ","こ":"ご"],
    ["さ":"ざ","し":"じ","す":"ず","せ":"ぜ","そ":"ぞ"],
    ["た":"だ","ち":"ぢ","つ":"づ","て":"で","と":"ど"],
    ["は":"ば","ひ":"び","ふ":"ぶ","へ":"べ","ほ":"ぼ"]
]

var handakuon: [String:String] = ["は":"ぱ","ひ":"ぴ","ふ":"ぷ","へ":"ぺ","ほ":"ぽ"]




let CROWN_CNT = 15

struct ConfigView: View{
    
    @Binding var Rotation_Dir: Bool
    @Binding var CROWN_CNT: Double
    @Binding var Vive:Bool
    var body: some View{
    
        List{
            Toggle("Rotation Dir", isOn: $Rotation_Dir)
            Toggle("触覚フィードバック", isOn: $Vive)
            Text("回転感度:\(CROWN_CNT)")
            Slider(value: $CROWN_CNT, in:15...25, step:1)
            
            
        }.navigationTitle("config")
    }
    
}

struct DemoView:View{
    @Binding var Rotation_Dir: Bool
    @Binding var CROWN_CNT: Double
    @Binding var Vive:Bool
    @State private var crownValue = 0.0
    @State private var v_cnt = 0
    @State private var c_cnt = 0
    @State private var cnt = 0
    @State private var enter_text = ""
    @State private var phrase_cnt = 0
    @State private var enter_vowels = ""
    @State var dateText = ""
    @State var TER:Double = 0.0
    @State var delete_cnt:Int = 0
    @State var CPM:String = ""
    
    func knock(type: WKHapticType?){
        guard let hType = type else{return}
        WKInterfaceDevice.current().play(hType)
    }
    
   
    
    var body: some View {
        VStack {
            
            
            //入力欄に入力文字がない
            

            

            TabView(){
                VStack(spacing:20){
                    VStack{
                        Text(enter_text)
                            .font(.system(size:18,weight:.black,design:.default))
                            .border(Color.blue)
                            .frame(maxWidth:.infinity,alignment:.leading)
                        
                    }.position(x: 88, y: 10)
                        
                    
                    VStack(spacing: 20){
                        if v_cnt + 1 == vowels.count{
                            Text("\(vowels[0])").font(.system(size:18,weight:.black,design:.default))
                        }else{
                            Text("\(vowels[v_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                        }
                        
                        
                        if downFlag || (!upperFlag && !downFlag){
                            Text("\(vowels[v_cnt])").font(.system(size:28,weight:.black,design:.default))
                        }else{
                            Text("\(consonant[v_cnt][c_cnt])").font(.system(size:28,weight:.black,design:.default))
                        }
                        if c_cnt + 1 == consonant[v_cnt].count{
                            Text("\(consonant[v_cnt][0])").font(.system(size:18,weight:.black,design:.default))
                        }else{
                            Text("\(consonant[v_cnt][c_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                        }
                        
                    }.position(x: 88, y: 20)


                }
                
                //1key layout
                VStack(spacing: 20){
                    VStack{
                        Text(enter_text)
                            .font(.system(size:18,weight:.black,design:.default))
                            .border(Color.blue)
                            .frame(maxWidth:.infinity,alignment:.leading)
                        
                    }.position(x: 88, y: 10)
                    
                    VStack(spacing: 20){
                        if downFlag || (!upperFlag && !downFlag){
                            Text("\(vowels[v_cnt])").font(.system(size:30,weight:.black,design:.default))
                        }else{
                            Text("\(consonant[v_cnt][c_cnt])").font(.system(size:30,weight:.black,design:.default))
                        }
                    }.position(x: 88, y: 20)
                    

                }
                
                //0key layout
                VStack(spacing: 20){
                    VStack{
                       
                        
                        if downFlag || (!upperFlag && !downFlag){
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(vowels[v_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.blue)
                            }.frame(maxWidth:.infinity,alignment:.leading)
                        }else{
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(consonant[v_cnt][c_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.red)
                            }.frame(maxWidth:.infinity,alignment:.leading)

                        }
                    }.border(Color.blue)
                        .frame(width:150,height:50,alignment: .topLeading)
                        .position(x:88,y:18)


                }
                
                
                
                
                VStack{
                    TextField("Enter world", text:$enter_text)
                }
            }

        }
        .focusable()
        
        .digitalCrownRotation($crownValue,from: 100,through:100000,
                              sensitivity:.low,
                              isContinuous:true
                              ,isHapticFeedbackEnabled: true){
            crownEvent in
            crownOffset = crownEvent.offset
            crownSpeed = crownEvent.velocity
            
            
            if crownSpeed > 3.0 && !DeleteFlag && !enter_text.isEmpty{

                enter_text.removeLast()
                enter_vowels.removeLast()
                delete_cnt += 1
                DeleteFlag = true

            }else{

                if crownSpeed > 0{

                    downFlag = true

                    if !startFlag{
                        startTime = Date()
                        startFlag = true
                    }


                    if upperFlag{
                        upperFlag = false
                        cnt = 0
                        
                        if c_cnt == 0{
                            enter_vowels.removeLast()
                        }else{
                            if consonant[v_cnt][c_cnt] == "小"{
                                switch enter_text.last{
                                case "つ":
                                    enter_text.removeLast()
                                    enter_text.append("っ")
                                case "や":
                                    enter_text.removeLast()
                                    enter_text.append("ゃ")
                                case "ゆ":
                                    enter_text.removeLast()
                                    enter_text.append("ゅ")
                                case "よ":
                                    enter_text.removeLast()
                                    enter_text.append("ょ")
                                
                                case "あ":
                                    enter_text.removeLast()
                                    enter_text.append("ぁ")
                                case "い":
                                    enter_text.removeLast()
                                    enter_text.append("ぃ")
                                case "う":
                                    enter_text.removeLast()
                                    enter_text.append("ぅ")
                                case "え":
                                    enter_text.removeLast()
                                    enter_text.append("ぇ")
                                case "お":
                                    enter_text.removeLast()
                                    enter_text.append("ぉ")
                                
                                
                                default:
                                    print("小文字にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "\""{
                                enter_vowels.removeLast()
                                print(String(enter_text.last!))
                                switch enter_vowels.last{
                                case "か":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[0][tmp]!)
                                case "さ":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[1][tmp]!)
                                case "た":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[2][tmp]!)
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[3][tmp]!)
                                default:
                                    print("濁音にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "゜"{
                                enter_vowels.removeLast()
                                
                                switch enter_vowels.last{
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(handakuon[tmp]!)
                                    
                                    
                                default:
                                    print("半濁音にできる文字ではない")
                                }
                            }
                            else{
                                enter_text.append(consonant[v_cnt][c_cnt])
                            }
                        }
                    }
                    
                    c_cnt = 0
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1 {
                        cnt = 0
                        //                    if DirFlag{
                        //                        v_cnt -= 1
                        //
                        //                    }else{
                        //                        v_cnt += 1
                        //                    }
                        v_cnt += 1
                        v_cnt += vowels.count
                        v_cnt %= vowels.count
                        if Vive{
                            knock(type: WKHapticType(rawValue: 7))
                        }
//                        knock(type: WKHapticType(rawValue: 7))
                    }

                }
                else if crownSpeed < 0 {

                    upperFlag = true




                    if downFlag{
                        downFlag = false
                        cnt = 0
                        enter_vowels.append(consonant[v_cnt][1])
                    }
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1  {
                        cnt = 0
                        c_cnt += 1
                        c_cnt %= consonant[v_cnt].count

                        if Vive{
                            knock(type: WKHapticType(rawValue: 6))
                        }
//                        knock(type: WKHapticType(rawValue: 6))
                    }
                }
                else{
                    OntimeDirFlag = false
                    DeleteFlag = false
                }

               


            }

        }
    }
}

struct PracticeView: View {
    
    
    //ConfigView
    @Binding var Rotation_Dir: Bool
    @Binding var CROWN_CNT: Double
    @Binding var Vive:Bool
    
    @State private var crownValue = 0.0
    @State private var v_cnt = 0
    @State private var c_cnt = 0
    @State private var cnt = 0
    @State private var enter_text = ""
    @State private var enter_log = ""
    @State private var phrase_cnt = 0
    @State private var enter_vowels = ""
    @State var dateText = ""
    @State var wrong_cnt:Int = 0
    @State var delete_cnt:Int = 0
    @State var TER:Double = 0.0
    @State var CPM:String = ""
    @State private var r_phrase: [String] = [
        "おはよう",
        "こんにちは",
        "こんばんわ",
        "おやすみ",
        "げんきです",
        "ねむいです",
        "さようなら",
        "ひさしぶり",
        "やっぱいいや",
        "どうでもいいよ",
        "すごくいいね",
        "おなかすいた",
        "べんきょうする",
        "きたくします",
        "ただいま",
        "ばんごはんなに",
        
        
    ]
    
    @ObservedObject private var connector = PhoneConnector()
    
    func knock(type: WKHapticType?){
        guard let hType = type else{return}
        WKInterfaceDevice.current().play(hType)
    }
    
   
    func LevenshteinDistance(s1:String,s2:String)->Int{
        
        if s1.isEmpty {
            return s2.count
        }
        var d:[[Int]] = Array(repeating: Array(repeating: 0, count: s2.count + 1),count: s1.count + 1)
        
        for i1 in 0 ..< s1.count+1{
            d[i1][0] = i1
        }
        
        for i2 in 0 ..< s2.count+1{
            d[0][i2] = i2
        }
        
        for i1 in 1 ..< s1.count+1{
            for i2 in 1 ..< s2.count+1{
                let cost = s1[s1.index(s1.startIndex,offsetBy: i1-1)] == s2[s2.index(s2.startIndex,offsetBy: i2-1)] ? 0 : 1
                d[i1][i2] = min(d[i1-1][i2]+1,d[i1][i2-1]+1,d[i1-1][i2-1]+cost)
                
                
            }
        }
        
        return d[s1.count][s2.count]
    }
    var body: some View {
        VStack {
            
            
            //入力欄に入力文字がない
//                Text(enter_text)
//                    .font(.system(size:18,weight:.black,design:.default))
//                    .border(Color.blue)
//                    .frame(maxWidth:.infinity,alignment:.leading)
// 
            

            TabView(){
                
                VStack(spacing:20){
                   
                    VStack{
                        Text(r_phrase[phrase_cnt])
                            .font(.system(size:15,weight:.black,design:.default))
                            .frame(maxWidth:.infinity,alignment:.leading)
                            
                        
                        
                        if downFlag || (!upperFlag && !downFlag){
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(vowels[v_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.blue)
                            }.frame(maxWidth:.infinity,alignment:.leading)
                        }else{
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(consonant[v_cnt][c_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.red)
                            }.frame(maxWidth:.infinity,alignment:.leading)

                        }
                    }.border(Color.blue)
                        .frame(maxWidth:.infinity,alignment:.leading)
//                        .frame(width:150,height:50,alignment: .topLeading)
                        .position(x: 88, y: 10)
                    HStack{
                        VStack(spacing:20){
                            if v_cnt + 1 == vowels.count{
                                Text("\(vowels[0])").font(.system(size:18,weight:.black,design:.default))
                            }else{
                                Text("\(vowels[v_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                            }
                            
                            
                            if downFlag || (!upperFlag && !downFlag){
                                Text("\(vowels[v_cnt])").font(.system(size:28,weight:.black,design:.default))
                            }else{
                                Text("\(consonant[v_cnt][c_cnt])").font(.system(size:28,weight:.black,design:.default))
                            }
                            if c_cnt + 1 == consonant[v_cnt].count{
                                Text("\(consonant[v_cnt][0])").font(.system(size:18,weight:.black,design:.default))
                            }else{
                                Text("\(consonant[v_cnt][c_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                            }
                            
                        }.position(x:88,y:20)
                        VStack(spacing:20){
                            Button(action:{
                                
                                TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                                if phrase_cnt < r_phrase.count{
                                    phrase_cnt += 1
                                }
                                enter_text.removeAll()
                                enter_log.removeAll()
                                startFlag = false
                                
                                let timeInterval = Date().timeIntervalSince(startTime)
                                let time = Int(timeInterval)
                                
                                let d = time / 86400
                                let h = time / 3600 % 24
                                let m = time / 60 % 60
                                let s = time % 60
                                
                                // ミリ秒
                                let ms = Int(timeInterval * 100) % 100
                                
                                CPM = String(format: "%d日%d時間%d分%d.%d秒", d, h, m, s, ms)
                                connector.send(CPM:CPM,TER:TER)
                                
                            }
                                   
                            ){
                                Text(">")
                            }
                        }.position(x:90,y:20)
                    }
                }
                
                //1key layout
                VStack(spacing: 20){
                    VStack{
                        Text(r_phrase[phrase_cnt])
                            .font(.system(size:15,weight:.black,design:.default))
                            .frame(maxWidth:.infinity,alignment:.leading)
                        
                        
                        if downFlag || (!upperFlag && !downFlag){
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(vowels[v_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.blue)
                            }.frame(maxWidth:.infinity,alignment:.leading)
                        }else{
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(consonant[v_cnt][c_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.red)
                            }.frame(maxWidth:.infinity,alignment:.leading)

                        }
                    }.border(Color.blue)
                        .frame(maxWidth:.infinity,alignment:.leading)
                        .position(x: 88, y: 10)
//                        .frame(width:150,height:50,alignment: .topLeading)
                    HStack{
                        VStack(spacing:20){
                            if downFlag || (!upperFlag && !downFlag){
                                Text("\(vowels[v_cnt])").font(.system(size:30,weight:.black,design:.default))
                            }else{
                                Text("\(consonant[v_cnt][c_cnt])").font(.system(size:30,weight:.black,design:.default))
                            }
                        }.position(x:88,y:20)
                        VStack(spacing:20){
                            Button(action:{
                                
                                TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                                if phrase_cnt < r_phrase.count{
                                    phrase_cnt += 1
                                }
                                enter_text.removeAll()
                                enter_log.removeAll()
                                startFlag = false
                                
                                let timeInterval = Date().timeIntervalSince(startTime)
                                let time = Int(timeInterval)
                                
                                let d = time / 86400
                                let h = time / 3600 % 24
                                let m = time / 60 % 60
                                let s = time % 60
                                
                                // ミリ秒
                                let ms = Int(timeInterval * 100) % 100
                                
                                CPM = String(format: "%d日%d時間%d分%d.%d秒", d, h, m, s, ms)
                                connector.send(CPM:CPM,TER:TER)
                                
                            }
                                   
                            ){
                                Text(">")
                            }
                        }.position(x:90,y:20)
                    }
                }
                
                //0key layout
                VStack(spacing: 20){
                    VStack{
                        Text(r_phrase[phrase_cnt])
                            .font(.system(size:15,weight:.black,design:.default))
                            .frame(maxWidth:.infinity,alignment:.leading)
                        
                        
                        if downFlag || (!upperFlag && !downFlag){
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(vowels[v_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.blue)
                            }.frame(maxWidth:.infinity,alignment:.leading)
                        }else{
                            VStack{
                                Text(enter_text)
                                    .font(.system(size:15,weight:.black,design:.default))
                                +
                                Text(consonant[v_cnt][c_cnt])
                                    .font(.system(size:15,weight:.black,design:.default))
                                    .foregroundColor(.red)
                            }.frame(maxWidth:.infinity,alignment:.leading)

                        }
                    }.border(Color.blue)
                        .frame(width:150,height:50,alignment: .topLeading)
                        .position(x: 88, y: 17)

                }
                
                
                VStack{
//                    TextField("Enter world", text:$enter_text)
                    
                    Button(action:{
                        
                        TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                        phrase_cnt += 1
                        enter_text.removeAll()
                        enter_log.removeAll()
                        startFlag = false
    
                        let timeInterval = Date().timeIntervalSince(startTime)
                        let time = Int(timeInterval)
    
                        let d = time / 86400
                        let h = time / 3600 % 24
                        let m = time / 60 % 60
                        let s = time % 60
    
                        // ミリ秒
                        let ms = Int(timeInterval * 100) % 100
    
                        CPM = String(format: "%d日%d時間%d分%d.%d秒", d, h, m, s, ms)
                        connector.send(CPM:CPM,TER:TER)
                        
                    }
                        
                    ){
                        Text("submit")
                    }
                    
                }
            }

        }
        .focusable()
        
        .digitalCrownRotation($crownValue,from: -100000,through:100000,
                              sensitivity:.low,
                              isContinuous:true
                              ,isHapticFeedbackEnabled: true){
            crownEvent in
            crownOffset = crownEvent.offset
            crownSpeed = crownEvent.velocity
            
           
            if crownSpeed > 3.0 && !DeleteFlag && !enter_text.isEmpty{
                
                enter_text.removeLast()
                enter_vowels.removeLast()
                delete_cnt += 1
                DeleteFlag = true

            }else{

                if crownSpeed > 0{

                    downFlag = true

                    if !startFlag{
                        startTime = Date()
                        startFlag = true
                    }


                    if upperFlag{
                        upperFlag = false
                        cnt = 0
                        
                        if c_cnt == 0{
                            enter_vowels.removeLast()
                        }else{
                            if consonant[v_cnt][c_cnt] == "小"{
                                switch enter_text.last{
                                case "つ":
                                    enter_text.removeLast()
                                    enter_text.append("っ")
                                    enter_log.removeLast()
                                    enter_log.append("っ")
                                case "や":
                                    enter_text.removeLast()
                                    enter_text.append("ゃ")
                                    enter_log.removeLast()
                                    enter_log.append("ゃ")
                                case "ゆ":
                                    enter_text.removeLast()
                                    enter_text.append("ゅ")
                                    enter_log.removeLast()
                                    enter_log.append("ゅ")
                                case "よ":
                                    enter_text.removeLast()
                                    enter_text.append("ょ")
                                    enter_log.removeLast()
                                    enter_log.append("ょ")
                                case "あ":
                                    enter_text.removeLast()
                                    enter_text.append("ぁ")
                                    enter_log.removeLast()
                                    enter_log.append("ぁ")
                                case "い":
                                    enter_text.removeLast()
                                    enter_text.append("ぃ")
                                    enter_log.removeLast()
                                    enter_log.append("ぃ")
                                case "う":
                                    enter_text.removeLast()
                                    enter_text.append("ぅ")
                                    enter_log.removeLast()
                                    enter_log.append("ぅ")
                                case "え":
                                    enter_text.removeLast()
                                    enter_text.append("ぇ")
                                    enter_log.removeLast()
                                    enter_log.append("ぇ")
                                case "お":
                                    enter_text.removeLast()
                                    enter_text.append("ぉ")
                                    enter_log.removeLast()
                                    enter_log.append("ぉ")
                                
                                default:
                                    print("小文字にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "\""{
                                enter_vowels.removeLast()
                                print(String(enter_text.last!))
                                switch enter_vowels.last{
                                case "か":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[0][tmp]!)
                                    enter_log.removeLast()
                                    enter_log.append(dakuon[0][tmp]!)
                                case "さ":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[1][tmp]!)
                                    enter_log.removeLast()
                                    enter_log.append(dakuon[1][tmp]!)
                                case "た":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[2][tmp]!)
                                    enter_log.removeLast()
                                    enter_log.append(dakuon[2][tmp]!)
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[3][tmp]!)
                                    enter_log.removeLast()
                                    enter_log.append(dakuon[3][tmp]!)
                                default:
                                    print("濁音にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "゜"{
                                enter_vowels.removeLast()
                                
                                switch enter_vowels.last{
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(handakuon[tmp]!)
                                    
                                    enter_log.removeLast()
                                    enter_log.append(handakuon[tmp]!)
                                default:
                                    print("半濁音にできる文字ではない")
                                }
                            }
                            else{
                                enter_text.append(consonant[v_cnt][c_cnt])
                                enter_log.append(consonant[v_cnt][c_cnt])
                            }
                        }
                    }
                    
                    c_cnt = 0
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1 {
                        cnt = 0
                        //                    if DirFlag{
                        //                        v_cnt -= 1
                        //
                        //                    }else{
                        //                        v_cnt += 1
                        //                    }
                        v_cnt += 1
                        v_cnt += vowels.count
                        v_cnt %= vowels.count
                        if Vive{
                            knock(type: WKHapticType(rawValue: 7))
                        }
//                        knock(type: WKHapticType(rawValue: 7))
                    }

                }
                else if crownSpeed < 0 {

                    upperFlag = true




                    if downFlag{
                        downFlag = false
                        cnt = 0
                        enter_vowels.append(consonant[v_cnt][1])
                    }
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1  {
                        cnt = 0
                        c_cnt += 1
                        c_cnt %= consonant[v_cnt].count

                        if Vive{
                            knock(type: WKHapticType(rawValue: 6))
                        }
//                        knock(type: WKHapticType(rawValue: 6))
                    }
                }
                else{
                    OntimeDirFlag = false
                    DeleteFlag = false
                }

               


            }

        }
    }
}



struct TestView: View {

    
    @Binding var Rotation_Dir: Bool
    @Binding var CROWN_CNT: Double
    
    var phrase: [String] = [
    "つくばだいがく",
    "あしたはかいぎ",
    "しめきりがちかい",
    "ごごきゅうこう",
    "あしたはやすみ",
    "ろんぶんよむ",
    "いんたらくしょん",
    "れんしゅうする",
    "うるしをぬる",
    "すいどうだい",
    "やさいをとる",
    "ていしゅつきげん",
    "ふみんふきゅう",
    "そうじとうばん",
    "ことしきせいする",
    "どうもありがとう",
    "わかりました",
    "ごめんなさい",
    "てんきわるい",
    "あしたはあめ",
    "きょうははれ",
    "あしたはくもり",
    "あきたにいく",
    "なまはげをみる",
    "だいがくにいく",
    "おなかすいた",
    "すいみんをとる",
    "あしたあそぼ",
    "おひさしぶり",
    "おつかれさま",
    "めんどくさい",
    "かぜをひいた",
    "いまどこにいる",
    "きどくがつく",
    "ききかんをもつ",
    "ぷろぐらみんぐ",
    "つうわをする",
    "きをつけてね",
    "えきについた",
    "らくたんしてた",
    "たんいをとる",
    "そつぎょうする",
    "けんきゅうしつ",
    "ひるめしたべた",
    "ひるねをする",
    "ぱわぽをつかう",
    "りしゅうとうろく",
    "やちんをはらう",
    "りんじんとらぶる",
    "ぽいんとをためる",
    "すたんぷをつかう",
    "あしたよていある",
    "がぞうをほぞん",
    "らいんをかえす",
    "こうぎのめも",
    "ほんをよんでた",
    "きょうしつにいく",
    "じゅんでんきどこ",
    "じてんしゃのる",
    "まうすでそうさ",
    "すまほわすれた"
    
    
    ]
    @State private var crownValue = 0.0
    @State private var v_cnt = 0
    @State private var c_cnt = 0
    @State private var cnt = 0
    @State private var enter_text = ""
    @State private var phrase_cnt = 0
    @State private var enter_vowels = ""
    @State var wrong_cnt:Int = 0
    @State var delete_cnt:Int = 0
    @State var dateText = ""
    @State var CER = 0
    @State var CPM:String = ""
    



    func knock(type: WKHapticType?){
        guard let hType = type else{return}
        WKInterfaceDevice.current().play(hType)
    }
    
    func LevenshteinDistance(s1:String,s2:String)->Int{
        
        if s1.isEmpty {
            return s2.count
        }
        var d:[[Int]] = Array(repeating: Array(repeating: 0, count: s2.count + 1),count: s1.count + 1)
        
        for i1 in 0 ..< s1.count+1{
            d[i1][0] = i1
        }
        
        for i2 in 0 ..< s2.count+1{
            d[0][i2] = i2
        }
        
        for i1 in 1 ..< s1.count+1{
            for i2 in 1 ..< s2.count+1{
                let cost = s1[s1.index(s1.startIndex,offsetBy: i1-1)] == s2[s2.index(s2.startIndex,offsetBy: i2-1)] ? 0 : 1
                d[i1][i2] = min(d[i1-1][i2]+1,d[i1][i2-1]+1,d[i1-1][i2-1]+cost)
                
                
            }
        }
        
        return d[s1.count][s2.count]
    }
    
    
    var body: some View {
        VStack {
            
            //入力欄に入力文字がない
//                Text(enter_text)
//                    .font(.system(size:18,weight:.black,design:.default))
//                    .border(Color.blue)
//                    .frame(maxWidth:.infinity,alignment:.leading)
            //入力欄に入力文字がある
            VStack{
               
                if downFlag || (!upperFlag && !downFlag){
                    VStack{
                        Text(enter_text)
                            .font(.system(size:18,weight:.black,design:.default))
                        +
                        Text(vowels[v_cnt])
                            .font(.system(size:18,weight:.black,design:.default))
                            .foregroundColor(.blue)
                    }.frame(maxWidth:.infinity,alignment:.leading)
                }else{
                    VStack{
                        Text(enter_text)
                            .font(.system(size:18,weight:.black,design:.default))
                        +
                        Text(consonant[v_cnt][c_cnt])
                            .font(.system(size:18,weight:.black,design:.default))
                            .foregroundColor(.red)
                    }.frame(maxWidth:.infinity,alignment:.leading)
                    
                }
            }.border(Color.blue)
               

//            VStack{
//                Text(CPM)
//                Button("次へ"){
//                    phrase_cnt += 1
//                    enter_text.removeAll()
//                    startFlag = false
//
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
//
//                }
//            }
            VStack{

                //            DirFlag ? Text("左回り") : Text("右回り")
                //            if upperFlag || (!upperFlag && !downFlag) {
                //                VStack(spacing: 30){
                //                    if v_cnt + 1 == vowels.count{
                //                        Text("\(vowels[0])")
                //                    }else{
                //                        Text("\(vowels[v_cnt+1])")
                //                    }
                //
                //                    Text("\(vowels[v_cnt])").fontWeight(.black)
                //
                //                    if v_cnt - 1 == -1 {
                //                        Text("\(vowels[vowels.count-1])")
                //                    }else{
                //                        Text("\(vowels[v_cnt-1])")
                //                    }
                //
                //                }
                //
                //
                //            }
                //
                //            if downFlag {
                //                Text("Select Consonant")
                //                VStack(spacing: 30){
                //                    if c_cnt - 1 == -1 {
                //                        Text("\(consonant[v_cnt][consonant[v_cnt].count-1])")
                //                    }else{
                //                        Text("\(consonant[v_cnt][c_cnt-1])")
                //                    }
                //
                //                    Text("\(consonant[v_cnt][c_cnt])").fontWeight(.black)
                //
                //                    if c_cnt + 1 == consonant[v_cnt].count{
                //                        Text("\(consonant[v_cnt][0])")
                //                    }else{
                //                        Text("\(consonant[v_cnt][c_cnt+1])")
                //                    }
                //
                //
                //                }
                //
                //
                //            }
            }

            TabView(){
                //3key layout
                VStack(spacing:20){
                   

                    
                    
//                    if v_cnt + 1 == vowels.count{
//                        Text("\(vowels[0])").font(.system(size:18,weight:.black,design:.default))
//                    }else{
//                        Text("\(vowels[v_cnt+1])").font(.system(size:18,weight:.black,design:.default))
//                    }
//                    if downFlag || (!upperFlag && !downFlag){
//                        Text("\(vowels[v_cnt])").font(.system(size:30,weight:.black,design:.default))
//                    }else{
//                        Text("\(consonant[v_cnt][c_cnt])").font(.system(size:30,weight:.black,design:.default))
//                    }
//                    if c_cnt + 1 == consonant[v_cnt].count{
//                        Text("\(consonant[v_cnt][0])").font(.system(size:18,weight:.black,design:.default))
//                    }else{
//                        Text("\(consonant[v_cnt][c_cnt+1])").font(.system(size:18,weight:.black,design:.default))
//                    }
                    if v_cnt + 1 == vowels.count{
                        Text("\(vowels[0])").font(.system(size:18,weight:.black,design:.default))
                    }else{
                        Text("\(vowels[v_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                    }
                    
                    
                    if downFlag || (!upperFlag && !downFlag){
                        Text("\(vowels[v_cnt])").font(.system(size:28,weight:.black,design:.default))
                    }else{
                        Text("\(consonant[v_cnt][c_cnt])").font(.system(size:28,weight:.black,design:.default))
                    }
                    if c_cnt + 1 == consonant[v_cnt].count{
                        Text("\(consonant[v_cnt][0])").font(.system(size:18,weight:.black,design:.default))
                    }else{
                        Text("\(consonant[v_cnt][c_cnt+1])").font(.system(size:18,weight:.black,design:.default))
                    }

                    //                if c_cnt + 2 == consonant[v_cnt].count{
                    //                    Text("\(consonant[v_cnt][0])")
                    //                }else{
                    //                    Text("\(consonant[v_cnt][c_cnt+2])")
                    //                }


                }
                //1key layout
                VStack(spacing: 20){
//                    VStack{
//                        Text(phrase[phrase_cnt])
//                            .font(.system(size:15,weight:.black,design:.default))
//                            .frame(maxWidth:.infinity,alignment:.leading)
                        
        //                Text(enter_text).font(.system(size:20,weight:.black,design:.default))
//                        if downFlag || (!upperFlag && !downFlag){
//                            VStack{
//                                Text(enter_text)
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                +
//                                Text(vowels[v_cnt])
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                    .foregroundColor(.blue)
//                            }.frame(maxWidth:.infinity,alignment:.leading)
//                        }else{
//                            VStack{
//                                Text(enter_text)
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                +
//                                Text(consonant[v_cnt][c_cnt])
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                    .foregroundColor(.red)
//                            }.frame(maxWidth:.infinity,alignment:.leading)
//
//                        }
//                    }.border(Color.blue)
//                        .frame(width:150,height:50,alignment: .topLeading)

                    if downFlag || (!upperFlag && !downFlag){
                        Text("\(vowels[v_cnt])").font(.system(size:30,weight:.black,design:.default))
                    }else{
                        Text("\(consonant[v_cnt][c_cnt])").font(.system(size:30,weight:.black,design:.default))
                    }

                }
                //0key layout
                VStack(spacing: 20){
//                    VStack{
//                        Text(phrase[phrase_cnt])
//                            .font(.system(size:15,weight:.black,design:.default))
//                            .frame(maxWidth:.infinity,alignment:.leading)
                        
        //                Text(enter_text).font(.system(size:20,weight:.black,design:.default))
//                        if downFlag || (!upperFlag && !downFlag){
//                            VStack{
//                                Text(enter_text)
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                +
//                                Text(vowels[v_cnt])
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                    .foregroundColor(.blue)
//                            }.frame(maxWidth:.infinity,alignment:.leading)
//                        }else{
//                            VStack{
//                                Text(enter_text)
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                +
//                                Text(consonant[v_cnt][c_cnt])
//                                    .font(.system(size:15,weight:.black,design:.default))
//                                    .foregroundColor(.red)
//                            }.frame(maxWidth:.infinity,alignment:.leading)
//                            
//                        }
//                    }.border(Color.blue)
//                        .frame(width:150,height:50,alignment: .topLeading)


                }
                
                
                
                
                VStack{
                    
                }
            }

        }
        .focusable()
        
        .digitalCrownRotation($crownValue){
            crownEvent in
            crownOffset = crownEvent.offset
            crownSpeed = crownEvent.velocity
            CER = LevenshteinDistance(s1: enter_text, s2: phrase[phrase_cnt])
            
            if enter_text == phrase[phrase_cnt] && phrase_cnt < phrase.count {
                phrase_cnt+=1
                enter_text.removeAll()
            }
            
            if crownSpeed > 3.0 && !DeleteFlag && !enter_text.isEmpty{

                enter_text.removeLast()
                enter_vowels.removeLast()
                delete_cnt += 1
                DeleteFlag = true

            }else{

                if crownSpeed > 0{

                    downFlag = true

                    if !startFlag{
                        startTime = Date()
                        startFlag = true
                    }


                    if upperFlag{
                        upperFlag = false
                        cnt = 0
                        
                        if c_cnt == 0{
                            enter_vowels.removeLast()
                        }else{
                            if consonant[v_cnt][c_cnt] == "小"{
                                switch enter_text.last{
                                case "つ":
                                    enter_text.removeLast()
                                    enter_text.append("っ")
                                case "や":
                                    enter_text.removeLast()
                                    enter_text.append("ゃ")
                                case "ゆ":
                                    enter_text.removeLast()
                                    enter_text.append("ゅ")
                                case "よ":
                                    enter_text.removeLast()
                                    enter_text.append("ょ")
                                
                                case "あ":
                                    enter_text.removeLast()
                                    enter_text.append("ぁ")
                                case "い":
                                    enter_text.removeLast()
                                    enter_text.append("ぃ")
                                case "う":
                                    enter_text.removeLast()
                                    enter_text.append("ぅ")
                                case "え":
                                    enter_text.removeLast()
                                    enter_text.append("ぇ")
                                case "お":
                                    enter_text.removeLast()
                                    enter_text.append("ぉ")
                                
                                
                                default:
                                    print("小文字にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "\""{
                                enter_vowels.removeLast()
                                print(String(enter_text.last!))
                                switch enter_vowels.last{
                                case "か":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[0][tmp]!)
                                case "さ":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[1][tmp]!)
                                case "た":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[2][tmp]!)
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(dakuon[3][tmp]!)
                                default:
                                    print("濁音にできる文字ではない")
                                }
                            }
                            else if consonant[v_cnt][c_cnt] == "゜"{
                                enter_vowels.removeLast()
                                
                                switch enter_vowels.last{
                                case "は":
                                    let tmp = String(enter_text.last!)
                                    enter_text.removeLast()
                                    enter_text.append(handakuon[tmp]!)
                                    
                                    
                                default:
                                    print("半濁音にできる文字ではない")
                                }
                            }
                            else{
                                enter_text.append(consonant[v_cnt][c_cnt])
                            }
                        }
                    }
                    
                    c_cnt = 0
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1 {
                        cnt = 0
                        //                    if DirFlag{
                        //                        v_cnt -= 1
                        //
                        //                    }else{
                        //                        v_cnt += 1
                        //                    }
                        v_cnt += 1
                        v_cnt += vowels.count
                        v_cnt %= vowels.count
                        knock(type: WKHapticType(rawValue: 1))
                    }

                }
                else if crownSpeed < 0 {

                    upperFlag = true




                    if downFlag{
                        downFlag = false
                        cnt = 0
                        enter_vowels.append(consonant[v_cnt][1])
                    }
                    cnt += 1
                    if cnt % Int(CROWN_CNT) == Int(CROWN_CNT)-1  {
                        cnt = 0
                        //                    if DirFlag{
                        //                        c_cnt -= 1
                        //                    }else{
                        //                        c_cnt += 1
                        //                    }
                        //                    c_cnt += consonant[v_cnt].count
                        c_cnt += 1
                        c_cnt %= consonant[v_cnt].count


                        knock(type: WKHapticType(rawValue: 2))
                    }
                }
                else{
                    OntimeDirFlag = false
                    DeleteFlag = false
                }

                //            if crownSpeed > 2.0 && !OntimeDirFlag{
                //                OntimeDirFlag = true
                //                print("Chang Dir!")
                //                DirFlag.toggle()
                //            }


            }

        }
    }
}

//struct ContentView: View {
//    @State var crownValue = 0.0
//
//    var body: some View {
//        ScrollView {
//            Text("\(crownValue)")
//
//            Button("Enable Crown") {
//                print("Enabling crown")
//            }
//
//        }
//        .digitalCrownRotation($crownValue)
//    }
//}

class PhoneConnector: NSObject, ObservableObject, WCSessionDelegate {
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith state= \(activationState.rawValue)")
    }
    
    
    
    func send(CPM:String,TER:Double) -> Text{
        if WCSession.default.isReachable {
            
            
            WCSession.default.sendMessage(["CPM": CPM,"TER": TER], replyHandler: nil) {
                error in
                print(error)
            }
        }
        return Text("")
    }
}
