/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The scene delegate for the main browser for this application.
*/

import UIKit
import os.log

@available(iOS 13.0, *)
class BrowserSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // The session userInfo key (for marking this scene delegate session as the document browser).
    static let documentBrowserIdentifierKey = "browser"
    
    var window: UIWindow?

    class func browserSceneSession() -> UISceneSession? {
        var browserSceneSession: UISceneSession!
        for session in UIApplication.shared.openSessions {
            if session.userInfo![BrowserSceneDelegate.documentBrowserIdentifierKey] != nil {
                browserSceneSession = session
                break
            }
        }
        return browserSceneSession
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Mark this session's userInfo as the main document browser so you can find it among multiple sessions.
        session.userInfo = [BrowserSceneDelegate.documentBrowserIdentifierKey: "main browser"]
    }
    
    // You are being asked to open a document (via Files App -> Share).
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Reveal and import the document at the URL.
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else {
            fatalError("*** The root view is not a document browser ***")
        }

        // Only open the first document you are passed.
        guard let urlContext = URLContexts.first else { return }
       
        let inputURL = urlContext.url
        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: urlContext.options.openInPlace) { (revealedDocumentURL, error) in
            
            // Note that this app supports both open in place and open a copy (if urlContext.options.openInPlace is false, revealedDocumentURL is nil)
            
            Swift.debugPrint("\(urlContext.options.openInPlace)")
            guard error == nil else {
                os_log("*** Failed to reveal the document at %@. Error: %@. ***",
                       log: .default,
                       type: .error,
                       inputURL as CVarArg,
                       error! as CVarArg)
                return
            }
        }
        
        // Present the Document View Controller for the revealed URL.
        documentBrowserViewController.presentDocument(at: inputURL)
    }
    
}
