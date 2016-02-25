import UIKit

struct K {
    struct UserDefaultKey {
        
        static let  TR_DID_SHOW_ONBOARDING = "TR_DID_SHOW_ONBOARDING"
        
        struct UserAccountInfo {
            static let TR_UserName  = "TR_UserName"
            static let TR_UserPwd   = "TR_UserPwd"
            static let TR_PsnId     = "TR_PsnId"
        }
    }
    
    struct Path {
        static let DocumentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    struct TRUrls {
        static let TR_BaseUrl            =   "https://travelerbackend.herokuapp.com"
        static let TR_RegisterUrl        =   "/api/v1/auth/register"
        static let TR_LoginUrl           =   "/api/v1/auth/login"
        static let TR_LogoutUrl          =   "/api/v1/auth/logout"
    }
    
    struct StoryBoard {
        static let StoryBoard_OnBoarding = "OnBoarding"
        static let StoryBoard_Main       = "Main"
    }
    
    struct ViewControllerIdenifier {
        static let ViewController_OnBoarding_Login          = "OnBoarding_Login"
        static let ViewController_OnBoarding_Initial        = "OnBoarding_InitialVC"
        static let ViewController_Main_RootViewController   = "Main_RootViewController"
    }
}