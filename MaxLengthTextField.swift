//
//  MaxLengthTextField.swift
//  Swift 3 Text Field Magic 2
//
//  Created by Joey deVilla on 2016-09-03.
//  MIT license. See the end of this file for the gory details.
//
//  Accompanies the article in Global Nerdy (http://globalnerdy.com):
//  "Swift 3 text field magic, part 1: Creating text fields with maximum lengths"
//  http://www.globalnerdy.com/2016/09/05/swift-3-text-field-magic-part-1-creating-text-fields-with-maximum-lengths/
//


import UIKit

class MaxLengthTextField: UITextField, UITextFieldDelegate {
  
  private var characterLimit: Int?
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    delegate = self
  }
  
  @IBInspectable var maxLength: Int {
    get {
      guard let length = characterLimit else {
        return Int.max
      }
      return length
    }
    set {
      characterLimit = newValue
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard string.characters.count > 0 else {
      return true
    }
    
    let currentText = textField.text ?? ""
    let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
    
    // 1. Here's the first change...
    return allowedIntoTextField(text: prospectiveText)
  }
  
  // 2. ...and here's the second!
  func allowedIntoTextField(text: String) -> Bool {
    return text.characters.count <= maxLength
  }
  
}


// This code is released under the MIT license.
// Simply put, you're free to use this in your own projects, both
// personal and commercial, as long as you include the copyright notice below.
// It would be nice if you mentioned my name somewhere in your documentation
// or credits.
//
// MIT LICENSE
// -----------
// (As defined in https://opensource.org/licenses/MIT)
//
// Copyright © 2016 Joey deVilla. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
