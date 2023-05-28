//
//  LoggerViewController.swift
//  UIKitTester
//
//  Created by Oliver on 2023/05/28.
//

import UIKit

final class LoggerViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Log.network("디버깅 테스트")
    }
}

/*
 실제 출력 내용
2023-05-13 17:53:13.655544+0900 TesterForMiscellaneousFunctionsInUIKit[24008:388757] [Network] ⚠️[TesterForMiscellaneousFunctionsInUIKit/ViewController.swift] [Line: 18] 디버깅 테스트 ⚠️
 */
