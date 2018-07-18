//
//  Protocols.swift
//  SwiftSourceryTemplates
//
//  Created by Ivan Misuno on 18/07/2018.
//  Copyright © 2018 AlbumPrinter BV. All rights reserved.
//

import RxSwift

// sourcery: CreateMock
protocol UploadProgressing {
    var progress: Observable<Double> { get }
    func fileProgress(_ source: UploadAPI.LocalFile.Source) -> Observable<RxProgress>
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
protocol AlbumPageSizeProviding {
    var pageSize: CGSize { get }
}

// sourcery: CreateMock
protocol ExifImageAttributeProviding {
    func dateTaken(fileUrl: URL) -> Date?
}

/// sourcery: CreateMock
protocol ErrorPopoverBuildable {
    func buildPopoverPresenter<T>(title: String, buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentable<T>
}

/// sourcery: CreateMock
protocol ErrorPopoverBuildableRawRepresentable {
    func buildPopoverPresenter<T: RawRepresentable>(title: String, buttons: [(title: String, identifier: T, handler: ()->())]) -> AnyErrorPopoverPresentableRawRepresentable<T>
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = EventType
protocol ErrorPopoverPresentable {
    associatedtype EventType
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType>
}

/// sourcery: CreateMock
/// sourcery: TypeErase
/// sourcery: associatedtype = "EventType: RawRepresentable, Hashable"
protocol ErrorPopoverPresentableRawRepresentable {
    associatedtype EventType: RawRepresentable, Hashable
    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType>
}

/// sourcery: CreateMock
@objc protocol TipsManaging: NSObjectProtocol {
}

/// sourcery: CreateMock
protocol MutableTipsManaging {
}

/// sourcery: CreateMock
protocol TipsManagerBuilding {
    func build() -> TipsManaging & MutableTipsManaging
}
