//
//  CommentsVM.swift
//  Tawazon
//
//  Created by mac on 19/09/2022.
//  Copyright © 2022 Inceptiontech. All rights reserved.
//

import Foundation
class CommentsVM: NSObject{
    
    var comments: CommentsModel?
    var service: SessionService!
    
    init(service: SessionService) {
        self.service = service
    }
    
    func fetchComments(session: SessionModel, completion: @escaping (CustomError?) -> Void){
        service.getSessionComments(sessionId: session.id, completion: {
            (commentsModel, error) in
            self.comments = commentsModel
            completion(error)
        })
    }
    
    func addComment(session: SessionModel, content: String, rating: Int, completion: @escaping (CustomError?) -> Void){
        service.addSessionComment(sessionId: session.id, content: content, rating: rating, completion: {
            (error) in
            completion(error)
        })
    }
    
    func updateComment(comment: CommentModel, content: String, rating: Int, completion: @escaping (CustomError?) -> Void){
        service.updateSessionComment(commentId: comment.id!, content: content, rating: rating, completion: {
            (error) in
            completion(error)
        })
    }
}
