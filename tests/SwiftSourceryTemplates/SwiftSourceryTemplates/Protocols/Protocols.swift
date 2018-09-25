//
//  Protocols.swift
//  SwiftSourceryTemplates
//
//  Created by Ivan Misuno on 18/07/2018.
//  Copyright © 2018 AlbumPrinter BV. All rights reserved.
//

import RxSwift
import Alamofire // for `Result`

// sourcery: CreateMock
protocol DataSource {
    var bindingTarget: AnyObserver<UploadAPI.LocalFile> { get }
}

// sourcery: CreateMock
protocol UploadProgressing {
    var progress: Observable<Result<Double>> { get }
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress>
}

// sourcery: CreateMock
protocol FileService {
    func upload(fileUrl: URL) -> Single<()>
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
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> NSImage
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data
}

// sourcery: CreateMock
protocol ImageAttributeProviding {
    func imagePixelSize(source: UploadAPI.LocalFile.Source) throws -> CGSize
}

// sourcery: CreateMock
protocol AlbumPageSizeProviderDelegate: class {
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

/// sourcery: CreateMock
protocol DuplicateGenericTypeNames {
    // sourcery: generictype = T
    func action<T>(_: T)
    // sourcery: generictype = T
    func action2<T>(_: T)
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
    // sourcery: generictype = "T: RawRepresentable, Hashable"
    func buildPopoverPresenter<T>(
        title: String,
        // sourcery: annotatedGenericTypes = "[(title: String, identifier: {T}, handler: ()->())]"
        buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T> where T: RawRepresentable, T: Hashable
}

// sourcery: CreateMock
// sourcery: TypeErase
public protocol Interactable: class {
}

// sourcery: CreateMock
// sourcery: TypeErase
// sourcery: associatedtype = "InteractorType: Interactable"
public protocol Routing: class {
    associatedtype InteractorType: Interactable
    var interactor: InteractorType { get }
}

// sourcery: CreateMock
public protocol SomeInteractable: Interactable {
}

// sourcery: CreateMock
// sourcery: TypeErase
// sourcery: associatedtype = "InteractorType: SomeInteractable"
public protocol SomeRouting: Routing {
    associatedtype InteractorType: SomeInteractable
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = EventType
protocol ErrorPopoverPresentable {
    associatedtype EventType
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType>
    func setActionSink(_ actionSink: AnyObject?)
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = "EventType: RawRepresentable, Hashable"
protocol ErrorPopoverPresentableRawRepresentable {
    associatedtype EventType: RawRepresentable, Hashable
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType>
}

/// sourcery: CreateMock
protocol TipsManaging: class {
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
@objc public protocol AppKitEvent {
    // sourcery: const, init
    var locationInWindow: NSPoint { get }
    // sourcery: const, init
    var modifierFlags: NSEvent.ModifierFlags { get }
}

/// sourcery: CreateMock
protocol ProtocolWithExtensions {
    var protocolRequirement: Int { get }
    func requiredInProtocol()
}

extension ProtocolWithExtensions {
    var implementedInExtension: Int {
        return 5
    }

    func extended(completionCallback callback: (@escaping () -> ())?) {
        callback?()
    }
}
