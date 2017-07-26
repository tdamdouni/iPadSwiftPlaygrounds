//
//  CipherContent.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

public class CipherContent {
    
    public static let uppercaseAlphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", ]
    public static let lowercaseAlphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", ]
    public static let ciphertext = "HTSLWFYZQFYNTSX, XJJPJW! DTZ MFAJ UFXXJI YMJ KNWXY YJXY. KJB JAJW KNSI YMJ UFYM, FSI KJBJW XYNQQ BFQP ZUTS NY. QTTP YT 'S' YT HTSYNSZJ DTZW OTZWSJD. TUJS XJXFRJ."
    public static let plaintext = NSLocalizedString("CONGRATULATIONS, SEEKER! YOU HAVE PASSED THE FIRST TEST. FEW EVER FIND THE PATH, AND FEWER STILL WALK UPON IT. LOOK TO 'N' TO CONTINUE YOUR JOURNEY. OPEN SESAME.", comment: "Decrypted message")
    public static let decryptionKey = 5
    
    public static func shift(inputText: String?, by shift: Int) -> String {
        guard let inputText = inputText else { return "" }
        
        var shiftedString = ""
        for char in inputText.unicodeScalars {
            if char.isAlphabetical {
                
                let alphabet: [String]
                if char.isLowercase {
                    alphabet = lowercaseAlphabet
                } else {
                    alphabet = uppercaseAlphabet
                }
                
                let currentSpot = alphabet.index(of: String(char))
                var newSpot = (currentSpot! + shift) % alphabet.count
                
                if newSpot < 0 {
                    newSpot = newSpot + alphabet.count
                }
                
                shiftedString += alphabet[newSpot]
            } else {
                shiftedString += String(char)
            }
        }
        
        return shiftedString
    }
}
