//
//  AllwordsFileinfo.swift
//  Menulet
//
//  Created by 来泽文 on 14-8-9.
//  Copyright (c) 2014年 Qusic. All rights reserved.
//

import Foundation

var allwordsFileinfoIns:AllwordsFileinfo = AllwordsFileinfo()

class AllwordsFileinfo{
    init(){
        allwordsData = AllwordsData()
    }
    var allwordsData:AllwordsData;
    
    func AllwordsExport(){
        var range = NSRange(location:0, length:0)
        var wordlistNew:Array<UInt32> = []
        var wordlistOld:Dictionary<UInt32,UInt32> = [:]
        var temp:Int8 = 0
        var wordlistLoc_loc:Int = 0
        var wordlistTop_loc:Int = 0
        var writer:NSMutableData = NSMutableData()
        writer.appendBytes(&allwordsData.learnNumToday, length: 8)
        writer.appendBytes(&allwordsData.reviewNumToday, length: 8)
        wordlistLoc_loc = writer.length
        writer.appendBytes(&allwordsData.wordlistLoc, length: 32)
        writer.appendBytes(&allwordsData.learnRemainNumToday, length: 8)
        writer.appendBytes(&allwordsData.reviewRemainNumToday, length: 8)
        writer.appendBytes(&allwordsData.learnRemainNumAll, length: 16)
        writer.appendBytes(&allwordsData.reviewRemainNumAll, length: 16)
        
        //wordlistLoc rewrite
        range.length = 32
        range.location = wordlistLoc_loc
        writer.replaceBytesInRange(range, withBytes: &writer.length)
        
        //listTop
        wordlistTop_loc = writer.length
        writer.appendBytes(&allwordsData.wordlistReviewFirstLoc, length: 32)
        writer.appendBytes(&allwordsData.wordlistReviewLastLoc, length: 32)
        writer.appendBytes(&allwordsData.wordlistLearnFirstLoc, length: 32)
        writer.appendBytes(&allwordsData.wordlistLearnLastLoc, length: 32)
        
        //writeList
        var temp_int32:UInt32
        var temp_string:String
        for (index, item) in enumerate(allwordsData.wordlist){
            wordlistNew.append(UInt32(writer.length))
            wordlistOld.updateValue(item, forKey: UInt32(index))
            writer.appendBytes(&temp, length: 32)
            
            temp_int32 = allwordsData.wordlistDic[item]!.reviewTime
            writer.appendBytes(&temp_int32, length: 32)
            temp_string = allwordsData.wordlistDic[item]!.word+"\n"
            writer.appendData(temp_string!.dataUsingEncoding(NSUTF8StringEncoding))
            temp_string = allwordsData.wordlistDic[item]!.explain+"\n"
            writer.appendData(temp_string.dataUsingEncoding(NSUTF8StringEncoding))
        }
        
        //address sort
        //wordlistReviewFirstLoc
        range.length = 32
        range.location = wordlistTop_loc
        temp_int32 = wordlistNew[Int(wordlistOld[allwordsData.wordlistReviewFirstLoc]!)]
        writer.replaceBytesInRange(range, withBytes: &temp_int32)
        
        //wordlistReviewLastLoc
        range.length = 32
        range.location = wordlistTop_loc+32
        temp_int32 = wordlistNew[Int(wordlistOld[allwordsData.wordlistReviewLastLoc]!)]
        writer.replaceBytesInRange(range, withBytes: &temp_int32)
        
        //wordlistLearnFirstLoc
        range.length = 32
        range.location = wordlistTop_loc+64
        temp_int32 = wordlistNew[Int(wordlistOld[allwordsData.wordlistLearnFirstLoc]!)]
        writer.replaceBytesInRange(range, withBytes: &temp_int32)
        
        
        //wordlistLearnLastLoc
        range.length = 32
        range.location = wordlistTop_loc+96
        temp_int32 = wordlistNew[Int(wordlistOld[allwordsData.wordlistLearnLastLoc]!)]
        writer.replaceBytesInRange(range, withBytes: &temp_int32)
        
        //list
        //review list
        var nextadd:UInt32 = allwordsData.wordlistReviewFirstLoc
        while(nextadd != 0){
            range.length = 32
            temp_int32 = wordlistNew[Int(wordlistOld[nextadd]!)]
            range.location = Int(temp_int32)
            nextadd = allwordsData.wordlistDic[nextadd]!.nextwordLoc
            if(nextadd == 0){
                temp_int32 = 0
            }else{
                temp_int32 = wordlistNew[Int(wordlistOld[nextadd]!)]
            }
            writer.replaceBytesInRange(range, withBytes: &temp_int32)
        }
        
        //learn list
        nextadd = allwordsData.wordlistLearnFirstLoc
        while(nextadd != 0){
            range.length = 32
            temp_int32 = wordlistNew[Int(wordlistOld[nextadd]!)]
            range.location = Int(temp_int32)
            nextadd = allwordsData.wordlistDic[nextadd]!.nextwordLoc
            if(nextadd == 0){
                temp_int32 = 0
            }else{
                temp_int32 = wordlistNew[Int(wordlistOld[nextadd]!)]
            }
            writer.replaceBytesInRange(range, withBytes: &temp_int32)
        }
        
    }
    
    func AllwrodsImport(reader:NSData){
        var range:NSRange = NSRange(location:0, length:0)
        var loc:Int = 0
        range.location = loc;range.length = 8;loc = loc + 8
        reader.getBytes(&allwordsData.learnNumToday, range: range)
        range.location = loc;range.length = 8;loc = loc + 8
        reader.getBytes(&allwordsData.reviewNumToday, range: range)
        range.location = loc;range.length = 32;loc = loc + 32
        reader.getBytes(&allwordsData.wordlistLoc, range: range)
        range.location = loc;range.length = 8;loc = loc + 8
        reader.getBytes(&allwordsData.learnRemainNumToday, range: range)
        range.location = loc;range.length = 8;loc = loc + 8
        reader.getBytes(&allwordsData.reviewRemainNumToday, range: range)
        range.location = loc;range.length = 16;loc = loc + 16
        reader.getBytes(&allwordsData.learnRemainNumAll, range: range)
        range.location = loc;range.length = 16;loc = loc + 16
        reader.getBytes(&allwordsData.reviewRemainNumAll, range: range)
        range.location = loc;range.length = 32;loc = loc + 32
        reader.getBytes(&allwordsData.wordlistReviewFirstLoc, range: range)
        range.location = loc;range.length = 32;loc = loc + 32
        reader.getBytes(&allwordsData.wordlistReviewLastLoc, range: range)
        range.location = loc;range.length = 32;loc = loc + 32
        reader.getBytes(&allwordsData.wordlistLearnFirstLoc, range: range)
        range.location = loc;range.length = 32;loc = loc + 32
        reader.getBytes(&allwordsData.wordlistLearnLastLoc, range: range)
        
        var temp_key:UInt32 = 0
        var temp_nextwordLoc:UInt32 = 0
        var temp_reviewTime:UInt32 = 0
        var temp_word:NSString = ""
        var temp_explain:NSString = ""
        var range_word:NSRange
        while(true){
            temp_key = UInt32(loc)
            range.location = loc;range.length = 32;loc = loc + 32
            reader.getBytes(&temp_nextwordLoc, length: 32)
            range.location = loc;range.length = 32;loc = loc + 32
            reader.getBytes(&temp_reviewTime, length: 32)
            
            //read word
            range.location = loc;range.length = 2000
            temp_word = NSString(data: reader.subdataWithRange(range), encoding: NSUTF8StringEncoding)
            range_word = temp_word.rangeOfString("\n")
            if(range_word.location == NSNotFound){
                //t.b.d
            }
            temp_word = temp_word.substringToIndex(range_word.location)
            loc = loc + range_word.location
            
            //read explain
            range.location = loc;range.length = 2000
            temp_explain = NSString(data: reader.subdataWithRange(range), encoding: NSUTF8StringEncoding)
            range_word = temp_explain.rangeOfString("\n")
            if(range_word.location == NSNotFound){
                //t.b.d
            }
            temp_explain = temp_explain.substringToIndex(range_word.location)
            loc = loc + range_word.location
            
            //read to memory
            allwordsData.wordlist.append(temp_key)
            var word:Word = Word(word: temp_word, explain: temp_explain, nextwordLoc: temp_nextwordLoc, reviewTime: temp_reviewTime)
            allwordsData.wordlistDic.updateValue(word, forKey: temp_key)
            
            if(loc >= reader.length){
                break
            }
        }
    }
}