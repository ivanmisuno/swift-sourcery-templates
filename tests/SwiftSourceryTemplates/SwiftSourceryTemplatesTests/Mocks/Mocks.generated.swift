// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
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
        get {
            if let handler = pageSizeGetHandler {
                return handler()
            }
            if let value = pageSizeBacking {
                return value
            }
            return CGSize.zero
        }
    }    
    var pageSizeGetHandler: (() -> CGSize)? = nil
    var pageSizeBacking: CGSize?

}

// MARK: - DataSource
class DataSourceMock: DataSource {

    var bindingTarget: AnyObserver<UploadAPI.LocalFile> {
        get {
            if let handler = bindingTargetGetHandler {
                return handler()
            }
            return AnyObserver { [weak self] event in
                self?.bindingTargetCallCount += 1
                self?.bindingTargetEventHandler?(event)
            }
        }
    }    
    var bindingTargetGetHandler: (() -> AnyObserver<UploadAPI.LocalFile>)? = nil
    var bindingTargetCallCount: Int = 0
    var bindingTargetEventHandler = ((Event<UploadAPI.LocalFile>) -> ())? = nil

}

// MARK: - ErrorPopoverBuildable
class ErrorPopoverBuildableMock: ErrorPopoverBuildable {

    // MARK: - buildPopoverPresenter<T>(title: String, buttons: [(title: String, identifier: T, handler: ()->())])
    var buildPopoverPresenterHandler: ((_ title: String, _ buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentable<T>)? = nil
}

// MARK: - ErrorPopoverBuildableRawRepresentable
class ErrorPopoverBuildableRawRepresentableMock: ErrorPopoverBuildableRawRepresentable {

    // MARK: - buildPopoverPresenter<T: RawRepresentable>(title: String, buttons: [(title: String, identifier: T, handler: ()->())])
    var buildPopoverPresenterHandler: ((_ title: String, _ buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T>)? = nil
}

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<TypeEventType>: ErrorPopoverPresentable {

    typealias EventType = TypeEventType


    // MARK: - show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge)
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> Observable<EventType>)? = nil
}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<TypeEventType>: ErrorPopoverPresentableRawRepresentable where TypeEventType: RawRepresentable, TypeEventType: Hashable {

    typealias EventType = TypeEventType


    // MARK: - show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge)
    var showHandler: ((_ positioningRect: NSRect, _ positioningView: NSView, _ preferredEdge: NSRectEdge) -> Observable<EventType>)? = nil
}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {

    // MARK: - dateTaken(fileUrl: URL)
    var dateTakenHandler: ((_ fileUrl: URL) -> Date?)? = nil
}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {

    // MARK: - imagePixelSize(source: UploadAPI.LocalFile.Source)
    var imagePixelSizeHandler: ((_ source: UploadAPI.LocalFile.Source) throws -> CGSize)? = nil
}

// MARK: - LegacyProtocol
class LegacyProtocolMock: NSObject, LegacyProtocol {

    var tips: [String: String] {
        get {
            if let handler = tipsGetHandler {
                return handler()
            }
            if let value = tipsBacking {
                return value
            }
            return [:]
        }
    }    
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?

}

// MARK: - MutableTipsManaging
class MutableTipsManagingMock: MutableTipsManaging {
}

// MARK: - MutableUploadProgressing
class MutableUploadProgressingMock: MutableUploadProgressing {

    var progress: Observable<Result<Double>> {
        get {
            if let handler = progressGetHandler {
                return handler()
            }
            return progressSubject.asObservable()
        }
    }    
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()


    // MARK: - setInputFiles(localFiles: [UploadAPI.LocalFile])
    var setInputFilesHandler: ((_ localFiles: [UploadAPI.LocalFile]) -> Void)? = nil
    // MARK: - uploadIdRetrieved(localFile: UploadAPI.LocalFile, uploadId: UploadAPI.UploadId)
    var uploadIdRetrievedHandler: ((_ localFile: UploadAPI.LocalFile, _ uploadId: UploadAPI.UploadId) -> Void)? = nil
    // MARK: - filePartsCreated(uploadId: UploadAPI.UploadId, fileParts: [FilePart])
    var filePartsCreatedHandler: ((_ uploadId: UploadAPI.UploadId, _ fileParts: [FilePart]) -> Void)? = nil
    // MARK: - filePartProgressed(uploadId: UploadAPI.UploadId, filePart: FilePart, progress: RxProgress)
    var filePartProgressedHandler: ((_ uploadId: UploadAPI.UploadId, _ filePart: FilePart, _ progress: RxProgress) -> Void)? = nil
    // MARK: - downloadUrlsRetrieved()
    var downloadUrlsRetrievedHandler: (() -> Void)? = nil
    // MARK: - fileProgress(_ source: UploadAPI.LocalFile.Source)
    var fileProgressHandler: ((UploadAPI.LocalFile.Source) -> Observable<RxProgress>)? = nil
}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

    // MARK: - createThumbImage(for pictureUrl: URL, fitting size: CGSize)
    var createThumbImageHandler: ((_ pictureUrl: URL, _ size: CGSize) throws -> NSImage)? = nil
    // MARK: - createThumbJpegData(for pictureUrl: URL, fitting size: CGSize, compression: Double)
    var createThumbJpegDataHandler: ((_ pictureUrl: URL, _ size: CGSize, _ compression: Double) throws -> Data)? = nil
}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {

    // MARK: - build()
    var buildHandler: (() -> TipsManaging & MutableTipsManaging)? = nil
}

// MARK: - TipsManaging
class TipsManagingMock: TipsManaging {

    var tips: [String: String] {
        get {
            if let handler = tipsGetHandler {
                return handler()
            }
            if let value = tipsBacking {
                return value
            }
            return [:]
        }
    }    
    var tipsGetHandler: (() -> [String: String])? = nil
    var tipsBacking: [String: String]?

    var tipsOptional: [String: String]? {
        get {
            return tipsOptionalGetHandler?() ?? tipsOptionalBacking
        }
    }    
    var tipsOptionalGetHandler: (() -> [String: String]?)? = nil
    var tipsOptionalBacking: [String: String]?

    var tupleVariable: (String, Int) {
        get {
            if let handler = tupleVariableGetHandler {
                return handler()
            }
            if let value = tupleVariableBacking {
                return value
            }
            return ("", 0)
        }
    }    
    var tupleVariableGetHandler: (() -> (String, Int))? = nil
    var tupleVariableBacking: (String, Int)?

    var tupleVariable2: (String?, Int?) {
        get {
            if let handler = tupleVariable2GetHandler {
                return handler()
            }
            if let value = tupleVariable2Backing {
                return value
            }
            return (nil, nil)
        }
    }    
    var tupleVariable2GetHandler: (() -> (String?, Int?))? = nil
    var tupleVariable2Backing: (String?, Int?)?

    var tupleOptional: (String, Int)? {
        get {
            return tupleOptionalGetHandler?() ?? tupleOptionalBacking
        }
    }    
    var tupleOptionalGetHandler: (() -> (String, Int)?)? = nil
    var tupleOptionalBacking: (String, Int)?

    var arrayVariable: [Double] {
        get {
            if let handler = arrayVariableGetHandler {
                return handler()
            }
            if let value = arrayVariableBacking {
                return value
            }
            return []
        }
    }    
    var arrayVariableGetHandler: (() -> [Double])? = nil
    var arrayVariableBacking: [Double]?

}

// MARK: - UploadProgressing
class UploadProgressingMock: UploadProgressing {

    var progress: Observable<Result<Double>> {
        get {
            if let handler = progressGetHandler {
                return handler()
            }
            return progressSubject.asObservable()
        }
    }    
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()


    // MARK: - fileProgress(_ source: UploadAPI.LocalFile.Source)
    var fileProgressHandler: ((UploadAPI.LocalFile.Source) -> Observable<RxProgress>)? = nil
}
