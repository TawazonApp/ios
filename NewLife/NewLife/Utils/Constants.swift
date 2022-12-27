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
    static let apiUrlV2_1 = "\(baseUrl)/api/v2.1"
    static let apiUrlV2_2 = "\(baseUrl)/api/v2.2"
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
    static let deleteAccount = "\(apiUrlV2)/auth/delete"
    static let userInfoUrl = "\(apiUrlV2)/auth/info"
    static let changePasswordUrl = "\(apiUrl)/auth/update-password"
    static let changeUserNameUrl = "\(apiUrlV2)/auth/info/update"
    static let registerDeviceUrl = "\(apiUrl)/device/register"
    static let notificationStatusUrl = "\(apiUrl)/device/status/update"
    
    //Profile image
    static let profileImageUrl = "\(apiUrl)/auth/update-profile-picture"
    static let removeProfileImageUrl = "\(apiUrl)/auth/remove-profile-picture"

    //Install sources
    static let installSourcesListUrl = "\(apiUrlV2_1)/device/install-sources/list"
    static let installSourcesUpdateUrl = "\(apiUrlV2_1)/device/install-sources/update"
    
    //Goals
    static let goalsListUrl = "\(apiUrl)/goals/list"
    static let goalsUpdateUrl = "\(apiUrl)/goals/update"
    
    //Settings
    static let userSettings = "\(apiUrlV2)/auth/settings/update"
    
    //Home
    static let homeUrl = "\(apiUrl)/home"
    static let homeSectionsUrl = "\(apiUrlV2)/home"
    static let homeSectionsUrlV2_1 = "\(apiUrlV2_1)/home"
    static let homeSectionsWithBannersUrl = "\(apiUrlV2)/app/home"
    static let homeSectionsWithBannersUrlV2_1 = "\(apiUrlV2_1)/app/home"
    static let homeSectionsWithBannersUrlV2_2 = "\(apiUrlV2_2)/app/home"
    static let todaySectionsUrl = "\(apiUrlV2_1)/home/today/sections"
    static let todayQuoteViewUrl = "\(apiUrlV2_1)/quotes/view/{id}"
    static let feelingsListUrl = "\(apiUrlV2_1)/feelings/list"
    static let feelingsSessions = "\(apiUrlV2)/feelings/sessions/list"
    static let updateFeelings = "\(apiUrlV2)/feelings/update"
    static let sectionSessions = "\(apiUrlV2)/sections/sessions/list/{id}"
    static let sectionSessionsV2_1 = "\(apiUrlV2_1)/sections/sessions/list/{id}"
    
    //TawazonTalk
    static let tawazonTalkViewUrl = "\(apiUrlV2_1)/tawazon-talk/view/{id}"
    
    //Series
    static let seriesList = "\(apiUrlV2)/meditations/series/list"

    static let seriesDetails = "\(apiUrlV2)/meditations/series/view/{id}"
    static let seriesCompletedSession = "\(apiUrlV2)/meditations/series/track/{id}"
    
    //Session
    static let categorySessionsListUrl  = "\(apiUrl)/sessions/list/{id}"
    static let categoryDetailsUrl  = "\(apiUrlV2)/sessions/list/{id}"
    static let categoryDetailsUrlV2_1  = "\(apiUrlV2_1)/sessions/list/{id}"
    static let subCategorySessionsListUrl = "\(apiUrl)/sessions/list/{id}"
    static let subCategorySessionsListUrlV2_1 = "\(apiUrlV2_1)/sessions/list/{id}"
    static let subCategorySectionSessionsListUrl = "\(apiUrlV2)/meditations/list/{categoryID}"
    static let sessionsDownloadListUrl = "\(apiUrl)/sessions/downloads/list"
    static let sessionsFavoriteListUrl = "\(apiUrlV2)/user/favourites/list"
    static let sessionsFavoriteListUrlV2_1 = "\(apiUrlV2_1)/user/favourites/list"
    static let addSessionToDownloadUrl = "\(apiUrl)/sessions/downloads/add/{id}"
    static let removeSessionToDownloadUrl = "\(apiUrl)/sessions/downloads/remove/{id}"
    static let rateSession = "\(apiUrl)/sessions/rate/{id}"
    static let sessionInfo = "\(apiUrl)/sessions/info/{id}"
    static let sessionCommentsListUrl = "\(apiUrlV2_1)/items/comments/list/{id}"
    static let sessionWriteCommentUrl = "\(apiUrlV2_1)/items/comments/create/{id}"
    static let sessionUpdateCommentUrl = "\(apiUrlV2_1)/items/comments/update/{id}"
    static let searchSession = "\(apiUrlV2)/sessions/search?q={query}"
    static let searchSessionV2_1 = "\(apiUrlV2_1)/sessions/search?q={query}"
     static let addToFavoritesUrl = "\(apiUrl)/favourites/add"
    static let addToFavoritesUrlV2_1 = "\(apiUrlV2_1)/favourites/add"
     static let removeFromFavoritesUrl = "\(apiUrl)/favourites/delete"
    static let removeFromFavoritesUrlV2_1 = "\(apiUrlV2_1)/favourites/delete"
    static let trackSessionUrl = "\(apiUrlV2)/sessions/track"
    static let sessionInfoDetails = "\(apiUrlV2_1)/sessions/view/{id}"
    static let preparationSessionInfo = "\(apiUrlV2_1)/sessions/prep/view/{id}"
    static let purchaseReceiptUrl = "\(apiUrl)/subscription/apple/verify"
    static let anonymousToken = "$AnonymousToken"
    
    static let registerAppsflyer = "\(apiUrl)/appsflyer/register"
    static let redeemCoupons = "\(apiUrl)/coupons/redeem"
    static let subscriptionsTypes = "\(apiUrlV2)/subscriptions/types"
    static let premiumDetails = "\(apiUrlV2)/premium-pages/view/{id}"
    
    
    static let appleOfferLink = "https://apps.apple.com/redeem?ctx=offercodes&id=1456167174"
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
    static let listenForDuration: TimeInterval = 40
    static let backgroundMusicLevel: Double = 0.1
}
