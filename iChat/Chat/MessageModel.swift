//
//  MessageModel.swift
//  iChat
//
//  Created by Hugo Silva on 31/08/22.
//

import Foundation

struct Message: Hashable {
  let uuid: String
  let text: String
  let isMe: Bool
  let timestamp: UInt
}
