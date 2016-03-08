import UIKit

struct K {
    struct UserDefaultKey {
        
        static let  TR_DID_SHOW_ONBOARDING = "TR_DID_SHOW_ONBOARDING"
        
        struct UserAccountInfo {
            static let TR_UserName  = "TR_UserName"
            static let TR_UserPwd   = "TR_UserPwd"
            static let TR_PsnId     = "TR_PsnId"
            static let TR_UserID    = "TR_UserID"
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
        static let TR_EventListUrl       =   "/api/v1/a/event/list"
        static let TR_EventCreationUrl   =   "/api/v1/a/event/create"
        static let TR_ActivityListUrl    =   "/api/v1/activity/list"
        static let TR_JoinEventUrl       =   "/api/v1/a/event/join"
        static let TR_LeaveEventUrl      =   "/api/v1/a/event/leave"
    }
    
    struct StoryBoard {
        static let StoryBoard_OnBoarding = "OnBoarding"
        static let StoryBoard_Main       = "Main"
    }
    
    struct ViewControllerIdenifier {
        static let VIEWCONTROLLER_LOGIN                    = "login"
        static let VIEWCONTROLLER_SIGNUP                   = "signup"
        static let VIEWCONTROLLER_EVENT_LIST               = "eventListVC"
        static let VIEWCONTROLLER_CREATE_EVENT             = "createeventvc"
        static let VIEW_CONTROLLER_CREATE_EVENT_ACTIVITY   = "createEventsActivityVC"
    }
}

enum EVENT_STATUS : String {
    case CAN_JOIN   = "can_join"
    case FULL       = "full"
    case OPEN       = "open"
    case NEW        = "new"
}
