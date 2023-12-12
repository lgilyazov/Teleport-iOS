import Foundation
import Postbox
import SwiftSignalKit
import TelegramApi
import MtProtoKit


public enum UpdatePeerTitleError {
    case generic
}

func _internal_updatePeerTitle(account: Account, peerId: PeerId, title: String) -> Signal<Void, UpdatePeerTitleError> {
    let accountPeerId = account.peerId
    return account.postbox.transaction { transaction -> Signal<Void, UpdatePeerTitleError> in
        if let peer = transaction.getPeer(peerId) {
            if let peer = peer as? TelegramChannel, let inputChannel = apiInputChannel(peer) {
                return account.network.request(Api.functions.channels.editTitle(channel: inputChannel, title: title))
                    |> mapError { _ -> UpdatePeerTitleError in
                        return .generic
                    }
                    |> mapToSignal { result -> Signal<Void, UpdatePeerTitleError> in
                        account.stateManager.addUpdates(result)
                        
                        return account.postbox.transaction { transaction -> Void in
                            if let apiChat = apiUpdatesGroups(result).first {
                                let parsedPeers = AccumulatedPeers(transaction: transaction, chats: [apiChat], users: [])
                                updatePeers(transaction: transaction, accountPeerId: accountPeerId, peers: parsedPeers)
                            }
                        } |> mapError { _ -> UpdatePeerTitleError in }
                    }
            } else if let peer = peer as? TelegramGroup {
                return account.network.request(Api.functions.messages.editChatTitle(chatId: peer.id.id._internalGetInt64Value(), title: title))
                    |> mapError { _ -> UpdatePeerTitleError in
                        return .generic
                    }
                    |> mapToSignal { result -> Signal<Void, UpdatePeerTitleError> in
                        account.stateManager.addUpdates(result)
                        
                        return account.postbox.transaction { transaction -> Void in
                            if let apiChat = apiUpdatesGroups(result).first {
                                let parsedPeers = AccumulatedPeers(transaction: transaction, chats: [apiChat], users: [])
                                updatePeers(transaction: transaction, accountPeerId: accountPeerId, peers: parsedPeers)
                            }
                        } |> mapError { _ -> UpdatePeerTitleError in }
                    }
            } else {
                return .fail(.generic)
            }
        } else {
            return .fail(.generic)
        }
    } |> mapError { _ -> UpdatePeerTitleError in } |> switchToLatest
}

public enum UpdatePeerDescriptionError {
    case generic
}

func _internal_updatePeerDescription(account: Account, peerId: PeerId, description: String?) -> Signal<Void, UpdatePeerDescriptionError> {
    return account.postbox.transaction { transaction -> Signal<Void, UpdatePeerDescriptionError> in
        if let peer = transaction.getPeer(peerId) {
            if (peer is TelegramChannel || peer is TelegramGroup), let inputPeer = apiInputPeer(peer) {
                return account.network.request(Api.functions.messages.editChatAbout(peer: inputPeer, about: description ?? ""))
                |> mapError { _ -> UpdatePeerDescriptionError in
                    return .generic
                }
                |> mapToSignal { result -> Signal<Void, UpdatePeerDescriptionError> in
                    return account.postbox.transaction { transaction -> Void in
                        if case .boolTrue = result {
                            transaction.updatePeerCachedData(peerIds: Set([peerId]), update: { _, current in
                                if let current = current as? CachedChannelData {
                                    return current.withUpdatedAbout(description)
                                } else if let current = current as? CachedGroupData {
                                    return current.withUpdatedAbout(description)
                                } else {
                                    return current
                                }
                            })
                        }
                    }
                    |> mapError { _ -> UpdatePeerDescriptionError in }
                }
            } else {
                return .fail(.generic)
            }
        } else {
            return .fail(.generic)
        }
    } |> mapError { _ -> UpdatePeerDescriptionError in } |> switchToLatest
}

public enum UpdatePeerNameColorAndEmojiError {
    case generic
    case channelBoostRequired
}

func _internal_updatePeerNameColorAndEmoji(account: Account, peerId: EnginePeer.Id, nameColor: PeerNameColor, backgroundEmojiId: Int64?, profileColor: PeerNameColor?, profileBackgroundEmojiId: Int64?) -> Signal<Void, UpdatePeerNameColorAndEmojiError> {
    return account.postbox.transaction { transaction -> Signal<Void, UpdatePeerNameColorAndEmojiError> in
        if let peer = transaction.getPeer(peerId) {
            if let peer = peer as? TelegramChannel, let inputChannel = apiInputChannel(peer) {
                let flagsReplies: Int32 = (1 << 0) | (1 << 2)
                
                var flagsProfile: Int32 = (1 << 0) | (1 << 2)
                if profileColor != nil {
                    flagsProfile |= (1 << 1)
                }
                
                return combineLatest(
                    account.network.request(Api.functions.channels.updateColor(flags: flagsReplies, channel: inputChannel, color: nameColor.rawValue, backgroundEmojiId: backgroundEmojiId ?? 0))
                    |> map(Optional.init)
                    |> `catch` { error -> Signal<Api.Updates?, MTRpcError> in
                        if error.errorDescription.hasPrefix("CHAT_NOT_MODIFIED") {
                            return .single(nil)
                        } else {
                            return .fail(error)
                        }
                    },
                    account.network.request(Api.functions.channels.updateColor(flags: flagsProfile, channel: inputChannel, color: profileColor?.rawValue, backgroundEmojiId: profileBackgroundEmojiId ?? 0))
                    |> map(Optional.init)
                    |> `catch` { error -> Signal<Api.Updates?, MTRpcError> in
                        if error.errorDescription.hasPrefix("CHAT_NOT_MODIFIED") {
                            return .single(nil)
                        } else {
                            return .fail(error)
                        }
                    }
                )
                |> mapError { error -> UpdatePeerNameColorAndEmojiError in
                    if error.errorDescription.hasPrefix("BOOSTS_REQUIRED") {
                        return .channelBoostRequired
                    }
                    return .generic
                }
                |> mapToSignal { repliesResult, profileResult -> Signal<Void, UpdatePeerNameColorAndEmojiError> in
                    if let repliesResult = repliesResult {
                        account.stateManager.addUpdates(repliesResult)
                    }
                    if let profileResult = profileResult {
                        account.stateManager.addUpdates(profileResult)
                    }
                    
                    return account.postbox.transaction { transaction -> Void in
                        if let repliesResult = repliesResult, let apiChat = apiUpdatesGroups(repliesResult).first {
                            let parsedPeers = AccumulatedPeers(transaction: transaction, chats: [apiChat], users: [])
                            updatePeers(transaction: transaction, accountPeerId: account.peerId, peers: parsedPeers)
                        }
                        if let profileResult = profileResult, let apiChat = apiUpdatesGroups(profileResult).first {
                            let parsedPeers = AccumulatedPeers(transaction: transaction, chats: [apiChat], users: [])
                            updatePeers(transaction: transaction, accountPeerId: account.peerId, peers: parsedPeers)
                        }
                    }
                    |> mapError { _ -> UpdatePeerNameColorAndEmojiError in }
                }
            } else {
                return .fail(.generic)
            }
        } else {
            return .fail(.generic)
        }
    } 
    |> castError(UpdatePeerNameColorAndEmojiError.self)
    |> switchToLatest
}
