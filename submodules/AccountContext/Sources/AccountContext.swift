import Foundation
import UIKit
import AsyncDisplayKit
import Postbox
import TelegramCore
import TelegramPresentationData
import TelegramUIPreferences
import SwiftSignalKit
import AsyncDisplayKit
import Display
import DeviceLocationManager
import TemporaryCachedPeerDataManager
import InAppPurchaseManager
import AnimationCache
import MultiAnimationRenderer
import Photos

public final class TelegramApplicationOpenUrlCompletion {
    public let completion: (Bool) -> Void
    
    public init(completion: @escaping (Bool) -> Void) {
        self.completion = completion
    }
}

public enum AccessType {
    case notDetermined
    case allowed
    case denied
    case restricted
    case unreachable
}

public enum TelegramAppBuildType {
    case `internal`
    case `public`
}

public final class TelegramApplicationBindings {
    public let isMainApp: Bool
    public let appBundleId: String
    public let appBuildType: TelegramAppBuildType
    public let containerPath: String
    public let appSpecificScheme: String
    public let openUrl: (String) -> Void
    public let openUniversalUrl: (String, TelegramApplicationOpenUrlCompletion) -> Void
    public let canOpenUrl: (String) -> Bool
    public let getTopWindow: () -> UIWindow?
    public let displayNotification: (String) -> Void
    public let applicationInForeground: Signal<Bool, NoError>
    public let applicationIsActive: Signal<Bool, NoError>
    public let clearMessageNotifications: ([MessageId]) -> Void
    public let pushIdleTimerExtension: () -> Disposable
    public let openSettings: () -> Void
    public let openAppStorePage: () -> Void
    public let openSubscriptions: () -> Void
    public let registerForNotifications: (@escaping (Bool) -> Void) -> Void
    public let requestSiriAuthorization: (@escaping (Bool) -> Void) -> Void
    public let siriAuthorization: () -> AccessType
    public let getWindowHost: () -> WindowHost?
    public let presentNativeController: (UIViewController) -> Void
    public let dismissNativeController: () -> Void
    public let getAvailableAlternateIcons: () -> [PresentationAppIcon]
    public let getAlternateIconName: () -> String?
    public let requestSetAlternateIconName: (String?, @escaping (Bool) -> Void) -> Void
    public let forceOrientation: (UIInterfaceOrientation) -> Void
    
    public init(isMainApp: Bool, appBundleId: String, appBuildType: TelegramAppBuildType, containerPath: String, appSpecificScheme: String, openUrl: @escaping (String) -> Void, openUniversalUrl: @escaping (String, TelegramApplicationOpenUrlCompletion) -> Void, canOpenUrl: @escaping (String) -> Bool, getTopWindow: @escaping () -> UIWindow?, displayNotification: @escaping (String) -> Void, applicationInForeground: Signal<Bool, NoError>, applicationIsActive: Signal<Bool, NoError>, clearMessageNotifications: @escaping ([MessageId]) -> Void, pushIdleTimerExtension: @escaping () -> Disposable, openSettings: @escaping () -> Void, openAppStorePage: @escaping () -> Void, openSubscriptions: @escaping () -> Void, registerForNotifications: @escaping (@escaping (Bool) -> Void) -> Void, requestSiriAuthorization: @escaping (@escaping (Bool) -> Void) -> Void, siriAuthorization: @escaping () -> AccessType, getWindowHost: @escaping () -> WindowHost?, presentNativeController: @escaping (UIViewController) -> Void, dismissNativeController: @escaping () -> Void, getAvailableAlternateIcons: @escaping () -> [PresentationAppIcon], getAlternateIconName: @escaping () -> String?, requestSetAlternateIconName: @escaping (String?, @escaping (Bool) -> Void) -> Void, forceOrientation: @escaping (UIInterfaceOrientation) -> Void) {
        self.isMainApp = isMainApp
        self.appBundleId = appBundleId
        self.appBuildType = appBuildType
        self.containerPath = containerPath
        self.appSpecificScheme = appSpecificScheme
        self.openUrl = openUrl
        self.openUniversalUrl = openUniversalUrl
        self.canOpenUrl = canOpenUrl
        self.getTopWindow = getTopWindow
        self.displayNotification = displayNotification
        self.applicationInForeground = applicationInForeground
        self.applicationIsActive = applicationIsActive
        self.clearMessageNotifications = clearMessageNotifications
        self.pushIdleTimerExtension = pushIdleTimerExtension
        self.openSettings = openSettings
        self.openAppStorePage = openAppStorePage
        self.openSubscriptions = openSubscriptions
        self.registerForNotifications = registerForNotifications
        self.requestSiriAuthorization = requestSiriAuthorization
        self.siriAuthorization = siriAuthorization
        self.presentNativeController = presentNativeController
        self.dismissNativeController = dismissNativeController
        self.getWindowHost = getWindowHost
        self.getAvailableAlternateIcons = getAvailableAlternateIcons
        self.getAlternateIconName = getAlternateIconName
        self.requestSetAlternateIconName = requestSetAlternateIconName
        self.forceOrientation = forceOrientation
    }
}

public enum TextLinkItemActionType {
    case tap
    case longTap
}

public enum TextLinkItem {
    case url(url: String, concealed: Bool)
    case mention(String)
    case hashtag(String?, String)
}

public final class AccountWithInfo: Equatable {
    public let account: Account
    public let peer: Peer
    
    public init(account: Account, peer: Peer) {
        self.account = account
        self.peer = peer
    }
    
    public static func ==(lhs: AccountWithInfo, rhs: AccountWithInfo) -> Bool {
        if lhs.account !== rhs.account {
            return false
        }
        if !arePeersEqual(lhs.peer, rhs.peer) {
            return false
        }
        return true
    }
}

public enum OpenURLContext {
    case generic
    case chat(peerId: PeerId, message: Message?, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?)
}

public struct ChatAvailableMessageActionOptions: OptionSet {
    public var rawValue: Int32
    
    public init(rawValue: Int32) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = 0
    }
    
    public static let deleteLocally = ChatAvailableMessageActionOptions(rawValue: 1 << 0)
    public static let deleteGlobally = ChatAvailableMessageActionOptions(rawValue: 1 << 1)
    public static let forward = ChatAvailableMessageActionOptions(rawValue: 1 << 2)
    public static let report = ChatAvailableMessageActionOptions(rawValue: 1 << 3)
    public static let viewStickerPack = ChatAvailableMessageActionOptions(rawValue: 1 << 4)
    public static let rateCall = ChatAvailableMessageActionOptions(rawValue: 1 << 5)
    public static let cancelSending = ChatAvailableMessageActionOptions(rawValue: 1 << 6)
    public static let unsendPersonal = ChatAvailableMessageActionOptions(rawValue: 1 << 7)
    public static let sendScheduledNow = ChatAvailableMessageActionOptions(rawValue: 1 << 8)
    public static let editScheduledTime = ChatAvailableMessageActionOptions(rawValue: 1 << 9)
    public static let externalShare = ChatAvailableMessageActionOptions(rawValue: 1 << 10)
}

public struct ChatAvailableMessageActions {
    public var options: ChatAvailableMessageActionOptions
    public var banAuthor: Peer?
    public var disableDelete: Bool
    public var isCopyProtected: Bool
    
    public init(options: ChatAvailableMessageActionOptions, banAuthor: Peer?, disableDelete: Bool, isCopyProtected: Bool) {
        self.options = options
        self.banAuthor = banAuthor
        self.disableDelete = disableDelete
        self.isCopyProtected = isCopyProtected
    }
}

public enum WallpaperUrlParameter {
    case slug(String, WallpaperPresentationOptions, [UInt32], Int32?, Int32?)
    case color(UIColor)
    case gradient([UInt32], Int32?)
}

public enum ResolvedUrlSettingsSection {
    case theme
    case devices
    case autoremoveMessages
    case twoStepAuth
    case enableLog
}

public struct ResolvedBotChoosePeerTypes: OptionSet {
    public var rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = 0
    }
    
    public static let users = ResolvedBotChoosePeerTypes(rawValue: 1)
    public static let bots = ResolvedBotChoosePeerTypes(rawValue: 2)
    public static let groups = ResolvedBotChoosePeerTypes(rawValue: 4)
    public static let channels = ResolvedBotChoosePeerTypes(rawValue: 16)
}

public struct ResolvedBotAdminRights: OptionSet {
    public var rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init() {
        self.rawValue = 0
    }
    
    public static let changeInfo = ResolvedBotAdminRights(rawValue: 1)
    public static let postMessages = ResolvedBotAdminRights(rawValue: 2)
    public static let editMessages = ResolvedBotAdminRights(rawValue: 4)
    public static let deleteMessages = ResolvedBotAdminRights(rawValue: 16)
    public static let restrictMembers = ResolvedBotAdminRights(rawValue: 32)
    public static let inviteUsers = ResolvedBotAdminRights(rawValue: 64)
    public static let pinMessages = ResolvedBotAdminRights(rawValue: 128)
    public static let promoteMembers = ResolvedBotAdminRights(rawValue: 256)
    public static let manageVideoChats = ResolvedBotAdminRights(rawValue: 512)
    public static let canBeAnonymous = ResolvedBotAdminRights(rawValue: 1024)
    public static let manageChat = ResolvedBotAdminRights(rawValue: 2048)
    
    public var chatAdminRights: TelegramChatAdminRightsFlags? {
        var flags = TelegramChatAdminRightsFlags()
        
        if self.contains(ResolvedBotAdminRights.changeInfo) {
            flags.insert(.canChangeInfo)
        }
        if self.contains(ResolvedBotAdminRights.postMessages) {
            flags.insert(.canPostMessages)
        }
        if self.contains(ResolvedBotAdminRights.editMessages) {
            flags.insert(.canEditMessages)
        }
        if self.contains(ResolvedBotAdminRights.deleteMessages) {
            flags.insert(.canDeleteMessages)
        }
        if self.contains(ResolvedBotAdminRights.restrictMembers) {
            flags.insert(.canBanUsers)
        }
        if self.contains(ResolvedBotAdminRights.inviteUsers) {
            flags.insert(.canInviteUsers)
        }
        if self.contains(ResolvedBotAdminRights.pinMessages) {
            flags.insert(.canPinMessages)
        }
        if self.contains(ResolvedBotAdminRights.promoteMembers) {
            flags.insert(.canAddAdmins)
        }
        if self.contains(ResolvedBotAdminRights.manageVideoChats) {
            flags.insert(.canManageCalls)
        }
        if self.contains(ResolvedBotAdminRights.canBeAnonymous) {
            flags.insert(.canBeAnonymous)
        }
        
        if flags.isEmpty && !self.contains(ResolvedBotAdminRights.manageChat) {
            return nil
        }
        
        return flags
    }
}

public enum StickerPackUrlType {
    case stickers
    case emoji
}

public enum ResolvedUrl {
    case externalUrl(String)
    case urlAuth(String)
    case peer(Peer?, ChatControllerInteractionNavigateToPeer)
    case inaccessiblePeer
    case botStart(peer: Peer, payload: String)
    case groupBotStart(peerId: PeerId, payload: String, adminRights: ResolvedBotAdminRights?)
    case gameStart(peerId: PeerId, game: String)
    case channelMessage(peer: Peer, messageId: MessageId, timecode: Double?)
    case replyThreadMessage(replyThreadMessage: ChatReplyThreadMessage, messageId: MessageId)
    case replyThread(messageId: MessageId)
    case stickerPack(name: String, type: StickerPackUrlType)
    case instantView(TelegramMediaWebpage, String?)
    case proxy(host: String, port: Int32, username: String?, password: String?, secret: Data?)
    case join(String)
    case localization(String)
    case confirmationCode(Int)
    case cancelAccountReset(phone: String, hash: String)
    case share(url: String?, text: String?, to: String?)
    case wallpaper(WallpaperUrlParameter)
    case theme(String)
    case settings(ResolvedUrlSettingsSection)
    case joinVoiceChat(PeerId, String?)
    case importStickers
    case startAttach(peerId: PeerId, payload: String?, choose: ResolvedBotChoosePeerTypes?)
    case invoice(slug: String, invoice: TelegramMediaInvoice?)
    case premiumOffer(reference: String?)
    case chatFolder(slug: String)
    case story(peerId: PeerId, id: Int32)
    case boost(peerId: PeerId, status: ChannelBoostStatus?, myBoostStatus: MyBoostStatus?)
    case premiumGiftCode(slug: String)
    case premiumMultiGift(reference: String?)
}

public enum ResolveUrlResult {
    case progress
    case result(ResolvedUrl)
}

public enum NavigateToChatKeepStack {
    case `default`
    case always
    case never
}

public final class ChatPeekTimeout {
    public let deadline: Int32
    public let linkData: String
    
    public init(deadline: Int32, linkData: String) {
        self.deadline = deadline
        self.linkData = linkData
    }
}

public final class ChatPeerNearbyData: Equatable {
    public static func == (lhs: ChatPeerNearbyData, rhs: ChatPeerNearbyData) -> Bool {
        return lhs.distance == rhs.distance
    }
    
    public let distance: Int32
    
    public init(distance: Int32) {
        self.distance = distance
    }
}

public final class ChatGreetingData: Equatable {
    public static func == (lhs: ChatGreetingData, rhs: ChatGreetingData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public let uuid: UUID
    public let sticker: Signal<TelegramMediaFile?, NoError>
    
    public init(uuid: UUID, sticker: Signal<TelegramMediaFile?, NoError>) {
        self.uuid = uuid
        self.sticker = sticker
    }
}

public enum ChatSearchDomain: Equatable {
    case everything
    case members
    case member(Peer)
    case tag(MessageReaction.Reaction, TelegramMediaFile)
    
    public static func ==(lhs: ChatSearchDomain, rhs: ChatSearchDomain) -> Bool {
        switch lhs {
        case .everything:
            if case .everything = rhs {
                return true
            } else {
                return false
            }
        case .members:
            if case .members = rhs {
                return true
            } else {
                return false
            }
        case let .member(lhsPeer):
            if case let .member(rhsPeer) = rhs, lhsPeer.isEqual(rhsPeer) {
                return true
            } else {
                return false
            }
        case let .tag(tag, file):
            if case .tag(tag, file) = rhs {
                return true
            } else {
                return false
            }
        }
    }
}

public enum ChatLocation: Equatable {
    case peer(id: PeerId)
    case replyThread(message: ChatReplyThreadMessage)
    case feed(id: Int32)
}

public extension ChatLocation {
    var normalized: ChatLocation {
        switch self {
        case .peer, .feed:
            return self
        case let .replyThread(message):
            return .replyThread(message: message.normalized)
        }
    }
}

public enum ChatControllerActivateInput {
    case text
    case entityInput
}

public struct ChatNavigationStackItem: Hashable {
    public var peerId: EnginePeer.Id
    public var threadId: Int64?
    
    public init(peerId: EnginePeer.Id, threadId: Int64?) {
        self.peerId = peerId
        self.threadId = threadId
    }
}

public final class NavigateToChatControllerParams {
    public enum Location {
        case peer(EnginePeer)
        case replyThread(ChatReplyThreadMessage)
        
        public var peerId: EnginePeer.Id {
            switch self {
            case let .peer(peer):
                return peer.id
            case let .replyThread(message):
                return message.peerId
            }
        }
        
        public var threadId: Int64? {
            switch self {
            case .peer:
                return nil
            case let .replyThread(message):
                return message.threadId
            }
        }
        
        public var asChatLocation: ChatLocation {
            switch self {
            case let .peer(peer):
                return .peer(id: peer.id)
            case let .replyThread(message):
                return .replyThread(message: message)
            }
        }
    }
    
    public let navigationController: NavigationController
    public let chatController: ChatController?
    public let context: AccountContext
    public let chatLocation: Location
    public let chatLocationContextHolder: Atomic<ChatLocationContextHolder?>
    public let subject: ChatControllerSubject?
    public let botStart: ChatControllerInitialBotStart?
    public let attachBotStart: ChatControllerInitialAttachBotStart?
    public let botAppStart: ChatControllerInitialBotAppStart?
    public let updateTextInputState: ChatTextInputState?
    public let activateInput: ChatControllerActivateInput?
    public let keepStack: NavigateToChatKeepStack
    public let useExisting: Bool
    public let useBackAnimation: Bool
    public let purposefulAction: (() -> Void)?
    public let scrollToEndIfExists: Bool
    public let activateMessageSearch: (ChatSearchDomain, String)?
    public let peekData: ChatPeekTimeout?
    public let peerNearbyData: ChatPeerNearbyData?
    public let reportReason: ReportReason?
    public let animated: Bool
    public let options: NavigationAnimationOptions
    public let parentGroupId: PeerGroupId?
    public let chatListFilter: Int32?
    public let chatNavigationStack: [ChatNavigationStackItem]
    public let changeColors: Bool
    public let setupController: (ChatController) -> Void
    public let completion: (ChatController) -> Void
    public let chatListCompletion: ((ChatListController) -> Void)?
    public let pushController: ((ChatController, Bool, @escaping () -> Void) -> Void)?
    
    public init(navigationController: NavigationController, chatController: ChatController? = nil, context: AccountContext, chatLocation: Location, chatLocationContextHolder: Atomic<ChatLocationContextHolder?> = Atomic<ChatLocationContextHolder?>(value: nil), subject: ChatControllerSubject? = nil, botStart: ChatControllerInitialBotStart? = nil, attachBotStart: ChatControllerInitialAttachBotStart? = nil, botAppStart: ChatControllerInitialBotAppStart? = nil, updateTextInputState: ChatTextInputState? = nil, activateInput: ChatControllerActivateInput? = nil, keepStack: NavigateToChatKeepStack = .default, useExisting: Bool = true, useBackAnimation: Bool = false, purposefulAction: (() -> Void)? = nil, scrollToEndIfExists: Bool = false, activateMessageSearch: (ChatSearchDomain, String)? = nil, peekData: ChatPeekTimeout? = nil, peerNearbyData: ChatPeerNearbyData? = nil, reportReason: ReportReason? = nil, animated: Bool = true, options: NavigationAnimationOptions = [], parentGroupId: PeerGroupId? = nil, chatListFilter: Int32? = nil, chatNavigationStack: [ChatNavigationStackItem] = [], changeColors: Bool = false, setupController: @escaping (ChatController) -> Void = { _ in }, pushController: ((ChatController, Bool, @escaping () -> Void) -> Void)? = nil, completion: @escaping (ChatController) -> Void = { _ in }, chatListCompletion: @escaping (ChatListController) -> Void = { _ in }) {
        self.navigationController = navigationController
        self.chatController = chatController
        self.chatLocationContextHolder = chatLocationContextHolder
        self.context = context
        self.chatLocation = chatLocation
        self.subject = subject
        self.botStart = botStart
        self.attachBotStart = attachBotStart
        self.botAppStart = botAppStart
        self.updateTextInputState = updateTextInputState
        self.activateInput = activateInput
        self.keepStack = keepStack
        self.useExisting = useExisting
        self.useBackAnimation = useBackAnimation
        self.purposefulAction = purposefulAction
        self.scrollToEndIfExists = scrollToEndIfExists
        self.activateMessageSearch = activateMessageSearch
        self.peekData = peekData
        self.peerNearbyData = peerNearbyData
        self.reportReason = reportReason
        self.animated = animated
        self.options = options
        self.parentGroupId = parentGroupId
        self.chatListFilter = chatListFilter
        self.chatNavigationStack = chatNavigationStack
        self.changeColors = changeColors
        self.setupController = setupController
        self.pushController = pushController
        self.completion = completion
        self.chatListCompletion = chatListCompletion
    }
}

public enum DeviceContactInfoSubject {
    case vcard(Peer?, DeviceContactStableId?, DeviceContactExtendedData)
    case filter(peer: Peer?, contactId: DeviceContactStableId?, contactData: DeviceContactExtendedData, completion: (Peer?, DeviceContactExtendedData) -> Void)
    case create(peer: Peer?, contactData: DeviceContactExtendedData, isSharing: Bool, shareViaException: Bool, completion: (Peer?, DeviceContactStableId, DeviceContactExtendedData) -> Void)
    
    public var peer: Peer? {
        switch self {
        case let .vcard(peer, _, _):
            return peer
        case let .filter(peer, _, _, _):
            return peer
        case .create:
            return nil
        }
    }
    
    public var contactData: DeviceContactExtendedData {
        switch self {
        case let .vcard(_, _, data):
            return data
        case let .filter(_, _, data, _):
            return data
        case let .create(_, data, _, _, _):
            return data
        }
    }
}

public enum PeerInfoControllerMode {
    case generic
    case calls(messages: [Message])
    case nearbyPeer(distance: Int32)
    case group(PeerId)
    case reaction(MessageId)
    case forumTopic(thread: ChatReplyThreadMessage)
    case recommendedChannels
}

public enum ContactListActionItemInlineIconPosition {
    case left
    case right
}

public enum ContactListActionItemIcon : Equatable {
    case none
    case generic(UIImage)
    case inline(UIImage, ContactListActionItemInlineIconPosition)
    
    public var image: UIImage? {
        switch self {
        case .none:
            return nil
        case let .generic(image):
            return image
        case let .inline(image, _):
            return image
        }
    }
    
    public static func ==(lhs: ContactListActionItemIcon, rhs: ContactListActionItemIcon) -> Bool {
        switch lhs {
        case .none:
            if case .none = rhs {
                return true
            } else {
                return false
            }
        case let .generic(image):
            if case .generic(image) = rhs {
                return true
            } else {
                return false
            }
        case let .inline(image, position):
            if case .inline(image, position) = rhs {
                return true
            } else {
                return false
            }
        }
    }
}

public struct ContactListAdditionalOption: Equatable {
    public let title: String
    public let icon: ContactListActionItemIcon
    public let action: () -> Void
    public let clearHighlightAutomatically: Bool
    
    public init(title: String, icon: ContactListActionItemIcon, action: @escaping () -> Void, clearHighlightAutomatically: Bool = false) {
        self.title = title
        self.icon = icon
        self.action = action
        self.clearHighlightAutomatically = clearHighlightAutomatically
    }
    
    public static func ==(lhs: ContactListAdditionalOption, rhs: ContactListAdditionalOption) -> Bool {
        return lhs.title == rhs.title && lhs.icon == rhs.icon
    }
}

public enum ContactListPeerId: Hashable {
    case peer(PeerId)
    case deviceContact(DeviceContactStableId)
}

public enum ContactListAction: Equatable {
    case generic
    case voiceCall
    case videoCall
}

public enum ContactListPeer: Equatable {
    case peer(peer: Peer, isGlobal: Bool, participantCount: Int32?)
    case deviceContact(DeviceContactStableId, DeviceContactBasicData)
    
    public var id: ContactListPeerId {
        switch self {
        case let .peer(peer, _, _):
            return .peer(peer.id)
        case let .deviceContact(id, _):
            return .deviceContact(id)
        }
    }
    
    public var indexName: PeerIndexNameRepresentation {
        switch self {
        case let .peer(peer, _, _):
            return peer.indexName
        case let .deviceContact(_, contact):
            return .personName(first: contact.firstName, last: contact.lastName, addressNames: [], phoneNumber: "")
        }
    }
    
    public static func ==(lhs: ContactListPeer, rhs: ContactListPeer) -> Bool {
        switch lhs {
        case let .peer(lhsPeer, lhsIsGlobal, lhsParticipantCount):
            if case let .peer(rhsPeer, rhsIsGlobal, rhsParticipantCount) = rhs, lhsPeer.isEqual(rhsPeer), lhsIsGlobal == rhsIsGlobal, lhsParticipantCount == rhsParticipantCount {
                return true
            } else {
                return false
            }
        case let .deviceContact(id, contact):
            if case .deviceContact(id, contact) = rhs {
                return true
            } else {
                return false
            }
        }
    }
}

public final class ContactSelectionControllerParams {
    public let context: AccountContext
    public let updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?
    public let autoDismiss: Bool
    public let title: (PresentationStrings) -> String
    public let options: [ContactListAdditionalOption]
    public let displayDeviceContacts: Bool
    public let displayCallIcons: Bool
    public let multipleSelection: Bool
    public let requirePhoneNumbers: Bool
    public let confirmation: (ContactListPeer) -> Signal<Bool, NoError>
    
    public init(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)? = nil, autoDismiss: Bool = true, title: @escaping (PresentationStrings) -> String, options: [ContactListAdditionalOption] = [], displayDeviceContacts: Bool = false, displayCallIcons: Bool = false, multipleSelection: Bool = false, requirePhoneNumbers: Bool = false, confirmation: @escaping (ContactListPeer) -> Signal<Bool, NoError> = { _ in .single(true) }) {
        self.context = context
        self.updatedPresentationData = updatedPresentationData
        self.autoDismiss = autoDismiss
        self.title = title
        self.options = options
        self.displayDeviceContacts = displayDeviceContacts
        self.displayCallIcons = displayCallIcons
        self.multipleSelection = multipleSelection
        self.requirePhoneNumbers = requirePhoneNumbers
        self.confirmation = confirmation
    }
}

public enum ChatListSearchFilter: Equatable {
    case chats
    case topics
    case media
    case downloads
    case links
    case files
    case music
    case voice
    case peer(PeerId, Bool, String, String)
    case date(Int32?, Int32, String)
    
    public var id: Int64 {
        switch self {
            case .chats:
                return 0
            case .topics:
                return 1
            case .media:
                return 2
            case .downloads:
                return 4
            case .links:
                return 5
            case .files:
                return 6
            case .music:
                return 7
            case .voice:
                return 8
            case let .peer(peerId, _, _, _):
                return peerId.id._internalGetInt64Value()
            case let .date(_, date, _):
                return Int64(date)
        }
    }
}

public enum InstalledStickerPacksControllerMode {
    case general
    case modal
    case masks
    case emoji
}

public let defaultContactLabel: String = "_$!<Mobile>!$_"

public enum CreateGroupMode {
    case generic
    case supergroup
    case locatedGroup(latitude: Double, longitude: Double, address: String?)
    case requestPeer(ReplyMarkupButtonRequestPeerType.Group)
}

public protocol AppLockContext: AnyObject {
    var invalidAttempts: Signal<AccessChallengeAttempts?, NoError> { get }
    var autolockDeadline: Signal<Int32?, NoError> { get }
    
    func lock()
    func unlock()
    func failedUnlockAttempt()
}

public protocol RecentSessionsController: AnyObject {
}

public protocol AttachmentFileController: AnyObject {
}

public struct StoryCameraTransitionIn {
    public weak var sourceView: UIView?
    public let sourceRect: CGRect
    public let sourceCornerRadius: CGFloat
    
    public init(
        sourceView: UIView,
        sourceRect: CGRect,
        sourceCornerRadius: CGFloat
    ) {
        self.sourceView = sourceView
        self.sourceRect = sourceRect
        self.sourceCornerRadius = sourceCornerRadius
    }
}

public struct StoryCameraTransitionOut {
    public weak var destinationView: UIView?
    public let destinationRect: CGRect
    public let destinationCornerRadius: CGFloat
    
    public init(
        destinationView: UIView,
        destinationRect: CGRect,
        destinationCornerRadius: CGFloat
    ) {
        self.destinationView = destinationView
        self.destinationRect = destinationRect
        self.destinationCornerRadius = destinationCornerRadius
    }
}

public struct StoryCameraTransitionInCoordinator {
    public let animateIn: () -> Void
    public let updateTransitionProgress: (CGFloat) -> Void
    public let completeWithTransitionProgressAndVelocity: (CGFloat, CGFloat) -> Void
    
    public init(
        animateIn: @escaping () -> Void,
        updateTransitionProgress: @escaping (CGFloat) -> Void,
        completeWithTransitionProgressAndVelocity: @escaping (CGFloat, CGFloat) -> Void
    ) {
        self.animateIn = animateIn
        self.updateTransitionProgress = updateTransitionProgress
        self.completeWithTransitionProgressAndVelocity = completeWithTransitionProgressAndVelocity
    }
}

public class MediaEditorTransitionOutExternalState {
    public var storyTarget: Stories.PendingTarget?
    public var isPeerArchived: Bool
    public var transitionOut: ((Stories.PendingTarget?, Bool) -> StoryCameraTransitionOut?)?
    
    public init(storyTarget: Stories.PendingTarget?, isPeerArchived: Bool, transitionOut: ((Stories.PendingTarget?, Bool) -> StoryCameraTransitionOut?)?) {
        self.storyTarget = storyTarget
        self.isPeerArchived = isPeerArchived
        self.transitionOut = transitionOut
    }
}

public protocol MediaEditorScreenResult {
    
}

public protocol TelegramRootControllerInterface: NavigationController {
    @discardableResult
    func openStoryCamera(customTarget: EnginePeer.Id?, transitionIn: StoryCameraTransitionIn?, transitionedIn: @escaping () -> Void, transitionOut: @escaping (Stories.PendingTarget?, Bool) -> StoryCameraTransitionOut?) -> StoryCameraTransitionInCoordinator?
    func proceedWithStoryUpload(target: Stories.PendingTarget, result: MediaEditorScreenResult, existingMedia: EngineMedia?, forwardInfo: Stories.PendingForwardInfo?, externalState: MediaEditorTransitionOutExternalState, commit: @escaping (@escaping () -> Void) -> Void)
    
    func getContactsController() -> ViewController?
    func getChatsController() -> ViewController?
    func openSettings()
}

public protocol SharedAccountContext: AnyObject {
    var sharedContainerPath: String { get }
    var basePath: String { get }
    var mainWindow: Window1? { get }
    var accountManager: AccountManager<TelegramAccountManagerTypes> { get }
    var appLockContext: AppLockContext { get }
    
    var currentPresentationData: Atomic<PresentationData> { get }
    var presentationData: Signal<PresentationData, NoError> { get }
    
    var currentAutomaticMediaDownloadSettings: MediaAutoDownloadSettings { get }
    var automaticMediaDownloadSettings: Signal<MediaAutoDownloadSettings, NoError> { get }
    var currentAutodownloadSettings: Atomic<AutodownloadSettings> { get }
    var immediateExperimentalUISettings: ExperimentalUISettings { get }
    var currentInAppNotificationSettings: Atomic<InAppNotificationSettings> { get }
    var currentMediaInputSettings: Atomic<MediaInputSettings> { get }
    var currentStickerSettings: Atomic<StickerSettings> { get }
    var currentMediaDisplaySettings: Atomic<MediaDisplaySettings> { get }
    
    var energyUsageSettings: EnergyUsageSettings { get }
    
    var applicationBindings: TelegramApplicationBindings { get }
    
    var authorizationPushConfiguration: Signal<AuthorizationCodePushNotificationConfiguration?, NoError> { get }
    var firebaseSecretStream: Signal<[String: String], NoError> { get }
    
    var mediaManager: MediaManager { get }
    var locationManager: DeviceLocationManager? { get }
    var callManager: PresentationCallManager? { get }
    var contactDataManager: DeviceContactDataManager? { get }
    
    var activeAccountContexts: Signal<(primary: AccountContext?, accounts: [(AccountRecordId, AccountContext, Int32)], currentAuth: UnauthorizedAccount?), NoError> { get }
    var activeAccountsWithInfo: Signal<(primary: AccountRecordId?, accounts: [AccountWithInfo]), NoError> { get }
    
    var presentGlobalController: (ViewController, Any?) -> Void { get }
    var presentCrossfadeController: () -> Void { get }
    
    func makeTempAccountContext(account: Account) -> AccountContext
    
    func updateNotificationTokensRegistration()
    func setAccountUserInterfaceInUse(_ id: AccountRecordId) -> Disposable
    func handleTextLinkAction(context: AccountContext, peerId: PeerId?, navigateDisposable: MetaDisposable, controller: ViewController, action: TextLinkItemActionType, itemLink: TextLinkItem)
    func openSearch(filter: ChatListSearchFilter, query: String?)
    func navigateToChat(accountId: AccountRecordId, peerId: PeerId, messageId: MessageId?)
    func openChatMessage(_ params: OpenChatMessageParams) -> Bool
    func messageFromPreloadedChatHistoryViewForLocation(id: MessageId, location: ChatHistoryLocationInput, context: AccountContext, chatLocation: ChatLocation, subject: ChatControllerSubject?, chatLocationContextHolder: Atomic<ChatLocationContextHolder?>, tagMask: MessageTags?) -> Signal<(MessageIndex?, Bool), NoError>
    func makeOverlayAudioPlayerController(context: AccountContext, chatLocation: ChatLocation, type: MediaManagerPlayerType, initialMessageId: MessageId, initialOrder: MusicPlaybackSettingsOrder, playlistLocation: SharedMediaPlaylistLocation?, parentNavigationController: NavigationController?) -> ViewController & OverlayAudioPlayerController
    func makePeerInfoController(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, peer: Peer, mode: PeerInfoControllerMode, avatarInitiallyExpanded: Bool, fromChat: Bool, requestsContext: PeerInvitationImportersContext?) -> ViewController?
    func makeChannelAdminController(context: AccountContext, peerId: PeerId, adminId: PeerId, initialParticipant: ChannelParticipant) -> ViewController?
    func makeDeviceContactInfoController(context: AccountContext, subject: DeviceContactInfoSubject, completed: (() -> Void)?, cancelled: (() -> Void)?) -> ViewController
    func makePeersNearbyController(context: AccountContext) -> ViewController
    func makeComposeController(context: AccountContext) -> ViewController
    func makeChatListController(context: AccountContext, location: ChatListControllerLocation, controlsHistoryPreload: Bool, hideNetworkActivityStatus: Bool, previewing: Bool, enableDebugActions: Bool) -> ChatListController
    func makeChatController(context: AccountContext, chatLocation: ChatLocation, subject: ChatControllerSubject?, botStart: ChatControllerInitialBotStart?, mode: ChatControllerPresentationMode) -> ChatController
    func makeChatHistoryListNode(
        context: AccountContext,
        updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>),
        chatLocation: ChatLocation,
        chatLocationContextHolder: Atomic<ChatLocationContextHolder?>,
        tagMask: MessageTags?,
        source: ChatHistoryListSource,
        subject: ChatControllerSubject?,
        controllerInteraction: ChatControllerInteractionProtocol,
        selectedMessages: Signal<Set<MessageId>?, NoError>,
        mode: ChatHistoryListMode
    ) -> ChatHistoryListNode
    func makeChatMessagePreviewItem(context: AccountContext, messages: [Message], theme: PresentationTheme, strings: PresentationStrings, wallpaper: TelegramWallpaper, fontSize: PresentationFontSize, chatBubbleCorners: PresentationChatBubbleCorners, dateTimeFormat: PresentationDateTimeFormat, nameOrder: PresentationPersonNameOrder, forcedResourceStatus: FileMediaResourceStatus?, tapMessage: ((Message) -> Void)?, clickThroughMessage: (() -> Void)?, backgroundNode: ASDisplayNode?, availableReactions: AvailableReactions?, accountPeer: Peer?, isCentered: Bool, isPreview: Bool) -> ListViewItem
    func makeChatMessageDateHeaderItem(context: AccountContext, timestamp: Int32, theme: PresentationTheme, strings: PresentationStrings, wallpaper: TelegramWallpaper, fontSize: PresentationFontSize, chatBubbleCorners: PresentationChatBubbleCorners, dateTimeFormat: PresentationDateTimeFormat, nameOrder: PresentationPersonNameOrder) -> ListViewItemHeader
    func makeChatMessageAvatarHeaderItem(context: AccountContext, timestamp: Int32, peer: Peer, message: Message, theme: PresentationTheme, strings: PresentationStrings, wallpaper: TelegramWallpaper, fontSize: PresentationFontSize, chatBubbleCorners: PresentationChatBubbleCorners, dateTimeFormat: PresentationDateTimeFormat, nameOrder: PresentationPersonNameOrder) -> ListViewItemHeader
    func makePeerSharedMediaController(context: AccountContext, peerId: PeerId) -> ViewController?
    func makeContactSelectionController(_ params: ContactSelectionControllerParams) -> ContactSelectionController
    func makeContactMultiselectionController(_ params: ContactMultiselectionControllerParams) -> ContactMultiselectionController
    func makePeerSelectionController(_ params: PeerSelectionControllerParams) -> PeerSelectionController
    func makeProxySettingsController(context: AccountContext) -> ViewController
    func makeLocalizationListController(context: AccountContext) -> ViewController
    func makeCreateGroupController(context: AccountContext, peerIds: [PeerId], initialTitle: String?, mode: CreateGroupMode, completion: ((PeerId, @escaping () -> Void) -> Void)?) -> ViewController
    func makeChatRecentActionsController(context: AccountContext, peer: Peer, adminPeerId: PeerId?) -> ViewController
    func makePrivacyAndSecurityController(context: AccountContext) -> ViewController
    func makeSetupTwoFactorAuthController(context: AccountContext) -> ViewController
    func makeStorageManagementController(context: AccountContext) -> ViewController
    func makeAttachmentFileController(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, bannedSendMedia: (Int32, Bool)?, presentGallery: @escaping () -> Void, presentFiles: @escaping () -> Void, send: @escaping (AnyMediaReference) -> Void) -> AttachmentFileController
    func makeGalleryCaptionPanelView(context: AccountContext, chatLocation: ChatLocation, isScheduledMessages: Bool, customEmojiAvailable: Bool, present: @escaping (ViewController) -> Void, presentInGlobalOverlay: @escaping (ViewController) -> Void) -> NSObject?
    func makeHashtagSearchController(context: AccountContext, peer: EnginePeer?, query: String, all: Bool) -> ViewController
    func makeMyStoriesController(context: AccountContext, isArchive: Bool) -> ViewController
    func makeArchiveSettingsController(context: AccountContext) -> ViewController
    func navigateToChatController(_ params: NavigateToChatControllerParams)
    func navigateToForumChannel(context: AccountContext, peerId: EnginePeer.Id, navigationController: NavigationController)
    func navigateToForumThread(context: AccountContext, peerId: EnginePeer.Id, threadId: Int64, messageId: EngineMessage.Id?,  navigationController: NavigationController, activateInput: ChatControllerActivateInput?, keepStack: NavigateToChatKeepStack) -> Signal<Never, NoError>
    func chatControllerForForumThread(context: AccountContext, peerId: EnginePeer.Id, threadId: Int64) -> Signal<ChatController, NoError>
    func openStorageUsage(context: AccountContext)
    func openLocationScreen(context: AccountContext, messageId: MessageId, navigationController: NavigationController)
    func openExternalUrl(context: AccountContext, urlContext: OpenURLContext, url: String, forceExternal: Bool, presentationData: PresentationData, navigationController: NavigationController?, dismissInput: @escaping () -> Void)
    func chatAvailableMessageActions(engine: TelegramEngine, accountPeerId: EnginePeer.Id, messageIds: Set<EngineMessage.Id>) -> Signal<ChatAvailableMessageActions, NoError>
    func chatAvailableMessageActions(engine: TelegramEngine, accountPeerId: EnginePeer.Id, messageIds: Set<EngineMessage.Id>, messages: [EngineMessage.Id: EngineMessage], peers: [EnginePeer.Id: EnginePeer]) -> Signal<ChatAvailableMessageActions, NoError>
    func resolveUrl(context: AccountContext, peerId: PeerId?, url: String, skipUrlAuth: Bool) -> Signal<ResolvedUrl, NoError>
    func resolveUrlWithProgress(context: AccountContext, peerId: PeerId?, url: String, skipUrlAuth: Bool) -> Signal<ResolveUrlResult, NoError>
    func openResolvedUrl(_ resolvedUrl: ResolvedUrl, context: AccountContext, urlContext: OpenURLContext, navigationController: NavigationController?, forceExternal: Bool, openPeer: @escaping (EnginePeer, ChatControllerInteractionNavigateToPeer) -> Void, sendFile: ((FileMediaReference) -> Void)?, sendSticker: ((FileMediaReference, UIView, CGRect) -> Bool)?, requestMessageActionUrlAuth: ((MessageActionUrlSubject) -> Void)?, joinVoiceChat: ((PeerId, String?, CachedChannelData.ActiveCall) -> Void)?, present: @escaping (ViewController, Any?) -> Void, dismissInput: @escaping () -> Void, contentContext: Any?, progress: Promise<Bool>?, completion: (() -> Void)?)
    func openAddContact(context: AccountContext, firstName: String, lastName: String, phoneNumber: String, label: String, present: @escaping (ViewController, Any?) -> Void, pushController: @escaping (ViewController) -> Void, completed: @escaping () -> Void)
    func openAddPersonContact(context: AccountContext, peerId: PeerId, pushController: @escaping (ViewController) -> Void, present: @escaping (ViewController, Any?) -> Void)
    func presentContactsWarningSuppression(context: AccountContext, present: (ViewController, Any?) -> Void)
    func openImagePicker(context: AccountContext, completion: @escaping (UIImage) -> Void, present: @escaping (ViewController) -> Void)
    func openAddPeerMembers(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, parentController: ViewController, groupPeer: Peer, selectAddMemberDisposable: MetaDisposable, addMemberDisposable: MetaDisposable)
    func openChatInstantPage(context: AccountContext, message: Message, sourcePeerType: MediaAutoDownloadPeerType?, navigationController: NavigationController)
    func openChatWallpaper(context: AccountContext, message: Message, present: @escaping (ViewController, Any?) -> Void)
    
    func makeRecentSessionsController(context: AccountContext, activeSessionsContext: ActiveSessionsContext) -> ViewController & RecentSessionsController
    
    func makeChatQrCodeScreen(context: AccountContext, peer: Peer, threadId: Int64?, temporary: Bool) -> ViewController
    
    func makePremiumIntroController(context: AccountContext, source: PremiumIntroSource, forceDark: Bool, dismissed: (() -> Void)?) -> ViewController
    func makePremiumDemoController(context: AccountContext, subject: PremiumDemoSubject, action: @escaping () -> Void) -> ViewController
    func makePremiumLimitController(context: AccountContext, subject: PremiumLimitSubject, count: Int32, forceDark: Bool, cancel: @escaping () -> Void, action: @escaping () -> Bool) -> ViewController
    func makePremiumGiftController(context: AccountContext, source: PremiumGiftSource) -> ViewController
    
    func makeStickerPackScreen(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, mainStickerPack: StickerPackReference, stickerPacks: [StickerPackReference], loadedStickerPacks: [LoadedStickerPack], parentNavigationController: NavigationController?, sendSticker: ((FileMediaReference, UIView, CGRect) -> Bool)?) -> ViewController
    
    func makeMediaPickerScreen(context: AccountContext, hasSearch: Bool, completion: @escaping (Any) -> Void) -> ViewController
    
    func makeStoryMediaPickerScreen(context: AccountContext, getSourceRect: @escaping () -> CGRect, completion: @escaping (Any, UIView, CGRect, UIImage?, @escaping (Bool?) -> (UIView, CGRect)?, @escaping () -> Void) -> Void, dismissed: @escaping () -> Void, groupsPresented: @escaping () -> Void) -> ViewController
    
    func makeProxySettingsController(sharedContext: SharedAccountContext, account: UnauthorizedAccount) -> ViewController
    
    func makeInstalledStickerPacksController(context: AccountContext, mode: InstalledStickerPacksControllerMode, forceTheme: PresentationTheme?) -> ViewController
    
    func makeChannelStatsController(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, peerId: EnginePeer.Id, boosts: Bool, boostStatus: ChannelBoostStatus?) -> ViewController
    func makeMessagesStatsController(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, messageId: EngineMessage.Id) -> ViewController
    func makeStoryStatsController(context: AccountContext, updatedPresentationData: (initial: PresentationData, signal: Signal<PresentationData, NoError>)?, peerId: EnginePeer.Id, storyId: Int32, storyItem: EngineStoryItem, fromStory: Bool) -> ViewController
    
    func makeDebugSettingsController(context: AccountContext?) -> ViewController?
    
    func navigateToCurrentCall()
    var hasOngoingCall: ValuePromise<Bool> { get }
    var immediateHasOngoingCall: Bool { get }
    
    var enablePreloads: Promise<Bool> { get }
    var hasPreloadBlockingContent: Promise<Bool> { get }
    
    var hasGroupCallOnScreen: Signal<Bool, NoError> { get }
    var currentGroupCallController: ViewController? { get }
    
    func switchToAccount(id: AccountRecordId, fromSettingsController settingsController: ViewController?, withChatListController chatListController: ViewController?)
    func beginNewAuth(testingEnvironment: Bool)
}

public enum PremiumIntroSource {
    case settings
    case stickers
    case reactions
    case ads
    case upload
    case groupsAndChannels
    case pinnedChats
    case publicLinks
    case savedGifs
    case savedStickers
    case folders
    case chatsPerFolder
    case accounts
    case appIcons
    case about
    case deeplink(String?)
    case profile(PeerId)
    case emojiStatus(PeerId, Int64, TelegramMediaFile?, LoadedStickerPack?)
    case voiceToText
    case fasterDownload
    case translation
    case stories
    case storiesDownload
    case storiesStealthMode
    case storiesPermanentViews
    case storiesFormatting
    case storiesExpirationDurations
    case storiesSuggestedReactions
    case channelBoost(EnginePeer.Id)
    case nameColor
    case similarChannels
    case wallpapers
    case presence
}

public enum PremiumGiftSource: Equatable {
    case profile
    case attachMenu
    case settings
    case chatList
    case channelBoost
    case deeplink(String?)
}

public enum PremiumDemoSubject {
    case doubleLimits
    case moreUpload
    case fasterDownload
    case voiceToText
    case noAds
    case uniqueReactions
    case premiumStickers
    case advancedChatManagement
    case profileBadge
    case animatedUserpics
    case appIcons
    case animatedEmoji
    case emojiStatus
    case translation
    case stories
    case colors
    case wallpapers
}

public enum PremiumLimitSubject {
    case folders
    case chatsPerFolder
    case pins
    case files
    case accounts
    case linksPerSharedFolder
    case membershipInSharedFolders
    case channels
    case expiringStories
    case storiesWeekly
    case storiesMonthly
    case storiesChannelBoost(peer: EnginePeer, isCurrent: Bool, level: Int32, currentLevelBoosts: Int32, nextLevelBoosts: Int32?, link: String?, myBoostCount: Int32, canBoostAgain: Bool)
}

public protocol ComposeController: ViewController {
}

public protocol ChatLocationContextHolder: AnyObject {
}

public protocol AccountGroupCallContext: AnyObject {
}

public protocol AccountGroupCallContextCache: AnyObject {
}

public protocol AccountContext: AnyObject {
    var sharedContext: SharedAccountContext { get }
    var account: Account { get }
    var engine: TelegramEngine { get }
    
    var liveLocationManager: LiveLocationManager? { get }
    var peersNearbyManager: PeersNearbyManager? { get }
    var fetchManager: FetchManager { get }
    var prefetchManager: PrefetchManager? { get }
    var downloadedMediaStoreManager: DownloadedMediaStoreManager { get }
    var peerChannelMemberCategoriesContextsManager: PeerChannelMemberCategoriesContextsManager { get }
    var wallpaperUploadManager: WallpaperUploadManager? { get }
    var watchManager: WatchManager? { get }
    var inAppPurchaseManager: InAppPurchaseManager? { get }
    
    var currentLimitsConfiguration: Atomic<LimitsConfiguration> { get }
    var currentContentSettings: Atomic<ContentSettings> { get }
    var currentAppConfiguration: Atomic<AppConfiguration> { get }
    var currentCountriesConfiguration: Atomic<CountriesConfiguration> { get }
    
    var cachedGroupCallContexts: AccountGroupCallContextCache { get }
    
    var animationCache: AnimationCache { get }
    var animationRenderer: MultiAnimationRenderer { get }
    
    var animatedEmojiStickers: [String: [StickerPackItem]] { get }
    
    var isPremium: Bool { get }
    var userLimits: EngineConfiguration.UserLimits { get }
    var peerNameColors: PeerNameColors { get }
    
    var imageCache: AnyObject? { get }
    
    func storeSecureIdPassword(password: String)
    func getStoredSecureIdPassword() -> String?
    
    func chatLocationInput(for location: ChatLocation, contextHolder: Atomic<ChatLocationContextHolder?>) -> ChatLocationInput
    func chatLocationOutgoingReadState(for location: ChatLocation, contextHolder: Atomic<ChatLocationContextHolder?>) -> Signal<MessageId?, NoError>
    func chatLocationUnreadCount(for location: ChatLocation, contextHolder: Atomic<ChatLocationContextHolder?>) -> Signal<Int, NoError>
    func applyMaxReadIndex(for location: ChatLocation, contextHolder: Atomic<ChatLocationContextHolder?>, messageIndex: MessageIndex)
    
    func scheduleGroupCall(peerId: PeerId)
    func joinGroupCall(peerId: PeerId, invite: String?, requestJoinAsPeerId: ((@escaping (PeerId?) -> Void) -> Void)?, activeCall: EngineGroupCallDescription)
    func requestCall(peerId: PeerId, isVideo: Bool, completion: @escaping () -> Void)
}

public struct PremiumConfiguration {
    public static var defaultValue: PremiumConfiguration {
        return PremiumConfiguration(
            isPremiumDisabled: false,
            showPremiumGiftInAttachMenu: false,
            showPremiumGiftInTextField: false,
            giveawayGiftsPurchaseAvailable: false,
            boostsPerGiftCount: 3,
            audioTransciptionTrialMaxDuration: 300,
            audioTransciptionTrialCount: 2,
            minChannelNameColorLevel: 1,
            minChannelNameIconLevel: 4,
            minChannelProfileColorLevel: 5,
            minChannelProfileIconLevel: 7,
            minChannelEmojiStatusLevel: 8,
            minChannelWallpaperLevel: 9,
            minChannelCustomWallpaperLevel: 10
        )
    }
    
    public let isPremiumDisabled: Bool
    public let showPremiumGiftInAttachMenu: Bool
    public let showPremiumGiftInTextField: Bool
    public let giveawayGiftsPurchaseAvailable: Bool
    public let boostsPerGiftCount: Int32
    public let audioTransciptionTrialMaxDuration: Int32
    public let audioTransciptionTrialCount: Int32
    public let minChannelNameColorLevel: Int32
    public let minChannelNameIconLevel: Int32
    public let minChannelProfileColorLevel: Int32
    public let minChannelProfileIconLevel: Int32
    public let minChannelEmojiStatusLevel: Int32
    public let minChannelWallpaperLevel: Int32
    public let minChannelCustomWallpaperLevel: Int32
    
    fileprivate init(
        isPremiumDisabled: Bool,
        showPremiumGiftInAttachMenu: Bool,
        showPremiumGiftInTextField: Bool,
        giveawayGiftsPurchaseAvailable: Bool,
        boostsPerGiftCount: Int32,
        audioTransciptionTrialMaxDuration: Int32,
        audioTransciptionTrialCount: Int32,
        minChannelNameColorLevel: Int32,
        minChannelNameIconLevel: Int32,
        minChannelProfileColorLevel: Int32,
        minChannelProfileIconLevel: Int32,
        minChannelEmojiStatusLevel: Int32,
        minChannelWallpaperLevel: Int32,
        minChannelCustomWallpaperLevel: Int32
    
    ) {
        self.isPremiumDisabled = isPremiumDisabled
        self.showPremiumGiftInAttachMenu = showPremiumGiftInAttachMenu
        self.showPremiumGiftInTextField = showPremiumGiftInTextField
        self.giveawayGiftsPurchaseAvailable = giveawayGiftsPurchaseAvailable
        self.boostsPerGiftCount = boostsPerGiftCount
        self.audioTransciptionTrialMaxDuration = audioTransciptionTrialMaxDuration
        self.audioTransciptionTrialCount = audioTransciptionTrialCount
        self.minChannelNameColorLevel = minChannelNameColorLevel
        self.minChannelNameIconLevel = minChannelNameIconLevel
        self.minChannelProfileColorLevel = minChannelProfileColorLevel
        self.minChannelProfileIconLevel = minChannelProfileIconLevel
        self.minChannelEmojiStatusLevel = minChannelEmojiStatusLevel
        self.minChannelWallpaperLevel = minChannelWallpaperLevel
        self.minChannelCustomWallpaperLevel = minChannelCustomWallpaperLevel
    }
    
    public static func with(appConfiguration: AppConfiguration) -> PremiumConfiguration {
        let defaultValue = self.defaultValue
        if let data = appConfiguration.data {
            func get(_ value: Any?) -> Int32? {
                return (value as? Double).flatMap(Int32.init)
            }
            return PremiumConfiguration(
                isPremiumDisabled: data["premium_purchase_blocked"] as? Bool ?? defaultValue.isPremiumDisabled,
                showPremiumGiftInAttachMenu: data["premium_gift_attach_menu_icon"] as? Bool ?? defaultValue.showPremiumGiftInAttachMenu,
                showPremiumGiftInTextField: data["premium_gift_text_field_icon"] as? Bool ?? defaultValue.showPremiumGiftInTextField,
                giveawayGiftsPurchaseAvailable: data["giveaway_gifts_purchase_available"] as? Bool ?? defaultValue.giveawayGiftsPurchaseAvailable,
                boostsPerGiftCount: get(data["boosts_per_sent_gift"]) ?? defaultValue.boostsPerGiftCount,
                audioTransciptionTrialMaxDuration: get(data["transcribe_audio_trial_duration_max"]) ?? defaultValue.audioTransciptionTrialMaxDuration,
                audioTransciptionTrialCount: get(data["transcribe_audio_trial_weekly_number"]) ?? defaultValue.audioTransciptionTrialCount,
                minChannelNameColorLevel: get(data["channel_color_level_min"]) ?? defaultValue.minChannelNameColorLevel,
                minChannelNameIconLevel: get(data["channel_bg_icon_level_min"]) ?? defaultValue.minChannelNameIconLevel,
                minChannelProfileColorLevel: get(data["channel_profile_color_level_min"]) ?? defaultValue.minChannelProfileColorLevel,
                minChannelProfileIconLevel: get(data["channel_profile_bg_icon_level_min"]) ?? defaultValue.minChannelProfileIconLevel,
                minChannelEmojiStatusLevel: get(data["channel_emoji_status_level_min"]) ?? defaultValue.minChannelEmojiStatusLevel,
                minChannelWallpaperLevel: get(data["channel_wallpaper_level_min"]) ?? defaultValue.minChannelWallpaperLevel,
                minChannelCustomWallpaperLevel: get(data["channel_custom_wallpaper_level_min"]) ?? defaultValue.minChannelCustomWallpaperLevel
            )
        } else {
            return defaultValue
        }
    }
}

public struct AntiSpamBotConfiguration {
    public static var defaultValue: AntiSpamBotConfiguration {
        return AntiSpamBotConfiguration(antiSpamBotId: nil, minimumGroupParticipants: 100)
    }
    
    public let antiSpamBotId: EnginePeer.Id?
    public let minimumGroupParticipants: Int32
    
    fileprivate init(antiSpamBotId: EnginePeer.Id?, minimumGroupParticipants: Int32) {
        self.antiSpamBotId = antiSpamBotId
        self.minimumGroupParticipants = minimumGroupParticipants
    }
    
    public static func with(appConfiguration: AppConfiguration) -> AntiSpamBotConfiguration {
        if let data = appConfiguration.data, let botIdString = data["telegram_antispam_user_id"] as? String, let botIdValue = Int64(botIdString), let groupSize = data["telegram_antispam_group_size_min"] as? Double {
            return AntiSpamBotConfiguration(antiSpamBotId: EnginePeer.Id(namespace: Namespaces.Peer.CloudUser, id: EnginePeer.Id.Id._internalFromInt64Value(botIdValue)), minimumGroupParticipants: Int32(groupSize))
        } else {
            return .defaultValue
        }
    }
}

public struct StoriesConfiguration {
    public enum PostingAvailability {
        case enabled
        case premium
        case disabled
    }
    
    public enum CaptionEntitiesAvailability {
        case enabled
        case premium
    }
    
    static var defaultValue: StoriesConfiguration {
        return StoriesConfiguration(posting: .disabled, captionEntities: .premium, venueSearchBot: "foursquare")
    }
    
    public let posting: PostingAvailability
    public let captionEntities: CaptionEntitiesAvailability
    public let venueSearchBot: String
    
    fileprivate init(posting: PostingAvailability, captionEntities: CaptionEntitiesAvailability, venueSearchBot: String) {
        self.posting = posting
        self.captionEntities = captionEntities
        self.venueSearchBot = venueSearchBot
    }
    
    public static func with(appConfiguration: AppConfiguration) -> StoriesConfiguration {
        if let data = appConfiguration.data {
            let posting: PostingAvailability
            let captionEntities: CaptionEntitiesAvailability
            let venueSearchBot: String
            if let postingString = data["stories_posting"] as? String {
                switch postingString {
                case "enabled":
                    posting = .enabled
                case "premium":
                    posting = .premium
                default:
                    posting = .disabled
                }
            } else {
                posting = .disabled
            }
            if let entitiesString = data["stories_entities"] as? String {
                switch entitiesString {
                case "enabled":
                    captionEntities = .enabled
                default:
                    captionEntities = .premium
                }
            } else {
                captionEntities = .premium
            }
            if let venueSearchBotString = data["stories_venue_search_username"] as? String {
                venueSearchBot = venueSearchBotString
            } else {
                venueSearchBot = "foursquare"
            }
            return StoriesConfiguration(posting: posting, captionEntities: captionEntities, venueSearchBot: venueSearchBot)
        } else {
            return .defaultValue
        }
    }
}

public struct StickersSearchConfiguration {
    static var defaultValue: StickersSearchConfiguration {
        return StickersSearchConfiguration(disableLocalSuggestions: false)
    }
    
    public let disableLocalSuggestions: Bool
    
    fileprivate init(disableLocalSuggestions: Bool) {
        self.disableLocalSuggestions = disableLocalSuggestions
    }
    
    public static func with(appConfiguration: AppConfiguration) -> StickersSearchConfiguration {
        if let data = appConfiguration.data, let suggestOnlyApi = data["stickers_emoji_suggest_only_api"] as? Bool {
            return StickersSearchConfiguration(disableLocalSuggestions: suggestOnlyApi)
        } else {
            return .defaultValue
        }
    }
}

private extension PeerNameColors.Colors {
    init?(colors: EngineAvailableColorOptions.MultiColorPack) {
        if colors.colors.isEmpty {
            return nil
        }
        self.main = UIColor(rgb: colors.colors[0])
        if colors.colors.count > 1 {
            self.secondary = UIColor(rgb: colors.colors[1])
        } else {
            self.secondary = nil
        }
        if colors.colors.count > 2 {
            self.tertiary = UIColor(rgb: colors.colors[2])
        } else {
            self.tertiary = nil
        }
    }
}

public class PeerNameColors: Equatable {
    public enum Subject {
        case background
        case palette
        case stories
    }
    
    public struct Colors: Equatable {
        public let main: UIColor
        public let secondary: UIColor?
        public let tertiary: UIColor?
        
        public init(main: UIColor, secondary: UIColor?, tertiary: UIColor?) {
            self.main = main
            self.secondary = secondary
            self.tertiary = tertiary
        }
        
        public init(main: UIColor) {
            self.main = main
            self.secondary = nil
            self.tertiary = nil
        }
        
        public init?(colors: [UIColor]) {
            guard let first = colors.first else {
                return nil
            }
            self.main = first
            if colors.count == 3 {
                self.secondary = colors[1]
                self.tertiary = colors[2]
            } else if colors.count == 2, let second = colors.last {
                self.secondary = second
                self.tertiary = nil
            } else {
                self.secondary = nil
                self.tertiary = nil
            }
        }
    }
    
    public static var defaultSingleColors: [Int32: Colors] {
        return [
            0: Colors(main: UIColor(rgb: 0xcc5049)),
            1: Colors(main: UIColor(rgb: 0xd67722)),
            2: Colors(main: UIColor(rgb: 0x955cdb)),
            3: Colors(main: UIColor(rgb: 0x40a920)),
            4: Colors(main: UIColor(rgb: 0x309eba)),
            5: Colors(main: UIColor(rgb: 0x368ad1)),
            6: Colors(main: UIColor(rgb: 0xc7508b))
        ]
    }
    
    public static var defaultValue: PeerNameColors {
        return PeerNameColors(
            colors: defaultSingleColors,
            darkColors: [:],
            displayOrder: [5, 3, 1, 0, 2, 4, 6],
            profileColors: [:],
            profileDarkColors: [:],
            profilePaletteColors: [:],
            profilePaletteDarkColors: [:],
            profileStoryColors: [:],
            profileStoryDarkColors: [:],
            profileDisplayOrder: [],
            nameColorsChannelMinRequiredBoostLevel: [:]
        )
    }
    
    public let colors: [Int32: Colors]
    public let darkColors: [Int32: Colors]
    public let displayOrder: [Int32]
    
    public let profileColors: [Int32: Colors]
    public let profileDarkColors: [Int32: Colors]
    public let profilePaletteColors: [Int32: Colors]
    public let profilePaletteDarkColors: [Int32: Colors]
    public let profileStoryColors: [Int32: Colors]
    public let profileStoryDarkColors: [Int32: Colors]
    public let profileDisplayOrder: [Int32]
    
    public let nameColorsChannelMinRequiredBoostLevel: [Int32: Int32]
    
    public func get(_ color: PeerNameColor, dark: Bool = false) -> Colors {
        if dark, let colors = self.darkColors[color.rawValue] {
            return colors
        } else if let colors = self.colors[color.rawValue] {
            return colors
        } else {
            return PeerNameColors.defaultSingleColors[5]!
        }
    }
    
    public func getProfile(_ color: PeerNameColor, dark: Bool = false, subject: Subject = .background) -> Colors {
        switch subject {
        case .background:
            if dark, let colors = self.profileDarkColors[color.rawValue] {
                return colors
            } else if let colors = self.profileColors[color.rawValue] {
                return colors
            } else {
                return Colors(main: UIColor(rgb: 0xcc5049))
            }
        case .palette:
            if dark, let colors = self.profilePaletteDarkColors[color.rawValue] {
                return colors
            } else if let colors = self.profilePaletteColors[color.rawValue] {
                return colors
            } else {
                return self.getProfile(color, dark: dark, subject: .background)
            }
        case .stories:
            if dark, let colors = self.profileStoryDarkColors[color.rawValue] {
                return colors
            } else if let colors = self.profileStoryColors[color.rawValue] {
                return colors
            } else {
                return self.getProfile(color, dark: dark, subject: .background)
            }
        }
    }
    
    fileprivate init(
        colors: [Int32: Colors],
        darkColors: [Int32: Colors],
        displayOrder: [Int32],
        profileColors: [Int32: Colors],
        profileDarkColors: [Int32: Colors],
        profilePaletteColors: [Int32: Colors],
        profilePaletteDarkColors: [Int32: Colors],
        profileStoryColors: [Int32: Colors],
        profileStoryDarkColors: [Int32: Colors],
        profileDisplayOrder: [Int32],
        nameColorsChannelMinRequiredBoostLevel: [Int32: Int32]
    ) {
        self.colors = colors
        self.darkColors = darkColors
        self.displayOrder = displayOrder
        self.profileColors = profileColors
        self.profileDarkColors = profileDarkColors
        self.profilePaletteColors = profilePaletteColors
        self.profilePaletteDarkColors = profilePaletteDarkColors
        self.profileStoryColors = profileStoryColors
        self.profileStoryDarkColors = profileStoryDarkColors
        self.profileDisplayOrder = profileDisplayOrder
        self.nameColorsChannelMinRequiredBoostLevel = nameColorsChannelMinRequiredBoostLevel
    }
    
    public static func with(availableReplyColors: EngineAvailableColorOptions, availableProfileColors: EngineAvailableColorOptions) -> PeerNameColors {
        var colors: [Int32: Colors] = [:]
        var darkColors: [Int32: Colors] = [:]
        var displayOrder: [Int32] = []
        var profileColors: [Int32: Colors] = [:]
        var profileDarkColors: [Int32: Colors] = [:]
        var profilePaletteColors: [Int32: Colors] = [:]
        var profilePaletteDarkColors: [Int32: Colors] = [:]
        var profileStoryColors: [Int32: Colors] = [:]
        var profileStoryDarkColors: [Int32: Colors] = [:]
        var profileDisplayOrder: [Int32] = []
        
        var nameColorsChannelMinRequiredBoostLevel: [Int32: Int32] = [:]
        
        if !availableReplyColors.options.isEmpty {
            for option in availableReplyColors.options {
                if let requiredChannelMinBoostLevel = option.value.requiredChannelMinBoostLevel {
                    nameColorsChannelMinRequiredBoostLevel[option.key] = requiredChannelMinBoostLevel
                }
                
                if let parsedLight = PeerNameColors.Colors(colors: option.value.light.background) {
                    colors[option.key] = parsedLight
                }
                if let parsedDark = (option.value.dark?.background).flatMap(PeerNameColors.Colors.init(colors:)) {
                    darkColors[option.key] = parsedDark
                }
                
                for option in availableReplyColors.options {
                    if !displayOrder.contains(option.key) {
                        displayOrder.append(option.key)
                    }
                }
            }
        } else {
            let defaultValue = PeerNameColors.defaultValue
            colors = defaultValue.colors
            darkColors = defaultValue.darkColors
            displayOrder = defaultValue.displayOrder
        }
            
        if !availableProfileColors.options.isEmpty {
            for option in availableProfileColors.options {
                if let parsedLight = PeerNameColors.Colors(colors: option.value.light.background) {
                    profileColors[option.key] = parsedLight
                }
                if let parsedDark = (option.value.dark?.background).flatMap(PeerNameColors.Colors.init(colors:)) {
                    profileDarkColors[option.key] = parsedDark
                }
                if let parsedPaletteLight = PeerNameColors.Colors(colors: option.value.light.palette) {
                    profilePaletteColors[option.key] = parsedPaletteLight
                }
                if let parsedPaletteDark = (option.value.dark?.palette).flatMap(PeerNameColors.Colors.init(colors:)) {
                    profilePaletteDarkColors[option.key] = parsedPaletteDark
                }
                if let parsedStoryLight = (option.value.light.stories).flatMap(PeerNameColors.Colors.init(colors:)) {
                    profileStoryColors[option.key] = parsedStoryLight
                }
                if let parsedStoryDark = (option.value.dark?.stories).flatMap(PeerNameColors.Colors.init(colors:)) {
                    profileStoryDarkColors[option.key] = parsedStoryDark
                }
                for option in availableProfileColors.options {
                    if !profileDisplayOrder.contains(option.key) {
                        profileDisplayOrder.append(option.key)
                    }
                }
            }
        }
        
        return PeerNameColors(
            colors: colors,
            darkColors: darkColors,
            displayOrder: displayOrder,
            profileColors: profileColors,
            profileDarkColors: profileDarkColors,
            profilePaletteColors: profilePaletteColors,
            profilePaletteDarkColors: profilePaletteDarkColors,
            profileStoryColors: profileStoryColors,
            profileStoryDarkColors: profileStoryDarkColors,
            profileDisplayOrder: profileDisplayOrder,
            nameColorsChannelMinRequiredBoostLevel: nameColorsChannelMinRequiredBoostLevel
        )
    }
    
    public static func == (lhs: PeerNameColors, rhs: PeerNameColors) -> Bool {
        if lhs.colors != rhs.colors {
            return false
        }
        if lhs.darkColors != rhs.darkColors {
            return false
        }
        if lhs.displayOrder != rhs.displayOrder {
            return false
        }
        if lhs.profileColors != rhs.profileColors {
            return false
        }
        if lhs.profileDarkColors != rhs.profileDarkColors {
            return false
        }
        if lhs.profilePaletteColors != rhs.profilePaletteColors {
            return false
        }
        if lhs.profilePaletteDarkColors != rhs.profilePaletteDarkColors {
            return false
        }
        if lhs.profileStoryColors != rhs.profileStoryColors {
            return false
        }
        if lhs.profileStoryDarkColors != rhs.profileStoryDarkColors {
            return false
        }
        if lhs.profileDisplayOrder != rhs.profileDisplayOrder {
            return false
        }
        return true
    }
}
