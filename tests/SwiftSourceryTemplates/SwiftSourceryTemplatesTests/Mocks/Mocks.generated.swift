// Generated using Sourcery 0.13.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//swiftlint:disable force_cast
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

import RxBlocking
import RxSwift
import RxTest
@testable import SwiftSourceryTemplates


// MARK: - AlbumPageSizeProviding
class AlbumPageSizeProvidingMock: AlbumPageSizeProviding {

    // MARK: - pageSize

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

// MARK: - MutableTipsManaging
class MutableTipsManagingMock: MutableTipsManaging {
}

// MARK: - MutableUploadProgressing
class MutableUploadProgressingMock: MutableUploadProgressing {

    // MARK: - progress


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
class TipsManagingMock: NSObject, TipsManaging {
}

// MARK: - UploadProgressing
class UploadProgressingMock: UploadProgressing {

    // MARK: - progress


    // MARK: - fileProgress(_ source: UploadAPI.LocalFile.Source)
    var fileProgressHandler: ((UploadAPI.LocalFile.Source) -> Observable<RxProgress>)? = nil
}
