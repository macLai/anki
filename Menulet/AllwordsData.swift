//
//  test.swift
//  Menulet
//
//  Created by 来泽文 on 14-8-5.
//  Copyright (c) 2014年 Qusic. All rights reserved.
//

import Foundation

var allwordsdataIns:AllwordsData = AllwordsData()

struct Word{
    var word:String = ""
    var explain:String = ""
    var nextwordLoc:UInt32 = 0
    var reviewTime:UInt32 = 0
}

class AllwordsData{
    var reviewNumToday:UInt8 = 0
    var learnNumToday:UInt8 = 0
    var wordlistLoc:UInt32 = 0
    var reviewRemainNumToday:UInt8 = 0
    var learnRemainNumToday:UInt8 = 0
    var reviewRemainNumAll:UInt16 = 0
    var learnRemainNumAll:UInt16 = 0
    
    var wordlistReviewFirstLoc:UInt32 = 0
    var wordlistReviewLastLoc:UInt32 = 0
    var wordlistLearnFirstLoc:UInt32 = 0
    var wordlistLearnLastLoc:UInt32 = 0
    
    var wordlist:Array<UInt32> = []
    var wordlistDic:Dictionary<UInt32,Word> = [:]
    
    
    init(){
    }
}