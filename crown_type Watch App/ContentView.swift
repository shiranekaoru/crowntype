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
    ["\",゜小","\"","゜","小"]
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

var consonant_uni: [[String]] = [
    ["あ","い","う","え","お"],
    ["か","き","く","け","こ"],
    ["さ","し","す","せ","そ"],
    ["た","ち","つ","て","と"],
    ["な","に","ぬ","ね","の"],
    ["は","ひ","ふ","へ","ほ"],
    ["ま","み","む","め","も"],
    ["や","ゆ","よ"],
    ["ら","り","る","れ","ろ"],
    ["わ","を","ん"],
    ["\"","゜","小"]
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

var henkan : [String:[String]] = ["あ":["ぁ","あ"],"い":["ぃ","い"],"う":["ぅ","う"],"え":["ぇ","え"],"お":["ぉ","お"],"か":["が","か"],"き":["ぎ","き"],"く":["ぐ","く"],"け":["げ","け"],"こ":["ご","こ"],"さ":["ざ","さ"],"し":["じ","し"],"す":["ず","す"],"せ":["ぜ","せ"],"そ":["ぞ","そ"],"は":["ば","ぱ","は"],"ひ":["び","ぴ","ひ"],"ふ":["ぶ","ぷ","ふ"],"へ":["べ","ぺ","へ"],"ほ":["ぼ","ぽ","ほ"],"た":["だ","た"],"ち":["ぢ","ち"],"つ":["っ","づ","つ"],"て":["で","て"],"と":["ど","と"],"や":["ゃ","や"],"ゆ":["ゅ","ゆ"],"よ":["ょ","よ"],"わ":["ゎ","わ"],]


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
    @State var entry_time:String = ""
    
    @State private var buttonWidth: CGFloat = 35
    @State private var buttonHeight: CGFloat = 25
    @State private var input_text: String = ""
    @State private var entry_text: String = ""
    @State private var isChange_Vowel = 0
    @State private var old_input_text: String = ""
    @State private var henka_cnt = 0
    @State private var cons_cnt = 0
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
//        GeometryReader{ geometry in
//            Text("Width: \(geometry.size.width)")
//            Text("Height: \(geometry.size.height)")
//        }
        VStack {
            
            
            //入力欄に入力文字がない
//                Text(enter_text)
//                    .font(.system(size:18,weight:.black,design:.default))
//                    .border(Color.blue)
//                    .frame(maxWidth:.infinity,alignment:.leading)
// 
            

            TabView(){
                //T9 キーボード
                VStack{
                    HStack{
                        VStack{
                            Text(r_phrase[phrase_cnt]).frame(maxWidth:.infinity,alignment: .leading)
                            Text(entry_text+input_text).frame(maxWidth:.infinity,alignment: .leading)
//                            Text(entry_text)
//                            Text(input_text)
                            
                        }.border(Color.blue).frame(maxWidth:.infinity,maxHeight:15,alignment:.leading)
                        VStack{
                            Button(action:{
                                isChange_Vowel = 0
                                entry_text += input_text
                                input_text = ""
                                if !entry_text.isEmpty{
                                    entry_text.removeLast()
                                }
                            }){
                                Image(systemName: "delete.backward")
                            }.buttonStyle(DeleteButtonStyle())
                        }
                    }
                    
                    
                    VStack {
        
                        HStack{
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 1{
                                    cons_cnt = 0
                                    isChange_Vowel = 1
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[0][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[0].count
                                    input_text = consonant_uni[0][cons_cnt]
                                }
                                
                                
                            }){
                                Text("あ")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 2{
                                    cons_cnt = 0
                                    isChange_Vowel = 2
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[1][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[1].count
                                    input_text = consonant_uni[1][cons_cnt]
                                }
                            }){
                                Text("か")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 3{
                                    cons_cnt = 0
                                    isChange_Vowel = 3
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[2][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[2].count
                                    input_text = consonant_uni[2][cons_cnt]
                                }
                            }){
                                Text("さ")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                        }
                        
                        HStack{
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 4{
                                    cons_cnt = 0
                                    isChange_Vowel = 4
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[3][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[3].count
                                    input_text = consonant_uni[3][cons_cnt]
                                }
                            }){
                                Text("た")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 5{
                                    cons_cnt = 0
                                    isChange_Vowel = 5
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[4][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[4].count
                                    input_text = consonant_uni[4][cons_cnt]
                                }
                            }){
                                Text("な")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 6{
                                    cons_cnt = 0
                                    isChange_Vowel = 6
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[5][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[5].count
                                    input_text = consonant_uni[5][cons_cnt]
                                }
                            }){
                                Text("は")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                        }
                        HStack{
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 7{
                                    cons_cnt = 0
                                    isChange_Vowel = 7
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[6][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[6].count
                                    input_text = consonant_uni[6][cons_cnt]
                                }
                            }){
                                Text("ま")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 8{
                                    cons_cnt = 0
                                    isChange_Vowel = 8
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[7][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[7].count
                                    input_text = consonant_uni[7][cons_cnt]
                                }
                            }){
                                Text("や")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 9{
                                    cons_cnt = 0
                                    isChange_Vowel = 9
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[8][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[8].count
                                    input_text = consonant_uni[8][cons_cnt]
                                }
                            }){
                                Text("ら")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                        }
                        HStack{
                            Button(action:{
                                
                                if isChange_Vowel == 9 || isChange_Vowel == 7 || isChange_Vowel == 5 || input_text == "を" || input_text == "ん"{
                                    
                                }else{
                                    if isChange_Vowel != 10{
                                        cons_cnt = 0
                                        isChange_Vowel = 10
                                        if !input_text.isEmpty{
                                             old_input_text = String(input_text)
                                        }
                                        //                                        input_text = consonant_uni[10][cons_cnt]
                                        
                                    }else{
                                        cons_cnt += 1
                                        
                                    }
                                    
                                    if !input_text.isEmpty{
                                        let henkan_cn = cons_cnt % henkan[old_input_text]!.count
                                        input_text.removeLast()
                                        input_text.append((henkan[old_input_text]?[henkan_cn])!)
                                    }
                                }
                            }){
                                Text("\" ゜小")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if !startFlag{
                                    startTime = Date()
                                    startFlag = true
                                }
                                if isChange_Vowel != 11{
                                    cons_cnt = 0
                                    isChange_Vowel = 11
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = consonant_uni[9][cons_cnt]
                                }else{
                                    cons_cnt += 1
                                    cons_cnt %= consonant_uni[9].count
                                    input_text = consonant_uni[9][cons_cnt]
                                }
                            }){
                                Text("わ")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                            Button(action:{
                                if isChange_Vowel != 0{
                                    isChange_Vowel = 0
                                    entry_text += input_text
                                    enter_log += input_text
                                    input_text = ""
                                }else{
                                    
                                    let timeInterval = Date().timeIntervalSince(startTime)
                                    let time = Int(timeInterval)
                                    
                                    
                                    let m = time / 60 % 60
                                    let s = time % 60
                                    
                                    // ミリ秒
                                    let ms = Int(timeInterval * 100) % 100
                                    
                                    entry_time = String(format: "%dm%d.%ds",  m, s, ms)
                                    CPM = String(Double(r_phrase[phrase_cnt].count)/(Double(m)+(Double(s)+Double(ms)/100.0)/60.0))
                                    TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                                    
                                    connector.send(phrase:r_phrase[phrase_cnt],phraseID:phrase_cnt,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER)
                                    
                                    entry_text.removeAll()
                                    enter_log.removeAll()
                                    if r_phrase.count - 1 > phrase_cnt{
                                        phrase_cnt += 1
                                    }
                                    startFlag = false
                                }
                                
                            }){
                                Text("確定")
                                    .frame(width:buttonWidth,height:buttonHeight)
                            }
                            .buttonStyle(MyButtonStyle())
                            
                        }
                    }
                    .position(x:80,y:80)
                    
                       
                }
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
                                
                                
                                
                                
                                let timeInterval = Date().timeIntervalSince(startTime)
                                let time = Int(timeInterval)
                                
                                
                                let m = time / 60 % 60
                                let s = time % 60
                                
                                // ミリ秒
                                let ms = Int(timeInterval * 100) % 100
                                
                                entry_time = String(format: "%dm%d.%ds",  m, s, ms)
                                CPM = String(Double(r_phrase[phrase_cnt].count)/(Double(m)+(Double(s)+Double(ms)/100.0)/60.0))
                                TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                                
                                connector.send(phrase:r_phrase[phrase_cnt],phraseID:phrase_cnt,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER)
                                
                                if phrase_cnt < r_phrase.count - 1{
                                    phrase_cnt += 1
                                }
                                enter_text.removeAll()
                                enter_log.removeAll()
                                startFlag = false
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
                                
                                
                                
                                let timeInterval = Date().timeIntervalSince(startTime)
                                let time = Int(timeInterval)
                                
                                
                                let m = time / 60 % 60
                                let s = time % 60
                                
                                // ミリ秒
                                let ms = Int(timeInterval * 100) % 100
                                
                                entry_time = String(format: "%dm%d.%ds",  m, s, ms)
                                CPM = String(Double(r_phrase.count)/(Double(m)+Double(s+ms)/60.0))
                                TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                                connector.send(phrase:r_phrase[phrase_cnt],phraseID:phrase_cnt,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER)
                                
                                if phrase_cnt < r_phrase.count - 1{
                                    phrase_cnt += 1
                                }
                                enter_text.removeAll()
                                enter_log.removeAll()
                                startFlag = false
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
                    TextField("Enter world", text:$enter_text)
                    
                    Button(action:{
                        
                        
    
                        let timeInterval = Date().timeIntervalSince(startTime)
                        let time = Int(timeInterval)
    
                       
                        
                        let m = time / 60 % 60
                        let s = time % 60
    
                        // ミリ秒
                        let ms = Int(timeInterval * 100) % 100
    
                        entry_time = String(format: "%dm%d.%ds",  m, s, ms)
                        CPM = String(Double(r_phrase.count)/(Double(m)+Double(s+ms)/60.0))
                        TER = Double(LevenshteinDistance(s1: r_phrase[phrase_cnt], s2: enter_log)) / Double(enter_log.count)
                        
                        connector.send(phrase:r_phrase[phrase_cnt],phraseID:phrase_cnt,keystroke:enter_log.count,Time:entry_time,CPM:CPM,TER:TER)
                        
                        
                        if phrase_cnt < r_phrase.count - 1 {
                            phrase_cnt += 1
                        }
                        enter_text.removeAll()
                        enter_log.removeAll()
                        startFlag = false
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
    
    
    
    func send(phrase:String,phraseID:Int,keystroke:Int,Time:String,CPM:String,TER:Double) -> Text{
        if WCSession.default.isReachable {
            
            
            WCSession.default.sendMessage(["phrase":phrase,"phraseID":phraseID,"Keystroke":keystroke,"Time":Time,"CPM": CPM,"TER": TER], replyHandler: nil) {
                error in
                print(error)
            }
        }
        return Text("")
    }
}

#Preview{
    StartListView()
}

struct MyButtonStyle: ButtonStyle {
    // (1)
    func makeBody(configuration: Configuration) -> some View {
        MyButton(configuration:configuration)
    }
    // (2)
    struct MyButton: View {
        // (2)
        @Environment(\.isEnabled) var isEnabled
        let configuration: MyButtonStyle.Configuration
        var body: some View {
            // (3)
            configuration.label
                // (4)
                .foregroundColor(isEnabled ? .white : .gray)
                // (5)
                .opacity(configuration.isPressed ? 0.2 : 1.0)
                .background(isEnabled ? Color.gray.opacity(0.4):Color.white)
                .cornerRadius(5)
        }
    }
}

struct DeleteButtonStyle: ButtonStyle {
    // (1)
    func makeBody(configuration: Configuration) -> some View {
        DeleteButton(configuration:configuration)
    }
    // (2)
    struct DeleteButton: View {
        // (2)
        @Environment(\.isEnabled) var isEnabled
        let configuration: DeleteButtonStyle.Configuration
        var body: some View {
            // (3)
            configuration.label
                // (4)
                .foregroundColor(isEnabled ? .white : .gray)
                // (5)
                .opacity(configuration.isPressed ? 0.2 : 1.0)
                .background(.clear)
                .cornerRadius(5)
        }
    }
}
