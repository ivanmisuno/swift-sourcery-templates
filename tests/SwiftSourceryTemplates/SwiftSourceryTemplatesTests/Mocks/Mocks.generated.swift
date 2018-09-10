// Generated using Sourcery 0.14.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//swiftlint:disable force_cast
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

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
    var bindingTargetEventHandler = ((Event<UploadAPI.LocalFile>) -> ())? = nil
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
    }
    var updateTipsCallCount: Int = 0
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
    }
    var updateTipsWithTipsCallCount: Int = 0
}

// MARK: - ErrorPopoverBuildable
class ErrorPopoverBuildableMock: ErrorPopoverBuildable {

    // MARK: - Methods
    func buildPopoverPresenter<T>(title: String, buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentable<T> {
        buildPopoverPresenterCallCount += 1
    }
    var buildPopoverPresenterCallCount: Int = 0
}

// MARK: - ErrorPopoverBuildableRawRepresentable
class ErrorPopoverBuildableRawRepresentableMock: ErrorPopoverBuildableRawRepresentable {

    // MARK: - Methods
    func buildPopoverPresenter<T: RawRepresentable>(title: String, buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T> {
        buildPopoverPresenterCallCount += 1
    }
    var buildPopoverPresenterCallCount: Int = 0
}

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<TypeEventType>: ErrorPopoverPresentable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType

    // MARK: - Methods
    func setActionSink(_ actionSink: AnyObject?) {
        setActionSinkCallCount += 1
    }
    var setActionSinkCallCount: Int = 0
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
    }
    var showCallCount: Int = 0
}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<TypeEventType>: ErrorPopoverPresentableRawRepresentable where TypeEventType: RawRepresentable, TypeEventType: Hashable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType

    // MARK: - Methods
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        showCallCount += 1
    }
    var showCallCount: Int = 0
}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {

    // MARK: - Methods
    func dateTaken(fileUrl: URL) -> Date? {
        dateTakenCallCount += 1
    }
    var dateTakenCallCount: Int = 0
}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {

    // MARK: - Methods
    func imagePixelSize(source: UploadAPI.LocalFile.Source) throws -> CGSize {
        imagePixelSizeCallCount += 1
    }
    var imagePixelSizeCallCount: Int = 0
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
    }
    var updateTipsCallCount: Int = 0
    func updateTips(with tips: AnySequence<Tip>) throws {
        updateTipsWithTipsCallCount += 1
    }
    var updateTipsWithTipsCallCount: Int = 0
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
    }
    var fileProgressCallCount: Int = 0
    func filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress) {
        filePartProgressedCallCount += 1
    }
    var filePartProgressedCallCount: Int = 0
    func downloadUrlsRetrieved() {
        downloadUrlsRetrievedCallCount += 1
    }
    var downloadUrlsRetrievedCallCount: Int = 0
    func filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart]) {
        filePartsCreatedCallCount += 1
    }
    var filePartsCreatedCallCount: Int = 0
    func setInputFiles(localFiles: [UploadAPI.LocalFile]) {
        setInputFilesCallCount += 1
    }
    var setInputFilesCallCount: Int = 0
    func uploadIdRetrieved(localFile: UploadAPI.LocalFile, uploadId: UploadAPI.UploadId) {
        uploadIdRetrievedCallCount += 1
    }
    var uploadIdRetrievedCallCount: Int = 0
}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

    // MARK: - Methods
    func createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double) throws -> Data {
        createThumbJpegDataCallCount += 1
    }
    var createThumbJpegDataCallCount: Int = 0
    func createThumbImage(for pictureUrl: URL, fitting size: CGSize) throws -> NSImage {
        createThumbImageCallCount += 1
    }
    var createThumbImageCallCount: Int = 0
}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {

    // MARK: - Methods
    func build() -> TipsManaging & MutableTipsManaging {
        buildCallCount += 1
    }
    var buildCallCount: Int = 0
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
    }
    var fileProgressCallCount: Int = 0
}
