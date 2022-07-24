//
//  MembershipService.swift
//  NewLife
//
//  Created by Shadi on 11/03/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import UIKit

protocol MembershipService {
    
    func login(data: LoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void)
    
    func appleLogin(data: AppleLoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void)
    
    func facebookLogin(data: FacebookLoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void)
    
    func register(data: RegisterModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void)
    
    func logout(completion: @escaping (_ error: CustomError?) -> Void)
    
    func deleteAccount(completion: @escaping (DeleteAccountModel?, CustomError?) -> Void)
    
    func fetchUserInfo(completion: @escaping (_ userInfo: UserInfoModel?, _ error: CustomError?) -> Void)
    
    func uploadProfileImage(image: UIImage, completion: @escaping (_ error: CustomError?) -> Void)
    
    func removeProfileImage(completion: @escaping (_ error: CustomError?) -> Void)
    
    func fetchUserGoals(completion: @escaping (_ goals: GoalsModel?, _ error: CustomError?) -> Void)
    
    func setUserGoals(selectedGoalsIds: GoalsIdsModel, completion: @escaping (_ error: CustomError?) -> Void)
    
    func forgetPassword(data: ForgetPasswordModel, completion: @escaping (CustomError?) -> Void)
    
    func resetPassword(data: ResetPasswordModel, completion: @escaping (CustomError?) -> Void)
    
     func changePassword(data: ChangePasswordModel, completion: @escaping (CustomError?) -> Void)
    
     func changeUserName(data: ChangeUserNameModel, completion: @escaping (_ userInfo: UserInfoModel?, CustomError?) -> Void)
    
    func sendFcm(data: FCMModel, completion: @escaping (CustomError?) -> Void)
    
    func changeNotificationStatus(data: NotificationStatusModel, completion: @escaping (CustomError?) -> Void)
    
    func notificationStatus(completion: @escaping (_ notification: NotificationStatusModel?, CustomError?) -> Void)
    
    func uploadPurchaseReceipt(receiptString: String, price: String, currency: String, completion: @escaping (CustomError?) -> Void)
    
    func registerAppsflyer(id: String, advertisingId: String, completion: @escaping (CustomError?) -> Void)
    
    func submitPromoCode(promoCode: String, completion: @escaping (CustomError?) -> Void)
    
    func getSubscriptionsTypes(completion: @escaping (SubscriptionTypes?, CustomError?) -> Void)
    
    func getPremiumDetails(viewId: Int, completion: @escaping (BasePremiumModel?, CustomError?) -> Void)
    
}

class APIMembershipService: MembershipService {
    
    func login(data: LoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.loginUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            
            let membership : MembershipModel? = (data != nil) ? MembershipModel.init(data: data!) : nil
            completion(membership, error)
        }
    }
    
    
    func appleLogin(data: AppleLoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.appleLoginUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            let membership : MembershipModel? = (data != nil) ? MembershipModel.init(data: data!) : nil
            completion(membership, error)
        }
    }
    
    func facebookLogin(data: FacebookLoginModel, completion: @escaping (_ session: MembershipModel?, _ error: CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.facebookLoginUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            
            let membership : MembershipModel? = (data != nil) ? MembershipModel.init(data: data!) : nil
            completion(membership, error)
        }
    }
    
    func register(data: RegisterModel, completion: @escaping (MembershipModel?, CustomError?) -> Void) {

        ConnectionUtils.performPostRequest(url: Api.registerUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            
            let membership : MembershipModel? = (data != nil) ? MembershipModel.init(data: data!) : nil
            completion(membership, error)
        }
    }
    
    func forgetPassword(data: ForgetPasswordModel, completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.forgetPasswordUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func resetPassword(data: ResetPasswordModel, completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.resetPasswordUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func logout(completion: @escaping (_ error: CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.logoutUrl.url!, parameters: nil) { (data, error) in
            completion(error)
        }
    }
    
    func deleteAccount(completion: @escaping (DeleteAccountModel?, CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.deleteAccount.url!, parameters: nil) { (data, error) in
            let deleteAccountModel : DeleteAccountModel? = (data != nil) ? DeleteAccountModel.init(data: data!) : nil
            completion(deleteAccountModel, error)
        }
    }
    
    func fetchUserInfo(completion: @escaping (_ userInfo: UserInfoModel?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.userInfoUrl.url!, parameters: nil) { (data, error) in
            let userInfo : UserInfoModel? = (data != nil) ? UserInfoModel.init(data: data!) : nil
            completion(userInfo, error)
        }
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (_ error: CustomError?) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(CustomError(message: "generalErrorMessage".localized, statusCode: nil))
            return
        }
        
        ConnectionUtils.performUploadRequest(data: imageData, name: "file", fileName: "file.jpeg", mimeType: "image/jpeg", url: Api.profileImageUrl.url!, parameters: nil, completion: { (error) in
            completion(error)
        })
    }
    
    func removeProfileImage(completion: @escaping (_ error: CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.removeProfileImageUrl.url!, parameters: nil){ (data, error) in
            completion(error)
        }
    }
    
    func fetchUserGoals(completion: @escaping (_ goals: GoalsModel?, _ error: CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.goalsListUrl.url!, parameters: nil) { (data, error) in
            
            let goals : GoalsModel? = (data != nil) ? GoalsModel.init(data: data!) : nil
            completion(goals, error)
        }
    }
    
    func setUserGoals(selectedGoalsIds: GoalsIdsModel, completion: @escaping (_ error: CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.goalsUpdateUrl.url!, parameters: try? selectedGoalsIds.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func changePassword(data: ChangePasswordModel, completion: @escaping (CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.changePasswordUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
   func changeUserName(data: ChangeUserNameModel, completion: @escaping (_ userInfo: UserInfoModel?, CustomError?) -> Void) {
        
        ConnectionUtils.performPostRequest(url: Api.changeUserNameUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
             let userInfo : UserInfoModel? = (data != nil) ? UserInfoModel.init(data: data!) : nil
            completion(userInfo, error)
        }
    }
    
    func sendFcm(data: FCMModel, completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.registerDeviceUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func changeNotificationStatus(data: NotificationStatusModel, completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.notificationStatusUrl.url!, parameters: try? data.jsonDictionary()) { (data, error) in
            completion(error)
        }
    }
    
    func notificationStatus(completion: @escaping (_ notification: NotificationStatusModel?, CustomError?) -> Void) {
        
        ConnectionUtils.performGetRequest(url: Api.notificationStatusUrl.url!, parameters: nil) { (data, error) in
            let notification: NotificationStatusModel? = (data != nil) ? NotificationStatusModel(data: data!) : nil
            completion(notification, error)
        }
    }
    
    func uploadPurchaseReceipt(receiptString: String, price: String, currency: String,  completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.purchaseReceiptUrl.url!, parameters: ["receipt-data": receiptString, "price" : price, "currency": currency]) { (data, error) in
            completion(error)
        }
    }
    
    func registerAppsflyer(id: String, advertisingId: String, completion: @escaping (CustomError?) -> Void) {
        ConnectionUtils.performPostRequest(url: Api.registerAppsflyer.url!, parameters: ["appsflyer_id": id, "idfa": advertisingId]) { (_, error) in
            completion(error)
        }
    }
    
    func submitPromoCode(promoCode: String, completion: @escaping (CustomError?) -> Void) {
        let parameters = ["code": promoCode]
        ConnectionUtils.performPostRequest(url: Api.redeemCoupons.url!, parameters: parameters) { (_, error) in
            completion(error)
        }
    }
    
    func getSubscriptionsTypes(completion: @escaping (SubscriptionTypes?, CustomError?) -> Void) {
        ConnectionUtils.performGetRequest(url: Api.subscriptionsTypes.url!, parameters: nil) { (data, error) in
            let subscriptionTypes : SubscriptionTypes? = (data != nil) ? SubscriptionTypes.init(data: data!) : nil
            completion(subscriptionTypes, error)
        }
    }
    
    func getPremiumDetails(viewId: Int, completion: @escaping (BasePremiumModel?, CustomError?) -> Void) {
        let path = Api.premiumDetails.replacingOccurrences(of: "{id}", with: String(viewId)).url
        ConnectionUtils.performGetRequest(url: path!, parameters: nil, completion: { (data, error) in
            let premiumDetails : BasePremiumModel? = (data != nil) ? BasePremiumModel.init(data: data!) : nil
            completion(premiumDetails, error)
        })
    }
}

class MembershipServiceFactory {
    
    static func service() -> MembershipService {
        return APIMembershipService()
    }
}
