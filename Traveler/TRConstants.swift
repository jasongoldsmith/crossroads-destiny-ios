import UIKit

struct K {
    struct UserDefaultKey {
        
        static let  TR_DID_SHOW_ONBOARDING = "TR_DID_SHOW_ONBOARDING"
        
        struct UserAccountInfo {
            static let TR_UserName      = "TR_UserName"
            static let TR_UserPwd       = "TR_UserPwd"
            static let TR_PsnId         = "TR_PsnId"
            static let TR_UserID        = "TR_UserID"
            static let TR_USER_IMAGE    = "TR_USER_IMAGE"
            static let TR_USER_CLAN_ID  = "TR_USER_CLAN_ID"
            
            
            static let TR_USER_CONSOLE_ID  = "TR_USER_CONSOLE_ID"
            static let TR_USER_BUNGIE_MEMBERSHIP_ID  = "TR_USER_BUNGIE_MEMBERSHIP_ID"
            static let TR_USER_CONSOLE_TYPE  = "TR_USER_CONSOLE_TYPE"
            static let TR_CONSOLE_VERIFIED  = "TR_CONSOLE_VERIFIED"
        }
    }
    
    struct Path {
        static let DocumentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    struct TRUrls {
        
        #if RELEASE
            static let TR_BaseUrl            =   "https://live.crossroadsapp.co"
            static let TR_FIREBASE_DEFAULT   =   "https://crossroadsapp-live.firebaseio.com/"
        #else
            static let TR_BaseUrl            =   "https://travelerbackend.herokuapp.com"
            static let TR_FIREBASE_DEFAULT   =   "https://crossroadsapp-dev.firebaseio.com/"
        #endif
        
        static let TR_RegisterUrl        =   "/api/v1/auth/register"
        static let TR_LoginUrl           =   "/api/v1/auth/login"
        static let TR_LogoutUrl          =   "/api/v1/auth/logout"
        static let TR_EventListUrl       =   "/api/v1/a/event/list"
        static let TR_EventCreationUrl   =   "/api/v1/a/event/create"
        static let TR_ActivityListUrl    =   "/api/v1/activity/list"
        static let TR_JoinEventUrl       =   "/api/v1/a/event/join"
        static let TR_LeaveEventUrl      =   "/api/v1/a/event/leave"
        static let TR_REGISTER_DEVICE    =   "/api/v1/a/installation/ios"
        static let TR_SEND_PUSH_MESSAGE  =   "/api/v1/a/messages/send"
        static let TR_SEND_REPORT        =   "/api/v1/a/report/create"
        static let TR_UPDATE_USER        =   "/api/v1/a/user/update"
        static let TR_FORGOT_PASSWORD    =   "/api/v1/auth/request/resetPassword"
        static let TR_FETCH_EVENT        =   "/api/v1/a/event/listById"
        static let TR_APP_TRACKING       =   "/api/v1/a/mixpanel/track"
        static let TR_GET_GROUPS         =   "/api/v1/a/account/group/list"
        static let TR_UPDATE_GROUPS      =   "/api/v1/a/user/updateGroup"
        static let TR_GET_GROUP_BY_ID    =   "/api/v1/a/account/group/search/"
        static let TR_UPDATE_PASSWORD    =   "/api/v1/a/user/updatePassword"
        static let TR_RESEND_VERIFICATION =  "/api/v1/a/account/group/resendBungieMessage"
        static let TR_BUNGIE_USER_AUTH   =   "/api/v1/auth/checkBungieAccount"
        static let TR_GROUP_NOTI_VALUE   =   "/api/v1/a/account/group/mute"
        static let TR_GET_EVENT          =   "/api/v1/a/event/listById"
    }
    
    struct StoryBoard {
        static let StoryBoard_OnBoarding = "OnBoarding"
        static let StoryBoard_Main       = "Main"
    }
    
    struct VIEWCONTROLLER_IDENTIFIERS {
        
        static let VIEW_CONTROLLER_YATRI                   = "yatriView"
        
        static let VIEWCONTROLLER_LOGIN                    = "login"
        static let VIEWCONTROLLER_SIGNUP                   = "signup"
        static let VIEWCONTROLLER_LOGIN_OPTIONS            = "loginOptions"
        static let VIEWCONTROLLER_EVENT_LIST               = "eventListVC"
        static let VIEWCONTROLLER_CREATE_EVENT             = "createeventvc"
        static let VIEW_CONTROLLER_CREATE_EVENT_ACTIVITY   = "createEventsActivityVC"
        static let VIEW_CONTROLLER_CREATE_EVENT_SELECTION  = "createEventsSelection"
        static let VIEW_CONTROLLER_CREATE_EVENT_CONFIRM    = "createEventConfirmation"
        static let VIEW_CONTROLLER_EVENT_INFORMATION       = "eventInfoVC"
        static let VIEW_CONTROLLER_PROFILE                 = "profileVC"
        static let VIEW_CONTROLLER_SEND_REPORT             = "sendReportVC"
        static let VIEW_CONTROLLER_FORGOT_PASSWORD         = "forgotPassword"
        static let VIEW_CONTROLLER_VERIFY_ACCOUNT          = "verifyAccount"
        static let VIEW_CONTROLLER_CHOOSE_GROUP            = "chooseGroup"
        static let VIEW_CONTROLLER_WEB_VIEW                = "legalWebView"
        static let VIEW_CONTROLLER_BUNGIE_VERIFICATION     = "verifyBungieAccount"
    }
    
    struct ActivityType {
        static let WEEKLY   = "Weekly"
        static let RAIDS    = "Raid"
        static let CRUCIBLE = "Crucible"
        static let ARENA    = "Arena"
        static let STRIKES  = "Strike"
        static let PATROL   = "Patrol"
    }
    
    struct NOTIFICATION_TYPE {
        static let REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION      = "RemoteNotificationWithActiveSesion"
        static let APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION  = "UIApplicationDidReceiveRemoteNotification"
        static let APPLICATION_WILL_TERMINATE                   = "UIApplicationWillTerminateNotification"
        static let APPLICATION_WILL_RESIGN_ACTIVE               = "UIApplicationWillResignActiveNotification"
    }
}

enum EVENT_STATUS : String {
    case CAN_JOIN   = "can_join"
    case FULL       = "full"
    case OPEN       = "open"
    case NEW        = "new"
}

enum EVENT_TIME_STATUS: String {
    case UP_COMING  = "upcoming"
    case CURRENT    = "now"
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

// Used to check what kind of Notification it is.
enum NOTIFICATION_NAME: String {
    case NOTI_LEAVE = "Leave"
    case NOTI_JOIN  = "Join"
    case NOTI_FULL_FOR_CREATOR = "FullForCreator"
    case NOTI_FULL_FOR_EVENT_MEMEBERS = "FullForEventMembers"
    case NOTI_EVENT_FULL = "EventNotFullNotification"
    case NOTI_MESSAGE_PLAYER = "messageFromPlayer"
    
}

enum NOTIFICATION_TRACKABLE: Int {
    case TRACKABLE
}

enum APP_TRACKING_DATA_TYPE: String {
    case TRACKING_EVENT = "event"
    case TRACKING_PUSH_NOTIFICATION = "pushNotification"
}

enum ACCOUNT_VERIFICATION: String {
    case USER_VERIFIED = "VERIFIED"
    case USER_VER_INITIATED = "INITIATED"
    case USER_NOT_VERIFIED = "clan_id_not_set"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}