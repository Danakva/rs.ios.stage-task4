import Foundation

typealias CallID = UUID

class Call {
    let id: CallID
    let incomingUser: User
    let outgoingUser: User
    var status: CallStatus
    
    init(id: CallID, incomingUser: User, outgoingUser: User, status: CallStatus) {
        self.id = id
        self.incomingUser = incomingUser
        self.outgoingUser = outgoingUser
        self.status = status
    }
}

enum CallEndReason: Equatable {
    case cancel // Call was canceled before the other user answered
    case end // Call ended after successful conversation
    case userBusy // Call ended because the user is busy
    case error
}

enum CallStatus: Equatable {
    case calling
    case talk
    case ended(reason: CallEndReason)
}

