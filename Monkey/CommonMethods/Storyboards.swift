// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit
import SideMenu

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        guard let vc = storyboard().instantiateInitialViewController() else {
            fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
        }
        return vc
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func performSegue<S: StoryboardSegueType>(segue: S, sender: AnyObject? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

// swiftlint:disable file_length
// swiftlint:disable type_body_length

struct StoryboardScene {
    
  
    enum Main: String, StoryboardSceneType {
        
        static let storyboardName = "Main"
        
        
        case AddCard_VCScene = "AddCard_VC"
        static func instantiate_AddCard_VC() -> AddCard_VC {
            guard let vc = StoryboardScene.Main.AddCard_VCScene.viewController() as? AddCard_VC
                else {
                    fatalError("ViewController 'AddCard_VC' is not of the expected class AddCard_VC.")
            }
            return vc
        }
        
        case AddAdress_VCScene = "AddAdress_VC"
        static func instantiate_AddAdress_VC() -> AddAdress_VC {
            guard let vc = StoryboardScene.Main.AddAdress_VCScene.viewController() as? AddAdress_VC
                else {
                    fatalError("ViewController 'AddAdress_VC' is not of the expected class AddAdress_VC.")
            }
            return vc
        }
        
        case WalkthroughViewScene = "WalkthroughViewController"
        static func instantiate_WalkthroughViewController() -> WalkthroughViewController {
            guard let vc = StoryboardScene.Main.WalkthroughViewScene.viewController() as? WalkthroughViewController
                else {
                    fatalError("ViewController 'WalkthroughViewController' is not of the expected class WalkthroughViewController.")
            }
            return vc
        }
        
        
        case Splash1_VCScene = "SplashVC"
        static func instantiateSplash1_VCController() -> SplashVC {
            guard let vc = StoryboardScene.Main.Splash1_VCScene.viewController() as? SplashVC
                else {
                    fatalError("ViewController 'Splash_VC' is not of the expected class Splash_VC.")
            }
            return vc
        }
        
        //RecentlyViewd_VC
        case Splash2_VCScene = "Splash2_VC"
        static func instantiateSplash2_VCController() -> Splash2_VC {
            guard let vc = StoryboardScene.Main.Splash2_VCScene.viewController() as? Splash2_VC
                else {
                    fatalError("ViewController 'Splash2_VC' is not of the expected class Splash2_VC.")
            }
            return vc
        }
        
        //RecentlyViewd_VC
        case Splash3_VCScene = "Splash3_VC"
        static func instantiateSplash3_VCController() -> Splash3_VC {
            guard let vc = StoryboardScene.Main.Splash3_VCScene.viewController() as? Splash3_VC
                else {
                    fatalError("ViewController 'Splash3_VC' is not of the expected class Splash3_VC.")
            }
            return vc
        }
        
        //Home_VC
        case Home_VCScene = "HomeVC"
        static func instantiateHome_ViewController() -> HomeVC {
            guard let vc = StoryboardScene.Main.Home_VCScene.viewController() as? HomeVC
                else {
                    fatalError("ViewController 'HomeVC' is not of the expected class HomeVC.")
            }
            return vc
        }
        
        //RestaurantMenuMXVC
        case RestaurantMenuMXVCScene = "RestaurantMenuMXVC"
        static func instantiateRestaurantMenuMXVC() -> RestaurantMenuMXVC{
            guard let vc = StoryboardScene.Main.RestaurantMenuMXVCScene.viewController() as? RestaurantMenuMXVC
                else{
                    fatalError("ViewController 'RestaurantMenuMXVC' is not of the expected class HomeVC.")
            }
            return vc
        }
        
        //RecentlyViewd_VC
        case RecentlyViewd_VCScene = "RecentlyViewd_VC"
        static func instantiateRecentlyViewdController() -> RecentlyViewd_VC {
            guard let vc = StoryboardScene.Main.RecentlyViewd_VCScene.viewController() as? RecentlyViewd_VC
                else {
                    fatalError("ViewController 'RecentlyViewd_VC' is not of the expected class RecentlyViewd_VC.")
            }
            return vc
        }
        
        //SideMenu_VC
        case SideMenuVCScene = "SideMenuVC"
        static func instantiateSideMenuController() -> SideMenuVC {
            guard let vc = StoryboardScene.Main.SideMenuVCScene.viewController() as? SideMenuVC
                else {
                    fatalError("ViewController 'SideMenuVC' is not of the expected class SideMenuVC.")
            }
            return vc
        }
        
        //SlideNavigation
        case SlideNavigationControllerScene = "SlideNavigationController"
        static func instantiateSlideNavigationController() -> SlideNavigationController {
            guard let vc = StoryboardScene.Main.SlideNavigationControllerScene.viewController() as? SlideNavigationController
                else {
                    fatalError("ViewController 'SlideNavigationController' is not of the expected class SlideNavigationController.")
            }
            return vc
        }
        
        //MyAccountMAin
        case MyAccountMainControllerScene = "MyAccount_MainVC"
        static func instantiateMyAccountMainController() -> MyAccount_MainVC {
            guard let vc = StoryboardScene.Main.MyAccountMainControllerScene.viewController() as? MyAccount_MainVC
                else {
                    fatalError("ViewController 'MyAccount_VC' is not of the expected class MyAccount_MainVC.")
            }
            return vc
        }
        
        //MyAccount
        case MyAccountControllerScene = "MyAccount_VC"
        static func instantiateMyAccountController() -> MyAccount_VC {
            guard let vc = StoryboardScene.Main.MyAccountControllerScene.viewController() as? MyAccount_VC
                else {
                    fatalError("ViewController 'MyAccount_VC' is not of the expected class MyAccount_VC.")
            }
            return vc
        }
        
        //EditAccount
        case EditAccount_VCScene = "EditAccount_VC"
        static func instantiateEditAccount_VC() -> EditAccount_VC {
            guard let vc = StoryboardScene.Main.EditAccount_VCScene.viewController() as? EditAccount_VC
                else {
                    fatalError("ViewController 'EditAccount_VC' is not of the expected class EditAccount_VC.")
            }
            return vc
        }
        
        //LOgin
        case LoginControllerScene = "LoginVC"
        static func instantiateLoginController() -> LoginVC {
            guard let vc = StoryboardScene.Main.LoginControllerScene.viewController() as? LoginVC
                else {
                    fatalError("ViewController 'LoginVC' is not of the expected class LoginVC.")
            }
            return vc
        }
        
        //SIgnup_VC
        case SIgnupControllerScene = "SIgnup_VC"
        static func instantiateSIgnupController() -> SIgnup_VC {
            guard let vc = StoryboardScene.Main.SIgnupControllerScene.viewController() as? SIgnup_VC
                else {
                    fatalError("ViewController 'SIgnup_VC' is not of the expected class SIgnup_VC.")
            }
            return vc
        }
        
        //ReferFriend_VC
        case ReferFriendControllerScene = "ReferFriend_VC"
        static func instantiateReferFriendController() -> ReferFriend_VC {
            guard let vc = StoryboardScene.Main.ReferFriendControllerScene.viewController() as? ReferFriend_VC
                else {
                    fatalError("ViewController 'ReferFriend_VC' is not of the expected class ReferFriend_VC.")
            }
            return vc
        }
        
        //Order_VC
        case OrderControllerScene = "Order_VC"
        static func instantiateOrderController() -> Order_VC {
            guard let vc = StoryboardScene.Main.OrderControllerScene.viewController() as? Order_VC
                else {
                    fatalError("ViewController 'Order_VC' is not of the expected class Order_VC.")
            }
            return vc
        }
        
        //HelpVC
        case HelpControllerScene = "HelpVC"
        static func instantiateHelpController() -> HelpVC {
            guard let vc = StoryboardScene.Main.HelpControllerScene.viewController() as? HelpVC
                else {
                    fatalError("ViewController 'HelpVC' is not of the expected class HelpVC.")
            }
            return vc
        }
        
        //SettingsVC
        case SettingsControllerScene = "SettingsVC"
        static func instantiateSettingsController() -> SettingsVC {
            guard let vc = StoryboardScene.Main.SettingsControllerScene.viewController() as? SettingsVC
                else {
                    fatalError("ViewController 'SettingsVC' is not of the expected class SettingsVC.")
            }
            return vc
        }
        
        //TermsVC
        case TermControllerScene = "TermsVC"
        static func instantiateTermsController() -> TermsVC {
            guard let vc = StoryboardScene.Main.TermControllerScene.viewController() as? TermsVC
                else {
                    fatalError("ViewController 'TermsVC' is not of the expected class TermsVC.")
            }
            return vc
        }
        
        //EditAdress_VC
        case EditAdressControllerScene = "EditAdress_VC"
        static func instantiateEditAdressController() -> EditAdress_VC {
            guard let vc = StoryboardScene.Main.EditAdressControllerScene.viewController() as? EditAdress_VC
                else {
                    fatalError("ViewController 'EditAdress_VC' is not of the expected class EditAdress_VC.")
            }
            return vc
        }
        
        //SendOTPVC
        case SendOTPControllerScene = "SendOTPVC"
        static func instantiateSendOTPController() -> SendOTPVC {
            guard let vc = StoryboardScene.Main.SendOTPControllerScene.viewController() as? SendOTPVC
                else {
                    fatalError("ViewController 'SendOTPVC' is not of the expected class SendOTPVC.")
            }
            return vc
        }
        
        //ForgotPwd_emailVC
        case ForgotPwd_emailControllerScene = "ForgotPwd_emailVC"
        static func instantiateForgotPwd_emailController() -> ForgotPwd_emailVC {
            guard let vc = StoryboardScene.Main.ForgotPwd_emailControllerScene.viewController() as? ForgotPwd_emailVC
                else {
                    fatalError("ViewController 'ForgotPwd_emailVC' is not of the expected class ForgotPwd_emailVC.")
            }
            return vc
        }
        
        //FilterController
        case FilterControllerScene = "Filter_VC"
        static func instantiateFilterController() -> Filter_VC {
            guard let vc = StoryboardScene.Main.FilterControllerScene.viewController() as? Filter_VC
                else {
                    fatalError("ViewController 'Filter_VC' is not of the expected class Filter_VC.")
            }
            return vc
        }
        
        //CheckOut_VC
        case CheckOut_VCScene = "CheckOut_VC"
        static func instantiateCheckOut_VC() -> CheckOut_VC {
            guard let vc = StoryboardScene.Main.CheckOut_VCScene.viewController() as? CheckOut_VC
                else {
                    fatalError("ViewController 'CheckOut_VC' is not of the expected class CheckOut_VC.")
            }
            return vc
        }
        
        //CheckOutAddress_VC
        case CheckOutAddress_VCScene = "CheckOutAddress_VC"
        static func instantiateCheckOutAddress_VC() -> CheckOutAddress_VC {
            guard let vc = StoryboardScene.Main.CheckOutAddress_VCScene.viewController() as? CheckOutAddress_VC
                else {
                    fatalError("ViewController 'CheckOutAddress_VC' is not of the expected class CheckOutAddress_VC.")
            }
            return vc
        }
        
        //EditCart_VC
        case EditCart_VCScene = "EditCart_VC"
        static func instantiateEditCart_VC() -> EditCart_VC {
            guard let vc = StoryboardScene.Main.EditCart_VCScene.viewController() as? EditCart_VC
                else {
                    fatalError("ViewController 'EditCart_VC' is not of the expected class EditCart_VC.")
            }
            return vc
        }
        
        //AddToCartVC
        case AddToCartVCScene = "AddToCartVC"
        static func instantiateAddToCartVC() -> AddToCartVC {
            guard let vc = StoryboardScene.Main.AddToCartVCScene.viewController() as? AddToCartVC
                else {
                    fatalError("ViewController 'AddToCartVC' is not of the expected class AddToCartVC.")
            }
            return vc
        }
        
        //CompleteYourPaymentVC
        case CompleteYourPaymentVCScene = "CompleteYourPaymentVC"
        static func instantiateCompleteYourPaymentVC() -> CompleteYourPaymentVC {
            guard let vc = StoryboardScene.Main.CompleteYourPaymentVCScene.viewController() as? CompleteYourPaymentVC
                else {
                    fatalError("ViewController 'CompleteYourPaymentVC' is not of the expected class CompleteYourPaymentVC.")
            }
            return vc
        }
    }
    
    enum Alert: String, StoryboardSceneType
    {
        static let storyboardName = "Alert"
        //AlertVC
        case AlertVCScene = "AlertVC"
        static func instantiateAlertController() -> AlertVC {
            guard let vc = StoryboardScene.Alert.AlertVCScene.viewController() as? AlertVC
                else {
                    fatalError("ViewController 'AlertVC' is not of the expected class AlertVC.")
            }
            return vc
        }
        
        //AlertWithTwoOptionVC
        case AlertWithTwoOptionVCScene = "AlertWithTwoOptionVC"
        static func instantiateAlertWithTwoOptionController() -> AlertWithTwoOptionVC {
            guard let vc = StoryboardScene.Alert.AlertWithTwoOptionVCScene.viewController() as? AlertWithTwoOptionVC
                else {
                    fatalError("ViewController 'AlertWithTwoOptionVC' is not of the expected class AlertWithTwoOptionVC.")
            }
            return vc
        }
        
        //EmailAlert
        case EmailAlertVCScene = "EmailAlert"
        static func instantiateEmailAlertController() -> EmailAlert {
            guard let vc = StoryboardScene.Alert.EmailAlertVCScene.viewController() as? EmailAlert
                else {
                    fatalError("ViewController 'EmailAlert' is not of the expected class EmailAlert.")
            }
            return vc
        }
        
        //CohostRemovalAlert
        case CohostRemovalAlertVCScene = "CohostRemovalAlert"
        static func instantiateCohostRemovalAlertController() -> CohostRemovalAlert {
            guard let vc = StoryboardScene.Alert.CohostRemovalAlertVCScene.viewController() as? CohostRemovalAlert
                else {
                    fatalError("ViewController 'CohostRemovalAlert' is not of the expected class CohostRemovalAlert.")
            }
            return vc
        }
        
        //EventActionAlert
        case EventActionAlertVCScene = "EventActionAlert"
        static func instantiateEventActionAlertController() -> EventActionAlert {
            guard let vc = StoryboardScene.Alert.EventActionAlertVCScene.viewController() as? EventActionAlert
                else {
                    fatalError("ViewController 'EventActionAlert' is not of the expected class EventActionAlert.")
            }
            return vc
        }
        
        //AttendeLeaveGropuAlert
        case AttendeLeaveGropuAlertVCScene = "AttendeLeaveGropuAlert"
        static func instantiateAttendeLeaveGropuAlertController() -> AttendeLeaveGropuAlert {
            guard let vc = StoryboardScene.Alert.AttendeLeaveGropuAlertVCScene.viewController() as? AttendeLeaveGropuAlert
                else {
                    fatalError("ViewController 'AttendeLeaveGropuAlert' is not of the expected class AttendeLeaveGropuAlert.")
            }
            return vc
        }
    }
 
}

struct StoryboardSegue {
    enum Home: String, StoryboardSegueType {
        case segueMenu = "segueMenu"
    }
}

