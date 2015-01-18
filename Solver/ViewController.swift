//
//  ViewController.swift
//  KeyboardCustom
//
//  Created by edi on 09.01.2015.
//  Copyright (c) 2015 edi. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {
    
    @IBOutlet var chars: [UIButton]!
    @IBOutlet var __inputTfd: UITextField!
    @IBOutlet var __keyboardView : UIView!
    @IBOutlet var __webView: UIWebView!
    
    private var __counter:uint = 0;
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        __webView.delegate = self;
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/")! ) );
        
        //ukryj systemowa klawiature / fake na klawiaturze
        __inputTfd.delegate = self;
        __inputTfd.inputView = UIView( frame: CGRectMake(0, 0, 1, 1) );
        
        //schowanie klawiatury
        hideKeyboard(0, delay: 0);
        
        //reklamy
        
        canDisplayBannerAds = true;
        interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Automatic;
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSLog("Requesting")
        self.requestInterstitialAdPresentation()
    }
    
    override func viewDidLayoutSubviews()
    {
        //okragle butony
        var c:UIButton;
        
        for c in chars
        {
            c.layer.masksToBounds = true;
            c.layer.cornerRadius = c.frame.size.height / 2;
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        //println( "touchesBegan \( touches, event ) " );
        
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView( self.view )
        
        println( "point \(point )" );
        println( "keyboardview \( __keyboardView.frame ) " );
        
        println( "is point inside \( CGRectContainsPoint( __keyboardView.frame, point ) )" );
        
        if( CGRectContainsPoint( __keyboardView.frame, point ) )
        {
            return;
        }
        
        hideKeyboard( 1, delay: 0 );
        
        self.view.endEditing(true);
        super.touchesBegan(touches, withEvent: event);
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return false;
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        println( "textFieldDidBeginEditing" )
        
        showKeyboard();
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        println( "textFieldDidEndEditing" )
        
        hideKeyboard( 1, delay: 0 );
    }
    
    @IBAction func actionKeyTouchDown(sender: UIButton)
    {
        println( sender );
        
        sender.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0.95, alpha: 0.1).CGColor;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        return true;
    }
    
    func clearKeyBackgroundColor( sender : UIButton )
    {
         sender.layer.backgroundColor = UIColor.whiteColor().CGColor;
    }
    
    @IBAction func actionKeyPressed(sender: UIButton)
    {
        println( sender.titleLabel?.text );
        
        clearKeyBackgroundColor( sender );
        
        var key:String = sender.titleLabel!.text!;
        
        if( key == "deleteAll")
        {
            __inputTfd.text = "";
            
            return;
        }
        else if( key == "del" )
        {
            __inputTfd.deleteBackward();
            
            return;
        }
        else if( key == "enter")
        {
            self.view.endEditing(true);
            
            hideKeyboard( 1, delay: 0 );
            sendRequest( __inputTfd.text );
            
            return;
        }
        
        //println( str )
        
        __inputTfd.insertText( sender.titleLabel!.text! );
    }
    
    func sendRequest( equationStr__:String )
    {
        println("sendRequest \( equationStr__ )");
        
        __webView.loadRequest( NSURLRequest( URL: NSURL( string: "http://www.geteasysolution.com/" + equationStr__.stringByAddingPercentEscapesUsingEncoding( NSUTF8StringEncoding )! )! ) );
    }
    
    func hideKeyboard( time:NSTimeInterval, delay:NSTimeInterval )
    {
        println("hideKeyboard");
        
        UIView.animateWithDuration( time, delay: delay, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0,  self.__keyboardView.frame.height + 100 )
            },
            completion:
            {
                success in
                println( "keyboard is closed ");
            })
    }
    
    func showKeyboard()
    {
        println("showKeyboard");
        
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5, options: nil, animations:
            {
                self.__keyboardView.transform = CGAffineTransformMakeTranslation(0, 0)
            },
            completion:
            {
                success in
                println( "keyboard is open ");
            })
        
    }
    
    
    //////////////////////////////////////////////////////////
    // uiwebview delegate funcs
    //////////////////////////////////////////////////////////
    
    func webViewDidFinishLoad(webView: UIWebView)
    {
        println( " content of website is loaded \( __counter % 5 )" );
        
        __counter += 1;
        
        if( __counter % 5 == 1 )
        {
            // wywolanie interstitialAd
            self.requestInterstitialAdPresentation()
            
        }
        
    }
    
}

