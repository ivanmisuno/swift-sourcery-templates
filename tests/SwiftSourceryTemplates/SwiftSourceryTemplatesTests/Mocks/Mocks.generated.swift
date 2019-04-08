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

    // MARK: - Variables
    var onComplete: AnyObserver<()> {
        onCompleteGetCount += 1
        if let handler = onCompleteGetHandler {
            return handler()
        }
        return AnyObserver { [weak self] event in
            self?.onCompleteEventCallCount += 1
            self?.onCompleteEventHandler?(event)
        }
    }
    var onCompleteGetCount: Int = 0
    var onCompleteGetHandler: (() -> AnyObserver<()>)? = nil
    var onCompleteEventCallCount: Int = 0
    var onCompleteEventHandler: ((Event<()>) -> ())? = nil
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

// MARK: - AppKitEvent
class AppKitEventMock: AppKitEvent {

    // MARK: - Variables
    let locationInWindow: NSPoint
    let modifierFlags: NSEvent.ModifierFlags

    // MARK: - Initializer
    init(locationInWindow: NSPoint = CGPoint.zero, modifierFlags: NSEvent.ModifierFlags) {
        self.locationInWindow = locationInWindow
        self.modifierFlags = modifierFlags
    }
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

    // MARK: - Methods
    func bindStreams() -> Disposable {
        bindStreamsCallCount += 1
        if let __bindStreamsHandler = self.bindStreamsHandler {
            return __bindStreamsHandler()
        }
        return Disposables.create { [weak self] in
            self?.bindStreamsDisposeCallCount += 1
            self?.bindStreamsDisposeHandler?()
        }
    }
    var bindStreamsCallCount: Int = 0
    var bindStreamsHandler: (() -> (Disposable))? = nil
    var bindStreamsDisposeCallCount: Int = 0
    var bindStreamsDisposeHandler: (() -> ())? = nil
}

// MARK: - DuplicateGenericTypeNames
class DuplicateGenericTypeNamesMock<_T>: DuplicateGenericTypeNames {

    // MARK: - Generic typealiases
    typealias T = _T

    // MARK: - Methods
    func action<T>(_ a: T) {
        actionCallCount += 1
        if let __actionHandler = self.actionHandler {
            __actionHandler(a as! _T)
        }
    }
    var actionCallCount: Int = 0
    var actionHandler: ((_ a: T) -> ())? = nil
    func action2<T>(_ a: T) {
        action2CallCount += 1
        if let __action2Handler = self.action2Handler {
            __action2Handler(a as! _T)
        }
    }
    var action2CallCount: Int = 0
    var action2Handler: ((_ a: T) -> ())? = nil
}

// MARK: - DuplicateRequirements
class DuplicateRequirementsMock: DuplicateRequirements {

    // MARK: - Variables
    var tips: [String: String] = [:]

    // MARK: - Methods
    func updateTips(_ tips: [Tip]) {
        updateTipsCallCount += 1
        if let __updateTipsHandler = self.updateTipsHandler {
            __updateTipsHandler(tips)
        }
    }
    var updateTipsCallCount: Int = 0
    var updateTipsHandler: ((_ tips: [Tip]) -> ())? = nil
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
        if let __updateTipsWithTipsHandler = self.updateTipsWithTipsHandler {
            try __updateTipsWithTipsHandler(tips)
        }
    }
    var updateTipsWithTipsCallCount: Int = 0
    var updateTipsWithTipsHandler: ((_ tips: AnySequence<Tip>) throws -> ())? = nil
}

// MARK: - DuplicateRequirementsSameLevel
class DuplicateRequirementsSameLevelMock: DuplicateRequirementsSameLevel {

    // MARK: - Methods
    func update(cropHandles: [CGPoint]) {
        updateCropHandlesCallCount += 1
        if let __updateCropHandlesHandler = self.updateCropHandlesHandler {
            __updateCropHandlesHandler(cropHandles)
        }
    }
    var updateCropHandlesCallCount: Int = 0
    var updateCropHandlesHandler: ((_ cropHandles: [CGPoint]) -> ())? = nil
    func update(cropRect: CGRect) {
        updateCropRectCallCount += 1
        if let __updateCropRectHandler = self.updateCropRectHandler {
            __updateCropRectHandler(cropRect)
        }
    }
    var updateCropRectCallCount: Int = 0
    var updateCropRectHandler: ((_ cropRect: CGRect) -> ())? = nil
    func update(effects: [String]) {
        updateEffectsCallCount += 1
        if let __updateEffectsHandler = self.updateEffectsHandler {
            __updateEffectsHandler(effects)
        }
    }
    var updateEffectsCallCount: Int = 0
    var updateEffectsHandler: ((_ effects: [String]) -> ())? = nil
}

// MARK: - ErrorPopoverBuildable
class ErrorPopoverBuildableMock<_T1, _T2>: ErrorPopoverBuildable {

    // MARK: - Generic typealiases
    typealias T1 = _T1
    typealias T2 = _T2

    // MARK: - Methods
    func buildDefaultPopoverPresenter<T1>(title: String) -> AnyErrorPopoverPresentable<T1> {
        buildDefaultPopoverPresenterCallCount += 1
        if let __buildDefaultPopoverPresenterHandler = self.buildDefaultPopoverPresenterHandler {
            return __buildDefaultPopoverPresenterHandler(title) as! AnyErrorPopoverPresentable<T1>
        }
        fatalError("buildDefaultPopoverPresenterHandler expected to be set.")
    }
    var buildDefaultPopoverPresenterCallCount: Int = 0
    var buildDefaultPopoverPresenterHandler: ((_ title: String) -> (AnyErrorPopoverPresentable<T1>))? = nil
    func buildPopoverPresenter<T2>(title: String, buttons: [(title: String, identifier: T2, handler: ()->())]) -> AnyErrorPopoverPresentable<T2> {
        buildPopoverPresenterCallCount += 1
        if let __buildPopoverPresenterHandler = self.buildPopoverPresenterHandler {
            return __buildPopoverPresenterHandler(title, buttons as! [(title: String, identifier: _T2, handler: ()->())]) as! AnyErrorPopoverPresentable<T2>
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
        if let __buildPopoverPresenterHandler = self.buildPopoverPresenterHandler {
            return __buildPopoverPresenterHandler(title, buttons as! [(title: String, identifier: _T, handler: ()->())]) as! AnyErrorPopoverPresentableRawRepresentable<T>
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
        if let __setActionSinkHandler = self.setActionSinkHandler {
            __setActionSinkHandler(actionSink)
        }
    }
    var setActionSinkCallCount: Int = 0
    var setActionSinkHandler: ((_ actionSink: AnyObject?) -> ())? = nil
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
        if let __showHandler = self.showHandler {
            return __showHandler(positioningRect, positioningView, preferredEdge)
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
        if let __showHandler = self.showHandler {
            return __showHandler(positioningRect, positioningView, preferredEdge)
        }
        return showSubject.asObservable()
    }
    var showCallCount: Int = 0
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> (Observable<EventType>))? = nil
    lazy var showSubject = PublishSubject<EventType>()
}

// MARK: - ErrorPresenting
class ErrorPresentingMock<_T>: ErrorPresenting where _T: Hashable, _T: RawRepresentable {

    // MARK: - Generic typealiases
    typealias T = _T

    // MARK: - Methods
    func presentErrorPopover<T>(_ popoverPresenter: AnyErrorPopoverPresentable<T>) -> Observable<T> where T: RawRepresentable, T: Hashable {
        presentErrorPopoverCallCount += 1
        if let __presentErrorPopoverHandler = self.presentErrorPopoverHandler {
            return __presentErrorPopoverHandler(popoverPresenter as! AnyErrorPopoverPresentable<_T>) as! Observable<T>
        }
        return presentErrorPopoverSubject.asObservable() as! Observable<T>
    }
    var presentErrorPopoverCallCount: Int = 0
    var presentErrorPopoverHandler: ((_ popoverPresenter: AnyErrorPopoverPresentable<T>) -> (Observable<T>))? = nil
    lazy var presentErrorPopoverSubject = PublishSubject<T>()
}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {

    // MARK: - Methods
    func dateTaken(fileUrl: URL) -> Date? {
        dateTakenCallCount += 1
        if let __dateTakenHandler = self.dateTakenHandler {
            return __dateTakenHandler(fileUrl)
        }
        return nil
    }
    var dateTakenCallCount: Int = 0
    var dateTakenHandler: ((_ fileUrl: URL) -> (Date?))? = nil
}

// MARK: - FileService
class FileServiceMock: FileService {

    // MARK: - Methods
    func upload(fileUrl: URL) -> Single<[FilePart]> {
        uploadCallCount += 1
        if let __uploadHandler = self.uploadHandler {
            return __uploadHandler(fileUrl)
        }
        return Single.create { (observer: @escaping (SingleEvent<[FilePart]>) -> ()) -> Disposable in
            return self.uploadSubject.subscribe { (event: Event<[FilePart]>) in
                switch event {
                case .next(let element):
                    observer(.success(element))
                case .error(let error):
                    observer(.error(error))
                default:
                    break
                }
            }
        }
    }
    var uploadCallCount: Int = 0
    var uploadHandler: ((_ fileUrl: URL) -> (Single<[FilePart]>))? = nil
    lazy var uploadSubject = PublishSubject<[FilePart]>()
}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {

    // MARK: - Methods
    func imagePixelSize(source: UploadAPI.LocalFile.Source) throws -> CGSize {
        imagePixelSizeCallCount += 1
        if let __imagePixelSizeHandler = self.imagePixelSizeHandler {
            return try __imagePixelSizeHandler(source)
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
        if let __compareHandler = self.compareHandler {
            return __compareHandler(lhs, rhs)
        }
        fatalError("compareHandler expected to be set.")
    }
    var compareCallCount: Int = 0
    var compareHandler: ((_ lhs: CGSize, _ rhs: CGSize) -> (ComparisonResult))? = nil
}

// MARK: - MutableTipsAccessing
class MutableTipsAccessingMock: MutableTipsAccessing {

    // MARK: - Variables
    var tip: Tip {
        get {
            tipGetCount += 1
            if let handler = tipGetHandler {
                return handler()
            }
            fatalError("`tipGetHandler` must be set!")
        }
        set {
            tipSetCount += 1
        }
    }
    var tipGetCount: Int = 0
    var tipGetHandler: (() -> Tip)? = nil
    var tipSetCount: Int = 0
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
        if let __updateTipsHandler = self.updateTipsHandler {
            __updateTipsHandler(tips)
        }
    }
    var updateTipsCallCount: Int = 0
    var updateTipsHandler: ((_ tips: [Tip]) -> ())? = nil
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
        if let __updateTipsWithTipsHandler = self.updateTipsWithTipsHandler {
            try __updateTipsWithTipsHandler(tips)
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
        if let __downloadUrlsRetrievedHandler = self.downloadUrlsRetrievedHandler {
            __downloadUrlsRetrievedHandler()
        }
    }
    var downloadUrlsRetrievedCallCount: Int = 0
    var downloadUrlsRetrievedHandler: (() -> ())? = nil
    func filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress) {
        filePartProgressedCallCount += 1
        if let __filePartProgressedHandler = self.filePartProgressedHandler {
            __filePartProgressedHandler(uploadId, filePart, progress)
        }
    }
    var filePartProgressedCallCount: Int = 0
    var filePartProgressedHandler: ((_ uploadId: UploadAPI.UploadId, _ filePart: FilePart, _ progress: RxProgress) -> ())? = nil
    func filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart]) {
        filePartsCreatedCallCount += 1
        if let __filePartsCreatedHandler = self.filePartsCreatedHandler {
            __filePartsCreatedHandler(uploadId, fileParts)
        }
    }
    var filePartsCreatedCallCount: Int = 0
    var filePartsCreatedHandler: ((_ uploadId: UploadAPI.UploadId, _ fileParts: [FilePart]) -> ())? = nil
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress> {
        fileProgressCallCount += 1
        if let __fileProgressHandler = self.fileProgressHandler {
            return __fileProgressHandler(source)
        }
        return fileProgressSubject.asObservable()
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
    lazy var fileProgressSubject = PublishSubject<RxProgress>()
    func setInputFiles(localFiles: [UploadAPI.LocalFile]) {
        setInputFilesCallCount += 1
        if let __setInputFilesHandler = self.setInputFilesHandler {
            __setInputFilesHandler(localFiles)
        }
    }
    var setInputFilesCallCount: Int = 0
    var setInputFilesHandler: ((_ localFiles: [UploadAPI.LocalFile]) -> ())? = nil
    func uploadIdRetrieved(localFile: UploadAPI.LocalFile, uploadId: UploadAPI.UploadId) {
        uploadIdRetrievedCallCount += 1
        if let __uploadIdRetrievedHandler = self.uploadIdRetrievedHandler {
            __uploadIdRetrievedHandler(localFile, uploadId)
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
        if let __removeObjectHandler = self.removeObjectHandler {
            return __removeObjectHandler()
        }
        return 0
    }
    var removeObjectCallCount: Int = 0
    var removeObjectHandler: (() -> (Int))? = nil
    func removeObject(_ object: @autoclosure () throws -> Any) rethrows -> Int {
        removeObjectObjectCallCount += 1
        if let __removeObjectObjectHandler = self.removeObjectObjectHandler {
            return try! __removeObjectObjectHandler(object)
        }
        return 0
    }
    var removeObjectObjectCallCount: Int = 0
    var removeObjectObjectHandler: ((_ object: @autoclosure () throws -> Any) throws -> (Int))? = nil
    func removeObject(where matchPredicate: @escaping (Any) throws -> (Bool)) rethrows -> Int {
        removeObjectWhereMatchPredicateCallCount += 1
        if let __removeObjectWhereMatchPredicateHandler = self.removeObjectWhereMatchPredicateHandler {
            return try! __removeObjectWhereMatchPredicateHandler(matchPredicate)
        }
        return 0
    }
    var removeObjectWhereMatchPredicateCallCount: Int = 0
    var removeObjectWhereMatchPredicateHandler: ((_ matchPredicate: @escaping (Any) throws -> (Bool)) throws -> (Int))? = nil
}

// MARK: - ProtocolWithCollections
class ProtocolWithCollectionsMock: ProtocolWithCollections {

    // MARK: - Variables
    var data: Array<String> = []
    var items: Set<String> = Set()
    var mapping: Dictionary<String, Int> = [:]

    // MARK: - Methods
    func getData() -> Array<String> {
        getDataCallCount += 1
        if let __getDataHandler = self.getDataHandler {
            return __getDataHandler()
        }
        return []
    }
    var getDataCallCount: Int = 0
    var getDataHandler: (() -> (Array<String>))? = nil
    func getItems() -> Set<String> {
        getItemsCallCount += 1
        if let __getItemsHandler = self.getItemsHandler {
            return __getItemsHandler()
        }
        return Set()
    }
    var getItemsCallCount: Int = 0
    var getItemsHandler: (() -> (Set<String>))? = nil
    func getMapping() -> Dictionary<String, Int> {
        getMappingCallCount += 1
        if let __getMappingHandler = self.getMappingHandler {
            return __getMappingHandler()
        }
        return [:]
    }
    var getMappingCallCount: Int = 0
    var getMappingHandler: (() -> (Dictionary<String, Int>))? = nil
}

// MARK: - ProtocolWithExtensions
class ProtocolWithExtensionsMock: ProtocolWithExtensions {

    // MARK: - Variables
    var protocolRequirement: Int = 0

    // MARK: - Methods
    func requiredInProtocol() {
        requiredInProtocolCallCount += 1
        if let __requiredInProtocolHandler = self.requiredInProtocolHandler {
            __requiredInProtocolHandler()
        }
    }
    var requiredInProtocolCallCount: Int = 0
    var requiredInProtocolHandler: (() -> ())? = nil
}

// MARK: - RealmInterop
class RealmInteropMock<_Element, _KeyType, _S>: RealmInterop where _Element: Object, _S.Iterator.Element: Object, _S: Sequence {

    // MARK: - Generic typealiases
    typealias Element = _Element
    typealias KeyType = _KeyType
    typealias S = _S

    // MARK: - Variables
    var autorefresh: Bool = false {
        didSet {
            autorefreshSetCount += 1
        }
    }
    var autorefreshSetCount: Int = 0
    var isInWriteTransaction: Bool = false

    // MARK: - Methods
    func add(_ object: Object, update: Bool) {
        addObjectCallCount += 1
        if let __addObjectHandler = self.addObjectHandler {
            __addObjectHandler(object, update)
        }
    }
    var addObjectCallCount: Int = 0
    var addObjectHandler: ((_ object: Object, _ update: Bool) -> ())? = nil
    func add<S>(_ objects: S, update: Bool) {
        addObjectsCallCount += 1
        if let __addObjectsHandler = self.addObjectsHandler {
            __addObjectsHandler(objects as! _S, update)
        }
    }
    var addObjectsCallCount: Int = 0
    var addObjectsHandler: ((_ objects: S, _ update: Bool) -> ())? = nil
    func beginWrite() {
        beginWriteCallCount += 1
        if let __beginWriteHandler = self.beginWriteHandler {
            __beginWriteHandler()
        }
    }
    var beginWriteCallCount: Int = 0
    var beginWriteHandler: (() -> ())? = nil
    func cancelWrite() {
        cancelWriteCallCount += 1
        if let __cancelWriteHandler = self.cancelWriteHandler {
            __cancelWriteHandler()
        }
    }
    var cancelWriteCallCount: Int = 0
    var cancelWriteHandler: (() -> ())? = nil
    func commitWrite(withoutNotifying tokens: [NotificationToken]) throws {
        commitWriteCallCount += 1
        if let __commitWriteHandler = self.commitWriteHandler {
            try __commitWriteHandler(tokens)
        }
    }
    var commitWriteCallCount: Int = 0
    var commitWriteHandler: ((_ tokens: [NotificationToken]) throws -> ())? = nil
    func create<Element>(_ type: Element.Type, value: Any, update: Bool) -> Element where Element: Object {
        createCallCount += 1
        if let __createHandler = self.createHandler {
            return __createHandler(type as! _Element.Type, value, update) as! Element
        }
        fatalError("createHandler expected to be set.")
    }
    var createCallCount: Int = 0
    var createHandler: ((_ type: Element.Type, _ value: Any, _ update: Bool) -> (Element))? = nil
    func deleteAll() {
        deleteAllCallCount += 1
        if let __deleteAllHandler = self.deleteAllHandler {
            __deleteAllHandler()
        }
    }
    var deleteAllCallCount: Int = 0
    var deleteAllHandler: (() -> ())? = nil
    func delete<Element>(_ objects: List<Element>) {
        deleteListCallCount += 1
        if let __deleteListHandler = self.deleteListHandler {
            __deleteListHandler(objects as! List<_Element>)
        }
    }
    var deleteListCallCount: Int = 0
    var deleteListHandler: ((_ objects: List<Element>) -> ())? = nil
    func delete(_ object: Object) {
        deleteObjectCallCount += 1
        if let __deleteObjectHandler = self.deleteObjectHandler {
            __deleteObjectHandler(object)
        }
    }
    var deleteObjectCallCount: Int = 0
    var deleteObjectHandler: ((_ object: Object) -> ())? = nil
    func delete<S>(_ objects: S) {
        deleteObjectsCallCount += 1
        if let __deleteObjectsHandler = self.deleteObjectsHandler {
            __deleteObjectsHandler(objects as! _S)
        }
    }
    var deleteObjectsCallCount: Int = 0
    var deleteObjectsHandler: ((_ objects: S) -> ())? = nil
    func delete<Element>(_ objects: Results<Element>) {
        deleteResultsCallCount += 1
        if let __deleteResultsHandler = self.deleteResultsHandler {
            __deleteResultsHandler(objects as! Results<_Element>)
        }
    }
    var deleteResultsCallCount: Int = 0
    var deleteResultsHandler: ((_ objects: Results<Element>) -> ())? = nil
    func invalidate() {
        invalidateCallCount += 1
        if let __invalidateHandler = self.invalidateHandler {
            __invalidateHandler()
        }
    }
    var invalidateCallCount: Int = 0
    var invalidateHandler: (() -> ())? = nil
    func object<Element, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? where Element: Object {
        objectCallCount += 1
        if let __objectHandler = self.objectHandler {
            return __objectHandler(type as! _Element.Type, key as! _KeyType) as! Element?
        }
        return nil
    }
    var objectCallCount: Int = 0
    var objectHandler: ((_ type: Element.Type, _ key: KeyType) -> (Element?))? = nil
    func objects<Element>(_ type: Element.Type) -> Results<Element> where Element: Object {
        objectsCallCount += 1
        if let __objectsHandler = self.objectsHandler {
            return __objectsHandler(type as! _Element.Type) as! Results<Element>
        }
        fatalError("objectsHandler expected to be set.")
    }
    var objectsCallCount: Int = 0
    var objectsHandler: ((_ type: Element.Type) -> (Results<Element>))? = nil
    func observe(_ block: @escaping RealmNotificationInteropBlock) -> NotificationToken {
        observeCallCount += 1
        if let __observeHandler = self.observeHandler {
            return __observeHandler(block)
        }
        fatalError("observeHandler expected to be set.")
    }
    var observeCallCount: Int = 0
    var observeHandler: ((_ block: @escaping RealmNotificationInteropBlock) -> (NotificationToken))? = nil
    func refresh() -> Bool {
        refreshCallCount += 1
        if let __refreshHandler = self.refreshHandler {
            return __refreshHandler()
        }
        return false
    }
    var refreshCallCount: Int = 0
    var refreshHandler: (() -> (Bool))? = nil
    func write(_ block: (() throws -> Void)) throws {
        writeCallCount += 1
        if let __writeHandler = self.writeHandler {
            try __writeHandler(block)
        }
    }
    var writeCallCount: Int = 0
    var writeHandler: ((_ block: (() throws -> Void)) throws -> ())? = nil
    func writeCopy(toFile fileURL: URL, encryptionKey: Data?) throws {
        writeCopyCallCount += 1
        if let __writeCopyHandler = self.writeCopyHandler {
            try __writeCopyHandler(fileURL, encryptionKey)
        }
    }
    var writeCopyCallCount: Int = 0
    var writeCopyHandler: ((_ fileURL: URL, _ encryptionKey: Data?) throws -> ())? = nil
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

// MARK: - ThrowingGenericBuildable
class ThrowingGenericBuildableMock<_EventType>: ThrowingGenericBuildable {

    // MARK: - Generic typealiases
    typealias EventType = _EventType

    // MARK: - Methods
    func build() throws -> AnyErrorPopoverPresentable<EventType> {
        buildCallCount += 1
        if let __buildHandler = self.buildHandler {
            return try __buildHandler()
        }
        fatalError("buildHandler expected to be set.")
    }
    var buildCallCount: Int = 0
    var buildHandler: (() throws -> (AnyErrorPopoverPresentable<EventType>))? = nil
}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

    // MARK: - Methods
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> NSImage {
        createThumbImageCallCount += 1
        if let __createThumbImageHandler = self.createThumbImageHandler {
            return try __createThumbImageHandler(pictureUrl, size)
        }
        fatalError("createThumbImageHandler expected to be set.")
    }
    var createThumbImageCallCount: Int = 0
    var createThumbImageHandler: ((_ pictureUrl: URL, _ size: CGSize) throws -> (NSImage))? = nil
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data {
        createThumbJpegDataCallCount += 1
        if let __createThumbJpegDataHandler = self.createThumbJpegDataHandler {
            return try __createThumbJpegDataHandler(pictureUrl, size, compression)
        }
        fatalError("createThumbJpegDataHandler expected to be set.")
    }
    var createThumbJpegDataCallCount: Int = 0
    var createThumbJpegDataHandler: ((_ pictureUrl: URL, _ size: CGSize, _ compression: Double) throws -> (Data))? = nil
}

// MARK: - TipsAccessing
class TipsAccessingMock: TipsAccessing {

    // MARK: - Variables
    var tip: Tip {
        tipGetCount += 1
        if let handler = tipGetHandler {
            return handler()
        }
        fatalError("`tipGetHandler` must be set!")
    }
    var tipGetCount: Int = 0
    var tipGetHandler: (() -> Tip)? = nil
}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {

    // MARK: - Methods
    func build() -> TipsManaging & MutableTipsManaging {
        buildCallCount += 1
        if let __buildHandler = self.buildHandler {
            return __buildHandler()
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
        if let __fileProgressHandler = self.fileProgressHandler {
            return __fileProgressHandler(source)
        }
        return fileProgressSubject.asObservable()
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
    lazy var fileProgressSubject = PublishSubject<RxProgress>()
}
