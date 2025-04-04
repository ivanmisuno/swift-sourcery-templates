//
//  Protocols.swift
//  SwiftSourceryTemplates
//
//  Created by Ivan Misuno on 18/07/2018.
//  Copyright © 2018 AlbumPrinter BV. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Alamofire // for `Result`
import SwiftUI
import Combine

// sourcery: CreateMock
protocol DataSource {
    var bindingTarget: AnyObserver<UploadAPI.LocalFile> { get }
    func bindStreams() -> Disposable
}

// sourcery: CreateMock
protocol UploadProgressing {
    var progress: Observable<Result<Double>> { get }
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress>
}

// sourcery: CreateMock
protocol FileService {
    func upload(fileUrl: URL) -> Single<[FilePart]>
}

// sourcery: CreateMock
protocol MutableUploadProgressing: UploadProgressing {
    func setInputFiles(localFiles: [UploadAPI.LocalFile])
    func uploadIdRetrieved(localFile: UploadAPI.LocalFile, uploadId: UploadAPI.UploadId)
    func filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart])
    func filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress)
    func downloadUrlsRetrieved()
}

// sourcery: CreateMock
protocol ThumbCreating {
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> UIImage
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data
}

// sourcery: CreateMock
protocol ImageAttributeProviding {
    func imagePixelSize(source: UploadAPI.LocalFile.Source) throws -> CGSize
}

// sourcery: CreateMock
protocol AlbumPageSizeProviderDelegate: AnyObject {
    var onComplete: AnyObserver<()> { get }
}

// sourcery: CreateMock
protocol AlbumPageSizeProviding {
    var delegate: AlbumPageSizeProviderDelegate? { get set }
    var pageSize: CGSize { get }
}

// sourcery: CreateMock
protocol ExifImageAttributeProviding {
    func dateTaken(fileUrl: URL) -> Date?
}

// sourcery: CreateMock
protocol ProtocolWithCollections {
    var items: Set<String> { get }
    var data: Array<String> { get }
    var mapping: Dictionary<String, Int> { get }

    func getItems() -> Set<String>
    func getData() -> Array<String>
    func getMapping() -> Dictionary<String, Int>
}

/// sourcery: CreateMock
protocol DuplicateGenericTypeNames {
    // sourcery: generictype = T
    func action<T>(
        // sourcery: annotatedGenericTypes = "{T}"
        _ a: T)
    // sourcery: generictype = T
    func action2<T>(
        // sourcery: annotatedGenericTypes = "{T}"
        _ a: T)
}

/// sourcery: CreateMock
protocol ErrorPopoverBuildable {
    // sourcery: generictype = T1
    func buildDefaultPopoverPresenter<T1>(title: String) -> AnyErrorPopoverPresentable<T1>
    // sourcery: generictype = T2
    func buildPopoverPresenter<T2>(
        title: String,
        // sourcery: annotatedGenericTypes = "[(title: String, identifier: {T2}, handler: ()->())]"
        buttons: [(title: String, identifier: T2, handler: ()->())]) -> AnyErrorPopoverPresentable<T2>
}

/// sourcery: CreateMock
protocol ErrorPopoverBuildableRawRepresentable {
    // sourcery: generictype = "T: RawRepresentable, T: Hashable"
    func buildPopoverPresenter<T>(
        title: String,
        // sourcery: annotatedGenericTypes = "[(title: String, identifier: {T}, handler: ()->())]"
        buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T> where T: RawRepresentable, T: Hashable
}

/// sourcery: CreateMock
protocol ErrorPresenting {
    // sourcery: genericType = "T: RawRepresentable, T: Hashable"
    func presentErrorPopover<T>(
        // sourcery: genericTypePlaceholder = "AnyErrorPopoverPresentable<{T}>"
        _ popoverPresenter: AnyErrorPopoverPresentable<T>) -> Observable<T> where T: RawRepresentable, T: Hashable
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = EventType
protocol ErrorPopoverPresentable {
    associatedtype EventType
    //func show(relativeTo positioningRect: CGRect, of positioningView: UIView, preferredEdge: CGRectEdge) -> Observable<EventType>
    func setActionSink(_ actionSink: AnyObject?)
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = "EventType: RawRepresentable, EventType: Hashable"
protocol ErrorPopoverPresentableRawRepresentable {
    associatedtype EventType: RawRepresentable, Hashable
    //func show(relativeTo positioningRect: CGRect, of positioningView: UIView, preferredEdge: CGRectEdge) -> Observable<EventType>
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = "EventType"
protocol ThrowingGenericBuildable {
    associatedtype EventType
    func build() throws -> AnyErrorPopoverPresentable<EventType>
}

/// sourcery: CreateMock
protocol TipsManaging: AnyObject {
    var tips: [String: String] { get }
    var tipsOptional: [String: String]? { get }
    var tupleVariable: (String, Int) { get }
    var tupleVariable2: (String?, Int?) { get }
    var tupleOptional: (String, Int)? { get }
    var arrayVariable: [Double] { get }
}

/// sourcery: CreateMock
@objc protocol LegacyProtocol: NSObjectProtocol {
    var tips: [String: String] { get }
    func compare(_ lhs: CGSize, _ rhs: CGSize) -> ComparisonResult
}

/// sourcery: CreateMock
protocol DuplicateRequirements {
    var tips: [String: String] { get }
    func updateTips(_ tips: [Tip])
    func updateTips(with tips: AnySequence<Tip>) throws
}

/// sourcery: CreateMock
protocol DuplicateRequirementsSameLevel {
    func update(cropRect: CGRect)
    func update(cropHandles: [CGPoint])
    func update(effects: [String])
}

/// sourcery: CreateMock
protocol MutableTipsManaging: TipsManaging, DuplicateRequirements {
    func updateTips(_ tips: [Tip])
    func updateTips(with tips: AnySequence<Tip>) throws
}

/// sourcery: CreateMock
protocol TipsAccessing {
    /// sourcery: handler
    var tip: Tip { get }
}

/// sourcery: CreateMock
protocol MutableTipsAccessing {
    /// sourcery: handler
    var tip: Tip { get set }
}

/// sourcery: CreateMock
protocol TipsManagerBuilding {
    func build() -> TipsManaging & MutableTipsManaging
}

/// sourcery: CreateMock
protocol ObjectManupulating {
    @discardableResult
    func removeObject() -> Int

    @discardableResult
    func removeObject(where matchPredicate: @escaping (Any) throws -> (Bool)) rethrows -> Int

    @discardableResult
    func removeObject(_ object: @autoclosure () throws -> Any) rethrows -> Int
}

/// sourcery: CreateMock
@objc public protocol UIKitEvent {
    // sourcery: const, init
    var locationInWindow: CGPoint { get }
    // sourcery: const, init
  var modifierFlags: UIEvent.EventType { get }
}

enum ShapeType: CaseIterable {
    case circle
    case rect
    case tri
}

typealias Shape1 = (
  type: ShapeType,
  origin: CGPoint,
  size: CGFloat,
  linearSpeed: CGPoint,
  angle: CGFloat,
  angularSpeed: CGFloat,
  strokeColor: UIColor,
  fillColor: UIColor
)

///// sourcery: CreateMock
//protocol ShapesAccessing {
//    var shapes: Observable<[Shape1]> { get }
//}

/// sourcery: CreateMock
protocol ProtocolWithExtensions {
    var protocolRequirement: Int { get }
    func requiredInProtocol()
}

extension ProtocolWithExtensions {
    var implementedInExtension: Int {
        return 5
    }

    func extended(completionCallback callback: (() -> ())?) {
        callback?()
    }
}

/// sourcery: CreateMock
// protocol EdgeCases {
//     func functionMissingArgumentLabel(_: Int)
// }

typealias RealmNotificationInteropBlock = (_ notification: Notification, _ realmInterop: RealmInterop) -> ()
class RLObject {}
class RLList<Element> {}
class RLResults<Element> {}
struct RLNotificationToken {}

/// sourcery: CreateMock
protocol RealmInterop: AnyObject
{
    func write(_ block: (() throws -> Void)) throws
    func beginWrite()
    func commitWrite(withoutNotifying tokens: [RLNotificationToken]) throws
    func cancelWrite()
    var isInWriteTransaction: Bool { get }

    /// sourcery: methodName = addObject
    func add(_ object: RLObject, update: Bool)

    /// sourcery: methodName = addObjects
    /// sourcery: genericType = "S: Sequence, S.Iterator.Element: RLObject"
    func add<S>(
        // sourcery: annotatedGenericTypes = "{S}"
        _ objects: S,
        update: Bool) where S: Sequence, S.Iterator.Element: RLObject

    /// sourcery: genericType = "Element: RLObject"
    func create<Element>(
        // sourcery: annotatedGenericTypes = "{Element}.Type"
        _ type: Element.Type,
        value: Any,
        update: Bool) -> Element where Element: RLObject

    /// sourcery: methodName = deleteObject
    func delete(_ object: RLObject)

    /// sourcery: methodName = deleteObjects
    /// sourcery: genericType = "S: Sequence, S.Iterator.Element: RLObject"
    func delete<S>(
        // sourcery: annotatedGenericTypes = "{S}"
        _ objects: S) where S: Sequence, S.Iterator.Element: RLObject

    /// sourcery: methodName = deleteList
    /// sourcery: genericType = "Element: RLObject"
    func delete<Element>(
        // sourcery: annotatedGenericTypes = "RLList<{Element}>"
        _ objects: RLList<Element>) where Element: RLObject

    /// sourcery: methodName = deleteResults
    /// sourcery: genericType = "Element: RLObject"
    func delete<Element>(
        // sourcery: annotatedGenericTypes = "RLResults<{Element}>"
        _ objects: RLResults<Element>) where Element: RLObject

    func deleteAll()

    /// sourcery: genericType = "Element: RLObject"
    func objects<Element>(
        // sourcery: annotatedGenericTypes = "{Element}.Type"
        _ type: Element.Type) -> RLResults<Element> where Element: RLObject

    /// sourcery: genericType = "Element: RLObject, KeyType"
    func object<Element, KeyType>(
        // sourcery: annotatedGenericTypes = "{Element}.Type"
        ofType type: Element.Type,
        // sourcery: annotatedGenericTypes = "{KeyType}"
        forPrimaryKey key: KeyType) -> Element? where Element: RLObject

    func observe(_ block: @escaping RealmNotificationInteropBlock) -> RLNotificationToken
    var autorefresh: Bool { get set }
    func refresh() -> Bool
    func invalidate()
    func writeCopy(toFile fileURL: URL, encryptionKey: Data?) throws
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedType = "DocumentType: Codable"
public protocol CodableDocumentStoring {
  associatedtype DocumentType: Codable

  var documentId: String { get }

  func get(
    /// sourcery: annotatedGenericTypes = "{DocumentType.Type}"
    as type: DocumentType.Type) -> Swift.Result<DocumentType?, Error>

//  func observe(
//    /// sourcery: annotatedGenericTypes = "{DocumentType.Type}"
//    as type: DocumentType.Type) -> Observable<DocumentType?>

  func set(
    /// sourcery: annotatedGenericTypes = "{DocumentType}"
    _ data: DocumentType) -> Single<Void>

  func delete() -> Single<Void>
}

/// sourcery: CreateMock
public protocol LearningSessionsCollectionStoring {
  func latestSession() -> Observable<(any CodableDocumentStoring)?>
}

/// sourcery: CreateMock
public protocol SomeEntityBindable {
  func entityObserver() -> AnyObserver<String>
}

/// sourcery: CreateMock
/// sourcery: associatedtype = "TaskAuxilliaryView: View"
public protocol MultiplicationByCountingTaskVariationBuildable {
  associatedtype TaskAuxilliaryView: View
  func taskAuxilliaryView(
    answer: CurrentValueSubject<String, Never>,
    cancellables: inout Set<AnyCancellable>) -> TaskAuxilliaryView
}
