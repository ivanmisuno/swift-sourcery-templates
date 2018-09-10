// Generated using Sourcery 0.14.0 — https://github.com/krzysztofzablocki/Sourcery
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
    var delegate: AlbumPageSizeProviderDelegate? {
        get {
            return delegateGetHandler?() ?? delegateBacking
        }
        set {
            delegateBacking = newValue
            delegateSetCount += 1
            delegateSetHandler?(newValue)
        }
    }
    var delegateGetHandler: (() -> AlbumPageSizeProviderDelegate?)? = nil
    var delegateSetCount: Int = 0
    var delegateSetHandler: ((_ delegate: AlbumPageSizeProviderDelegate?) -> ())? = nil
    var delegateBacking: AlbumPageSizeProviderDelegate?
    var pageSize: CGSize {
        if let handler = pageSizeGetHandler {
            return handler()
        }
        if let value = pageSizeBacking {
            return value
        }
        return CGSize.zero
    }
    var pageSizeGetHandler: (() -> CGSize)? = nil
    var pageSizeBacking: CGSize?
}

// MARK: - DataSource
class DataSourceMock: DataSource {

    // MARK: - Variables
    var bindingTarget: AnyObserver<UploadAPI.LocalFile> {
        if let handler = bindingTargetGetHandler {
            return handler()
        }
        return AnyObserver { [weak self] event in
            self?.bindingTargetCallCount += 1
            self?.bindingTargetEventHandler?(event)
        }
    }
    var bindingTargetGetHandler: (() -> AnyObserver<UploadAPI.LocalFile>)? = nil
    var bindingTargetCallCount: Int = 0
    var bindingTargetEventHandler: ((Event<UploadAPI.LocalFile>) -> ())? = nil
}

// MARK: - DuplicateRequirements
class DuplicateRequirementsMock: DuplicateRequirements {

    // MARK: - Variables
    var tips: [String: String] {
        if let handler = tipsGetHandler {
            return handler()
        }
        if let value = tipsBacking {
            return value
        }
        return [:]
    }
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?

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

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<TypeEventType>: ErrorPopoverPresentable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType

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
        fatalError("showHandler expected to be set.")
    }
    var showCallCount: Int = 0
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> (Observable<EventType>))? = nil
}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<TypeEventType>: ErrorPopoverPresentableRawRepresentable where TypeEventType: RawRepresentable, TypeEventType: Hashable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType

    // MARK: - Methods
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
        if let handler = showHandler {
            return handler(positioningRect, positioningView, preferredEdge)
        }
        fatalError("showHandler expected to be set.")
    }
    var showCallCount: Int = 0
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> (Observable<EventType>))? = nil
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
        fatalError("imagePixelSizeHandler expected to be set.")
    }
    var imagePixelSizeCallCount: Int = 0
    var imagePixelSizeHandler: ((_ source: UploadAPI.LocalFile.Source) throws -> (CGSize))? = nil
}

// MARK: - LegacyProtocol
class LegacyProtocolMock: NSObject, LegacyProtocol {

    // MARK: - Variables
    var tips: [String: String] {
        if let handler = tipsGetHandler {
            return handler()
        }
        if let value = tipsBacking {
            return value
        }
        return [:]
    }
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?
}

// MARK: - MutableTipsManaging
class MutableTipsManagingMock: MutableTipsManaging {

    // MARK: - Variables
    var tips: [String: String] {
        if let handler = tipsGetHandler {
            return handler()
        }
        if let value = tipsBacking {
            return value
        }
        return [:]
    }
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?
    var tipsOptional: [String: String]? {
        return tipsOptionalGetHandler?() ?? tipsOptionalBacking
    }
    var tipsOptionalGetHandler: (() -> [String: String]?)? = nil
    var tipsOptionalBacking: [String: String]?
    var tupleVariable: (String, Int) {
        if let handler = tupleVariableGetHandler {
            return handler()
        }
        if let value = tupleVariableBacking {
            return value
        }
        return ("", 0)
    }
    var tupleVariableGetHandler: (() -> (String, Int))? = nil
    var tupleVariableBacking: (String, Int)?
    var tupleVariable2: (String?, Int?) {
        if let handler = tupleVariable2GetHandler {
            return handler()
        }
        if let value = tupleVariable2Backing {
            return value
        }
        return (nil, nil)
    }
    var tupleVariable2GetHandler: (() -> (String?, Int?))? = nil
    var tupleVariable2Backing: (String?, Int?)?
    var tupleOptional: (String, Int)? {
        return tupleOptionalGetHandler?() ?? tupleOptionalBacking
    }
    var tupleOptionalGetHandler: (() -> (String, Int)?)? = nil
    var tupleOptionalBacking: (String, Int)?
    var arrayVariable: [Double] {
        if let handler = arrayVariableGetHandler {
            return handler()
        }
        if let value = arrayVariableBacking {
            return value
        }
        return []
    }
    var arrayVariableGetHandler: (() -> [Double])? = nil
    var arrayVariableBacking: [Double]?

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
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()

    // MARK: - Methods
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress> {
        fileProgressCallCount += 1
        if let handler = fileProgressHandler {
            return handler(source)
        }
        fatalError("fileProgressHandler expected to be set.")
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
    func filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress) {
        filePartProgressedCallCount += 1
        if let handler = filePartProgressedHandler {
            handler(uploadId, filePart, progress)
        }
    }
    var filePartProgressedCallCount: Int = 0
    var filePartProgressedHandler: ((_ uploadId: UploadAPI.UploadId, _ filePart: FilePart, _ progress: RxProgress) -> ())? = nil
    func downloadUrlsRetrieved() {
        downloadUrlsRetrievedCallCount += 1
        if let handler = downloadUrlsRetrievedHandler {
            handler()
        }
    }
    var downloadUrlsRetrievedCallCount: Int = 0
    var downloadUrlsRetrievedHandler: (() -> ())? = nil
    func filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart]) {
        filePartsCreatedCallCount += 1
        if let handler = filePartsCreatedHandler {
            handler(uploadId, fileParts)
        }
    }
    var filePartsCreatedCallCount: Int = 0
    var filePartsCreatedHandler: ((_ uploadId: UploadAPI.UploadId, _ fileParts: [FilePart]) -> ())? = nil
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

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

    // MARK: - Methods
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data {
        createThumbJpegDataCallCount += 1
        if let handler = createThumbJpegDataHandler {
            return try handler(pictureUrl, size, compression)
        }
        fatalError("createThumbJpegDataHandler expected to be set.")
    }
    var createThumbJpegDataCallCount: Int = 0
    var createThumbJpegDataHandler: ((_ pictureUrl: URL, _ size: CGSize, _ compression: Double) throws -> (Data))? = nil
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> NSImage {
        createThumbImageCallCount += 1
        if let handler = createThumbImageHandler {
            return try handler(pictureUrl, size)
        }
        fatalError("createThumbImageHandler expected to be set.")
    }
    var createThumbImageCallCount: Int = 0
    var createThumbImageHandler: ((_ pictureUrl: URL, _ size: CGSize) throws -> (NSImage))? = nil
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
    var tips: [String: String] {
        if let handler = tipsGetHandler {
            return handler()
        }
        if let value = tipsBacking {
            return value
        }
        return [:]
    }
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?
    var tipsOptional: [String: String]? {
        return tipsOptionalGetHandler?() ?? tipsOptionalBacking
    }
    var tipsOptionalGetHandler: (() -> [String: String]?)? = nil
    var tipsOptionalBacking: [String: String]?
    var tupleVariable: (String, Int) {
        if let handler = tupleVariableGetHandler {
            return handler()
        }
        if let value = tupleVariableBacking {
            return value
        }
        return ("", 0)
    }
    var tupleVariableGetHandler: (() -> (String, Int))? = nil
    var tupleVariableBacking: (String, Int)?
    var tupleVariable2: (String?, Int?) {
        if let handler = tupleVariable2GetHandler {
            return handler()
        }
        if let value = tupleVariable2Backing {
            return value
        }
        return (nil, nil)
    }
    var tupleVariable2GetHandler: (() -> (String?, Int?))? = nil
    var tupleVariable2Backing: (String?, Int?)?
    var tupleOptional: (String, Int)? {
        return tupleOptionalGetHandler?() ?? tupleOptionalBacking
    }
    var tupleOptionalGetHandler: (() -> (String, Int)?)? = nil
    var tupleOptionalBacking: (String, Int)?
    var arrayVariable: [Double] {
        if let handler = arrayVariableGetHandler {
            return handler()
        }
        if let value = arrayVariableBacking {
            return value
        }
        return []
    }
    var arrayVariableGetHandler: (() -> [Double])? = nil
    var arrayVariableBacking: [Double]?
}

// MARK: - UploadProgressing
class UploadProgressingMock: UploadProgressing {

    // MARK: - Variables
    var progress: Observable<Result<Double>> {
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()

    // MARK: - Methods
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress> {
        fileProgressCallCount += 1
        if let handler = fileProgressHandler {
            return handler(source)
        }
        fatalError("fileProgressHandler expected to be set.")
    }
    var fileProgressCallCount: Int = 0
    var fileProgressHandler: ((_ source: UploadAPI.LocalFile.Source) -> (Observable<RxProgress>))? = nil
}
