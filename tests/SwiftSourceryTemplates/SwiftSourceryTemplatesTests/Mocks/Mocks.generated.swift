// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//swiftlint:disable force_cast
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

import Alamofire
import RxBlocking
import RxSwift
import RxTest
@testable import SwiftSourceryTemplates

// MARK: - AlbumPageSizeProviderDelegate
class AlbumPageSizeProviderDelegateMock: AlbumPageSizeProviderDelegate {
}

// MARK: - AlbumPageSizeProviding
class AlbumPageSizeProvidingMock: AlbumPageSizeProviding {

    // MARK: - Variables
    var delegate: AlbumPageSizeProviderDelegate? = nil {
        didSet {
            delegateSetCount += 1
        }
    }
    var delegateSetCount: Int = 0
    var pageSize: CGSize = CGSize.zero
}

// MARK: - DataSource
class DataSourceMock: DataSource {

    // MARK: - Variables
    var bindingTarget: AnyObserver<UploadAPI.LocalFile> {
        bindingTargetGetCount += 1
        if let handler = bindingTargetGetHandler {
            return handler()
        }
        return AnyObserver { [weak self] event in
            self?.bindingTargetEventCallCount += 1
            self?.bindingTargetEventHandler?(event)
        }
    }
    var bindingTargetGetCount: Int = 0
    var bindingTargetGetHandler: (() -> AnyObserver<UploadAPI.LocalFile>)? = nil
    var bindingTargetEventCallCount: Int = 0
    var bindingTargetEventHandler: ((Event<UploadAPI.LocalFile>) -> ())? = nil
}

// MARK: - DuplicateGenericTypeNames
// Duplicate generic type name found while generating mock implementation: `func action2<T>(_: T)` has generic type name `T` which is not unique across all generic types for the protocol (["T"]). Please change protocol declaration so that generic types have unique names!

// MARK: - DuplicateRequirements
class DuplicateRequirementsMock: DuplicateRequirements {

    // MARK: - Variables
    var tips: [String: String] = [:]

    // MARK: - Methods
    func updateTips(_ tips: [Tip]) {
        updateTipsCallCount += 1
        if let handler = updateTipsHandler {
            handler(tips)
        }
    }
    var updateTipsCallCount: Int = 0
    var updateTipsHandler: ((_ tips: [Tip]) -> ())? = nil
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
        if let handler = updateTipsWithTipsHandler {
            try handler(tips)
        }
    }
    var updateTipsWithTipsCallCount: Int = 0
    var updateTipsWithTipsHandler: ((_ tips: AnySequence<Tip>) throws -> ())? = nil
}

// MARK: - ErrorPopoverBuildable
class ErrorPopoverBuildableMock<_T1, _T2>: ErrorPopoverBuildable {

    // MARK: - Generic typealiases
    typealias T1 = _T1
    typealias T2 = _T2

    // MARK: - Methods
    func buildDefaultPopoverPresenter<T1>(title: String) -> AnyErrorPopoverPresentable<T1> {
        buildDefaultPopoverPresenterCallCount += 1
        if let handler = buildDefaultPopoverPresenterHandler {
            return handler(title) as! AnyErrorPopoverPresentable<T1>
        }
        fatalError("buildDefaultPopoverPresenterHandler expected to be set.")
    }
    var buildDefaultPopoverPresenterCallCount: Int = 0
    var buildDefaultPopoverPresenterHandler: ((_ title: String) -> (AnyErrorPopoverPresentable<T1>))? = nil
    func buildPopoverPresenter<T2>(title: String, buttons: [(title: String, identifier: T2, handler: ()->())]) -> AnyErrorPopoverPresentable<T2> {
        buildPopoverPresenterCallCount += 1
        if let handler = buildPopoverPresenterHandler {
            return handler(title, buttons as! [(title: String, identifier: _T2, handler: ()->())]) as! AnyErrorPopoverPresentable<T2>
        }
        fatalError("buildPopoverPresenterHandler expected to be set.")
    }
    var buildPopoverPresenterCallCount: Int = 0
    var buildPopoverPresenterHandler: ((_ title: String, _ buttons: [(title: String, identifier: T2, handler: ()->())]) -> (AnyErrorPopoverPresentable<T2>))? = nil
}

// MARK: - ErrorPopoverBuildableRawRepresentable
class ErrorPopoverBuildableRawRepresentableMock<_T>: ErrorPopoverBuildableRawRepresentable where _T: Hashable, _T: RawRepresentable {

    // MARK: - Generic typealiases
    typealias T = _T

    // MARK: - Methods
    func buildPopoverPresenter<T>(title: String, buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T> where T: RawRepresentable, T: Hashable {
        buildPopoverPresenterCallCount += 1
        if let handler = buildPopoverPresenterHandler {
            return handler(title, buttons as! [(title: String, identifier: _T, handler: ()->())]) as! AnyErrorPopoverPresentableRawRepresentable<T>
        }
        fatalError("buildPopoverPresenterHandler expected to be set.")
    }
    var buildPopoverPresenterCallCount: Int = 0
    var buildPopoverPresenterHandler: ((_ title: String, _ buttons: [(title: String, identifier: T, handler: ()->())]) -> (AnyErrorPopoverPresentableRawRepresentable<T>))? = nil
}

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<_EventType>: ErrorPopoverPresentable {

    // MARK: - Generic typealiases
    typealias EventType = _EventType

    // MARK: - Methods
    func setActionSink(_ actionSink: AnyObject?) {
        setActionSinkCallCount += 1
        if let handler = setActionSinkHandler {
            handler(actionSink)
        }
    }
    var setActionSinkCallCount: Int = 0
    var setActionSinkHandler: ((_ actionSink: AnyObject?) -> ())? = nil
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
        if let handler = showHandler {
            return handler(positioningRect, positioningView, preferredEdge)
        }
        return showSubject.asObservable()
    }
    var showCallCount: Int = 0
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> (Observable<EventType>))? = nil
    lazy var showSubject = PublishSubject<EventType>()
}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<_EventType>: ErrorPopoverPresentableRawRepresentable where _EventType: Hashable, _EventType: RawRepresentable {

    // MARK: - Generic typealiases
    typealias EventType = _EventType

    // MARK: - Methods
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
        if let handler = showHandler {
            return handler(positioningRect, positioningView, preferredEdge)
        }
        return showSubject.asObservable()
    }
    var showCallCount: Int = 0
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> (Observable<EventType>))? = nil
    lazy var showSubject = PublishSubject<EventType>()
}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {

    // MARK: - Methods
    func dateTaken(fileUrl: URL) -> Date? {
        dateTakenCallCount += 1
        if let handler = dateTakenHandler {
            return handler(fileUrl)
        }
        return nil
    }
    var dateTakenCallCount: Int = 0
    var dateTakenHandler: ((_ fileUrl: URL) -> (Date?))? = nil
}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {

    // MARK: - Methods
    func imagePixelSize(source: UploadAPI.LocalFile.Source) throws -> CGSize {
        imagePixelSizeCallCount += 1
        if let handler = imagePixelSizeHandler {
            return try handler(source)
        }
        return CGSize.zero
    }
    var imagePixelSizeCallCount: Int = 0
    var imagePixelSizeHandler: ((_ source: UploadAPI.LocalFile.Source) throws -> (CGSize))? = nil
}

// MARK: - Interactable
class InteractableMock: Interactable {
}

// MARK: - LegacyProtocol
class LegacyProtocolMock: NSObject, LegacyProtocol {

    // MARK: - Variables
    var tips: [String: String] = [:]

    // MARK: - Methods
    func compare(_ lhs: CGSize, _ rhs: CGSize) -> ComparisonResult {
        compareCallCount += 1
        if let handler = compareHandler {
            return handler(lhs, rhs)
        }
        fatalError("compareHandler expected to be set.")
    }
    var compareCallCount: Int = 0
    var compareHandler: ((_ lhs: CGSize, _ rhs: CGSize) -> (ComparisonResult))? = nil
}

// MARK: - MutableTipsManaging
class MutableTipsManagingMock: MutableTipsManaging {

    // MARK: - Variables
    var arrayVariable: [Double] = []
    var tips: [String: String] = [:]
    var tipsOptional: [String: String]? = nil
    var tupleOptional: (String, Int)? = nil
    var tupleVariable: (String, Int) = ("", 0)
    var tupleVariable2: (String?, Int?) = (nil, nil)

    // MARK: - Methods
    func updateTips(_ tips: [Tip]) {
        updateTipsCallCount += 1
        if let handler = updateTipsHandler {
            handler(tips)
        }
    }
    var updateTipsCallCount: Int = 0
    var updateTipsHandler: ((_ tips: [Tip]) -> ())? = nil
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
        if let handler = updateTipsWithTipsHandler {
            try handler(tips)
        }
    }
    var updateTipsWithTipsCallCount: Int = 0
    var updateTipsWithTipsHandler: ((_ tips: AnySequence<Tip>) throws -> ())? = nil
}

// MARK: - MutableUploadProgressing
class MutableUploadProgressingMock: MutableUploadProgressing {

    // MARK: - Variables
    var progress: Observable<Result<Double>> {
        progressGetCount += 1
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetCount: Int = 0
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()

    // MARK: - Methods
    func downloadUrlsRetrieved() {
        downloadUrlsRetrievedCallCount += 1
        if let handler = downloadUrlsRetrievedHandler {
            handler()
        }
    }
    var downloadUrlsRetrievedCallCount: Int = 0
    var downloadUrlsRetrievedHandler: (() -> ())? = nil
    func filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress) {
        filePartProgressedCallCount += 1
        if let handler = filePartProgressedHandler {
            handler(uploadId, filePart, progress)
        }
    }
    var filePartProgressedCallCount: Int = 0
    var filePartProgressedHandler: ((_ uploadId: UploadAPI.UploadId, _ filePart: FilePart, _ progress: RxProgress) -> ())? = nil
    func filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart]) {
        filePartsCreatedCallCount += 1
        if let handler = filePartsCreatedHandler {
            handler(uploadId, fileParts)
        }
    }
    var filePartsCreatedCallCount: Int = 0
    var filePartsCreatedHandler: ((_ uploadId: UploadAPI.UploadId, _ fileParts: [FilePart]) -> ())? = nil
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress> {
        fileProgressCallCount += 1
        if let handler = fileProgressHandler {
            return handler(source)
        }
        return fileProgressSubject.asObservable()
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
    lazy var fileProgressSubject = PublishSubject<RxProgress>()
    func setInputFiles(localFiles: [UploadAPI.LocalFile]) {
        setInputFilesCallCount += 1
        if let handler = setInputFilesHandler {
            handler(localFiles)
        }
    }
    var setInputFilesCallCount: Int = 0
    var setInputFilesHandler: ((_ localFiles: [UploadAPI.LocalFile]) -> ())? = nil
    func uploadIdRetrieved(localFile: UploadAPI.LocalFile, uploadId: UploadAPI.UploadId) {
        uploadIdRetrievedCallCount += 1
        if let handler = uploadIdRetrievedHandler {
            handler(localFile, uploadId)
        }
    }
    var uploadIdRetrievedCallCount: Int = 0
    var uploadIdRetrievedHandler: ((_ localFile: UploadAPI.LocalFile, _ uploadId: UploadAPI.UploadId) -> ())? = nil
}

// MARK: - ObjectManupulating
class ObjectManupulatingMock: ObjectManupulating {

    // MARK: - Methods
    func removeObject() -> Int {
        removeObjectCallCount += 1
        if let handler = removeObjectHandler {
            return handler()
        }
        return 0
    }
    var removeObjectCallCount: Int = 0
    var removeObjectHandler: (() -> (Int))? = nil
    func removeObject(_ object: @autoclosure () throws -> Any) rethrows -> Int {
        removeObjectObjectCallCount += 1
        if let handler = removeObjectObjectHandler {
            return try! handler(object)
        }
        return 0
    }
    var removeObjectObjectCallCount: Int = 0
    var removeObjectObjectHandler: ((_ object: @autoclosure () throws -> Any) throws -> (Int))? = nil
    func removeObject(where matchPredicate: @escaping (Any) throws -> (Bool)) rethrows -> Int {
        removeObjectWhereMatchPredicateCallCount += 1
        if let handler = removeObjectWhereMatchPredicateHandler {
            return try! handler(matchPredicate)
        }
        return 0
    }
    var removeObjectWhereMatchPredicateCallCount: Int = 0
    var removeObjectWhereMatchPredicateHandler: ((_ matchPredicate: @escaping (Any) throws -> (Bool)) throws -> (Int))? = nil
}

// MARK: - Routing
class RoutingMock<_InteractorType>: Routing where _InteractorType: Interactable {

    // MARK: - Generic typealiases
    typealias InteractorType = _InteractorType

    // MARK: - Variables
    var interactor: InteractorType
    // MARK: - Initializer
    init(interactor: InteractorType) {
        self.interactor = interactor
    }
}

// MARK: - SomeInteractable
class SomeInteractableMock: SomeInteractable {
}

// MARK: - SomeRouting
class SomeRoutingMock<_InteractorType>: SomeRouting where _InteractorType: SomeInteractable {

    // MARK: - Generic typealiases
    typealias InteractorType = _InteractorType

    // MARK: - Variables
    var interactor: InteractorType
    // MARK: - Initializer
    init(interactor: InteractorType) {
        self.interactor = interactor
    }
}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

    // MARK: - Methods
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> NSImage {
        createThumbImageCallCount += 1
        if let handler = createThumbImageHandler {
            return try handler(pictureUrl, size)
        }
        fatalError("createThumbImageHandler expected to be set.")
    }
    var createThumbImageCallCount: Int = 0
    var createThumbImageHandler: ((_ pictureUrl: URL, _ size: CGSize) throws -> (NSImage))? = nil
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data {
        createThumbJpegDataCallCount += 1
        if let handler = createThumbJpegDataHandler {
            return try handler(pictureUrl, size, compression)
        }
        fatalError("createThumbJpegDataHandler expected to be set.")
    }
    var createThumbJpegDataCallCount: Int = 0
    var createThumbJpegDataHandler: ((_ pictureUrl: URL, _ size: CGSize, _ compression: Double) throws -> (Data))? = nil
}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {

    // MARK: - Methods
    func build() -> TipsManaging & MutableTipsManaging {
        buildCallCount += 1
        if let handler = buildHandler {
            return handler()
        }
        fatalError("buildHandler expected to be set.")
    }
    var buildCallCount: Int = 0
    var buildHandler: (() -> (TipsManaging & MutableTipsManaging))? = nil
}

// MARK: - TipsManaging
class TipsManagingMock: TipsManaging {

    // MARK: - Variables
    var arrayVariable: [Double] = []
    var tips: [String: String] = [:]
    var tipsOptional: [String: String]? = nil
    var tupleOptional: (String, Int)? = nil
    var tupleVariable: (String, Int) = ("", 0)
    var tupleVariable2: (String?, Int?) = (nil, nil)
}

// MARK: - UploadProgressing
class UploadProgressingMock: UploadProgressing {

    // MARK: - Variables
    var progress: Observable<Result<Double>> {
        progressGetCount += 1
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetCount: Int = 0
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()

    // MARK: - Methods
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress> {
        fileProgressCallCount += 1
        if let handler = fileProgressHandler {
            return handler(source)
        }
        return fileProgressSubject.asObservable()
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
    lazy var fileProgressSubject = PublishSubject<RxProgress>()
}
