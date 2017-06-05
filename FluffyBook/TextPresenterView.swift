//
//  CoreTextView.swift
//  TestCoreText
//
//  Created by Владимир Лапатин on 02.06.17.
//  Copyright © 2017 fluffybook. All rights reserved.
//

import UIKit
import CoreText

class TextPresenterView: UIView {
    
    var parsedWords: [ParsedWord]?

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.textMatrix = CGAffineTransform.identity
        
        context.translateBy(x: 0, y: self.bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        drawRect(withRect: self.bounds)
        
        for word in parsedWords!{
        
            let path = CGMutablePath()
            path.addRect(word.getRect())
        
            let frameSetter = CTFramesetterCreateWithAttributedString(word.getWord())
        
            let ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, word.getWord().length), path, nil)
        
            CTFrameDraw(ctFrame, context)
            
        }
        
    }
    
    func countNewRect(_ w : Double, _ h : Double) -> CGMutablePath{
  
        let path = CGMutablePath()
        path.addRect(self.bounds)
        
        return path
        
    }
    
    func makeString(word : String) -> NSMutableAttributedString {
        
        let str = NSMutableAttributedString(string: word)
        
        str.addAttribute(kCTForegroundColorAttributeName as String, value: UIColor.black, range: NSMakeRange(0, str.length))
        
        let fontRef = UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
        str.addAttribute(kCTFontAttributeName as String, value: fontRef, range: NSMakeRange(0, str.length))
        
        return str
        
    }
    
    func drawRect(withRect rect: CGRect){
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        path.close()
        
        UIColor.red.set()
        
        path.stroke()
        
        
    }
 

}
