import Foundation

final class CallStation {
    var stationUsers = [User]()
    var stationCalls = [Call]()
}

extension CallStation: Station {
    func users() -> [User] {
        stationUsers
    }
    
    func add(user: User) {
        if !stationUsers.contains(user) {
            stationUsers.append(user)
        }
    }
    
    func remove(user: User) {
        guard let index = stationUsers.firstIndex(of: user) else { return }
        stationUsers.remove(at: index)
    }
    
    func execute(action: CallAction) -> CallID? {
        let stationCall: Call?
        switch action {
        case .start(from: let from, to: let to):
            if !stationUsers.contains(from) && !stationUsers.contains(to) {
                return nil
            }
            let call: Call
            if !stationUsers.contains(from) || !stationUsers.contains(to) {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
            } else if currentCall(user: to) != nil {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy))
            } else {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .calling)
            }
            stationCall = call
            stationCalls.append(call)
        case .answer(from: let from):
            guard let call = stationCalls.first(where: { $0.outgoingUser == from }) else {
                return nil
            }
            stationCall = call
            if !stationUsers.contains(call.outgoingUser) || !stationUsers.contains(call.incomingUser) {
                stationCall?.status = .ended(reason: .error)
                return nil
            } else {
                stationCall?.status = .talk
            }
        case .end(from: let from):
            stationCall = stationCalls.first { $0.outgoingUser == from || $0.incomingUser == from }
            if let call = stationCall {
                switch call.status {
                case .calling:
                    if stationCall?.outgoingUser == from {
                        stationCall?.status = .ended(reason: .cancel)
                    } else if stationCall?.incomingUser == from {
                        stationCall?.status = .ended(reason: .end)
                    }
                case .talk:
                    stationCall?.status = .ended(reason: .end)
                case .ended:
                    break
                }
            }
        }
        return stationCall?.id
    }
    
    func calls() -> [Call] {
        stationCalls
    }
    
    func calls(user: User) -> [Call] {
        stationCalls.filter { $0.incomingUser == user || $0.outgoingUser == user }
    }
    
    func call(id: CallID) -> Call? {
        stationCalls.first { $0.id == id }
    }
    
    func currentCall(user: User) -> Call? {
        stationCalls.filter { $0.incomingUser == user || $0.outgoingUser == user }.first { $0.status == .calling || $0.status == .talk}
    }
}
