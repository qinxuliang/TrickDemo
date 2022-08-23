//
//  ViewController.swift
//  SwiftHotPatch
//
//  Created by hanling on 2022/8/22.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        patch_init();
        TestClass().hehe()
        // Do any additional setup after loading the view.
    }
}

public class TestClass: NSObject {
    public func hehe() {
       print("\(#function) in \(type(of: self))");
        hehe1()
    }
    
    public func hehe1() {
        print("hehe1")
    }
}

