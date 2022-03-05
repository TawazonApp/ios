//
//  Constants.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation

struct Api {
    static let baseUrl = "https://api.tawazonapp.com"
    //static let baseUrl = "https://api.dev.tawazonapp.com"
    static let apiUrl = "\(baseUrl)/api/v1"
    static let apiUrlV2 = "\(baseUrl)/api/v2"
    static let authorization = "$2y$08$SUh5WUM4STdKZmtYOHh5duA2bPXmyg7BmzxORifly3mDit6oU4Y1y"
    
    //Tracking
    static let trackingUrl = "\(apiUrlV2)/firebase/dynamic-links/events/log"
    
   //Membership
    static let loginUrl = "\(apiUrl)/auth/login"
    static let appleLoginUrl = "\(apiUrl)/auth/login/apple"
   
    static let facebookLoginUrl = "\(apiUrl)/auth/login/social/facebook"
    static let registerUrl = "\(apiUrl)/auth/register"
    static let logoutUrl = "\(apiUrl)/auth/logout"
    static let forgetPasswordUrl = "\(apiUrl)/auth/forget-password"
    static let resetPasswordUrl = "\(apiUrl)/auth/reset-password"
    static let userInfoUrl = "\(apiUrlV2)/auth/info"
    static let changePasswordUrl = "\(apiUrl)/auth/update-password"
    static let changeUserNameUrl = "\(apiUrl)/auth/info/update"
    static let registerDeviceUrl = "\(apiUrl)/device/register"
    static let notificationStatusUrl = "\(apiUrl)/device/status/update"
    
    //Profile image
    static let profileImageUrl = "\(apiUrl)/auth/update-profile-picture"
    static let removeProfileImageUrl = "\(apiUrl)/auth/remove-profile-picture"

    //Goals
    static let goalsListUrl = "\(apiUrl)/goals/list"
    static let goalsUpdateUrl = "\(apiUrl)/goals/update"
    
    //Home
    static let homeUrl = "\(apiUrl)/home"
    static let homeSectionsUrl = "\(apiUrlV2)/home"
    static let feelingsListUrl = "\(apiUrlV2)/feelings/list"
    static let feelingsSessions = "\(apiUrlV2)/feelings/sessions/list"
    static let updateFeelings = "\(apiUrlV2)/feelings/update"
    static let sectionSessions = "\(apiUrlV2)/sections/sessions/list/{id}"
    
    //Session
    static let categorySessionsListUrl  = "\(apiUrl)/sessions/list/{id}"
    static let categoryDetailsUrl  = "\(apiUrlV2)/sessions/list/{id}"
    static let subCategorySessionsListUrl = "\(apiUrl)/sessions/list/{id}"
    static let subCategorySectionSessionsListUrl = "\(apiUrlV2)/meditations/list/{categoryID}"
    static let sessionsDownloadListUrl = "\(apiUrl)/sessions/downloads/list"
    static let sessionsFavoriteListUrl = "\(apiUrlV2)/user/favourites/list"
    static let addSessionToDownloadUrl = "\(apiUrl)/sessions/downloads/add/{id}"
    static let removeSessionToDownloadUrl = "\(apiUrl)/sessions/downloads/remove/{id}"
    static let rateSession = "\(apiUrl)/sessions/rate/{id}"
    static let sessionInfo = "\(apiUrl)/sessions/info/{id}"
    
     static let addToFavoritesUrl = "\(apiUrl)/favourites/add"
     static let removeFromFavoritesUrl = "\(apiUrl)/favourites/delete"
    static let trackSessionUrl = "\(apiUrlV2)/sessions/track"
    
    static let purchaseReceiptUrl = "\(apiUrl)/subscription/apple/verify"
    static let anonymousToken = "$AnonymousToken"
    
    static let registerAppsflyer = "\(apiUrl)/appsflyer/register"
    static let redeemCoupons = "\(apiUrl)/coupons/redeem"
    static let subscriptionsTypes = "\(apiUrlV2)/subscriptions/types"
}

struct APPInfo {
    static let appShareUrl = "https://tawazon.page.link/app"
    static let appId = "1456167174"
    static let appRateUrl = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1)"
    static let supportEmail = "info@tawazonapp.com"
}

enum PremiumPurchase: String {
    
    case lifetime = "com.newlife.apps.newlife.purchase.unlock.lifetime"
    case monthly = "com.newlife.apps.newlife.purchase.unlock.monthly"
    case yearly = "com.newlife.apps.newlife.purchase.unlock.yearly"
    case halfYearly = "com.newlife.apps.newlife.purchase.unlock.halfyearly"
     case threeMonth = "com.newlife.apps.newlife.purchase.unlock.threemonthly"
    case coupon = "com.newlife.apps.newlife.purchase.unlock.coupon"
    static let allProducts: [PremiumPurchase]  = [.monthly, .threeMonth, .halfYearly, .yearly]
    
    func getPlan() -> String {
        switch self {
        case .monthly:
            return "monthly"
        case .yearly:
            return "yearly"
        case .halfYearly:
            return "halfYearly"
        case .lifetime:
            return "lifetime"
        case .threeMonth:
            return "threeMonth"
        case .coupon:
            return "coupon"
        }
    }
    
    var eventPeriodName: String {
        switch self {
        case .monthly:
            return "monthly"
        case .yearly:
            return "yearly"
        case .halfYearly:
            return "semi_yearly"
        case .lifetime:
            return "life_time"
        case .threeMonth:
            return "quarterly"
        case .coupon:
            return "coupon"
        }
    }
    
}

enum Constants {
    static let appsFlyerDevKey = "FaJiLhP57L5T9KhDcypEmh"
    static let lockFreeDuration: TimeInterval = 0
}
