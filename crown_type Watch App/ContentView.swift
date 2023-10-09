//
//  ContentView.swift
//  crown_type Watch App
//
//  Created by shirane kaoru on 2023/10/06.
//

import SwiftUI

struct ContentView: View {
    
    @State private var crownValue = 0.0
    @State private var crownAcc = 0.0
    @State private var crownOffset = 0.0
    @State private var crownOldOffset = 0.0
    @State private var Diff = 0.0
    @State private var crownSpeed = 0.0
    @State private var upperFlag = false
    @State private var downFlag = false
    @State private var DeleteFlag = false
    @State private var DirFlag = false
    @State private var OntimeDirFlag = false
    @State private var changeDir = false
    @State private var vowels:[String] = ["あ","か","さ","た","な","は","ま","や","ら","わ"]
    @State private var consonant: [[String]] = [
        ["あ","あ","い","う","え","お"],
        ["か","か","き","く","け","こ"],
        ["さ","さ","し","す","せ","そ"],
        ["た","た","ち","つ","て","と"],
        ["な","な","に","ぬ","ね","の"],
        ["は","は","ひ","ふ","へ","ほ"],
        ["ま","ま","み","む","め","も"],
        ["や","や","ゆ","よ"],
        ["ら","ら","り","る","れ","ろ"],
        ["わ","わ","を","ん"]
    ]
    @State private var v_cnt = 0
    @State private var c_cnt = 0
    @State private var cnt = 0
    
    @State private var enter_text = ""
    
    func Enter_text(enter_text:String,char:String) -> Text{
        self.enter_text.append(char)
        return Text("Enter word")
    }
    
    func remove_text(enter_text:String) -> Text{
        self.enter_text.removeLast()
        return Text("Delete Char")
    }
    var body: some View {
        VStack {
            
            Text(enter_text)
            
//            DirFlag ? Text("左回り") : Text("右回り")
            if upperFlag || (!upperFlag && !downFlag) {
                VStack(spacing: 30){
                    if v_cnt + 1 == vowels.count{
                        Text("\(vowels[0])")
                    }else{
                        Text("\(vowels[v_cnt+1])")
                    }
                    
                    Text("\(vowels[v_cnt])").fontWeight(.black)
                    
                    if v_cnt - 1 == -1 {
                        Text("\(vowels[vowels.count-1])")
                    }else{
                        Text("\(vowels[v_cnt-1])")
                    }
                    
                }
                    
                
            }
            
            if downFlag {
                Text("Select Consonant")
                VStack(spacing: 30){
                    if c_cnt - 1 == -1 {
                        Text("\(consonant[v_cnt][consonant[v_cnt].count-1])")
                    }else{
                        Text("\(consonant[v_cnt][c_cnt-1])")
                    }
                    
                    Text("\(consonant[v_cnt][c_cnt])").fontWeight(.black)
                    
                    if c_cnt + 1 == consonant[v_cnt].count{
                        Text("\(consonant[v_cnt][0])")
                    }else{
                        Text("\(consonant[v_cnt][c_cnt+1])")
                    }
                    
                    
                }
                
                
                
            }
            
            
            
                
                
                
            
        }
        .focusable()
        .digitalCrownRotation($crownValue){
            crownEvent in
            crownOffset = crownEvent.offset
            crownSpeed = crownEvent.velocity
            
            if crownSpeed > 0{
                
                upperFlag = true
                
                
                
                if downFlag{
                    downFlag = false
                    cnt = 0
                    enter_text.append(consonant[v_cnt][c_cnt])
                }
                c_cnt = 0
                cnt += 1
                if cnt % 20 == 19 {
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
                }
                
            }
            else if crownSpeed < 0 {
                
                downFlag = true
                
                
                
                
                if upperFlag{
                    upperFlag = false
                    cnt = 0
                }
                cnt += 1
                if cnt % 20 == 19 {
                    cnt = 0
//                    if DirFlag{
//                        c_cnt -= 1
//                    }else{
//                        c_cnt += 1
//                    }
//                    c_cnt += consonant[v_cnt].count
                    c_cnt += 1
                    c_cnt %= consonant[v_cnt].count
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
            if crownSpeed > 3.0 && !DeleteFlag && !enter_text.isEmpty{

                enter_text.removeLast()
                DeleteFlag = true

            }
            
            
            
        }
    }
}
