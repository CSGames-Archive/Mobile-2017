//
//  ConversationsControllerImpl.swift
//  CSChat
//
//  Created by Hugo Lefrancois on 2017-03-24.
//  Copyright © 2017 Mirego. All rights reserved.
//

import UIKit

class ConversationsControllerImpl: ConversationsController
{
    private let loginService: LoginService
    private let conversationsService: ConversationsService

    init(loginService: LoginService, conversationsService: ConversationsService)
    {
        self.loginService = loginService
        self.conversationsService = conversationsService
    }

    func allConversations(completion: @escaping (_ conversations: [ConversationViewModel]?) -> (Void))
    {
        guard let loggedUser = loginService.loggedUser else {
            completion(nil)
            return
        }

        conversationsService.allConversations(loggedUser: loggedUser) { (conversationResponse) -> (Void) in
            guard let conversationResponse = conversationResponse, let users = conversationResponse.users else {
                completion(nil)
                return
            }

            var conversationsViewModel: [ConversationViewModel] = []
            if let conversations = conversationResponse.conversations {
                conversations.forEach{
                    conversationsViewModel.append(ConversationViewModelImpl(conversationSummary: $0, users: users, loggedUser: loggedUser))
                }
            }
            completion(conversationsViewModel)
        }
    }
}
