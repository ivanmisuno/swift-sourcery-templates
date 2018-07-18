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

            // MARK: - buildPopoverPresenter<T>

}

// MARK: - ErrorPopoverBuildableRawRepresentable
class ErrorPopoverBuildableRawRepresentableMock: ErrorPopoverBuildableRawRepresentable {

            // MARK: - buildPopoverPresenter<T: RawRepresentable>

}

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<TypeEventType>: ErrorPopoverPresentable {

    typealias EventType = TypeEventType


            // MARK: - show

}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<TypeEventType>: ErrorPopoverPresentableRawRepresentable where TypeEventType: RawRepresentable, TypeEventType: Hashable {

    typealias EventType = TypeEventType


            // MARK: - show

}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {

            // MARK: - dateTaken

}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {

            // MARK: - imagePixelSize

}

// MARK: - MutableTipsManaging
class MutableTipsManagingMock: MutableTipsManaging {
}

// MARK: - MutableUploadProgressing
class MutableUploadProgressingMock: MutableUploadProgressing {

            // MARK: - progress


            // MARK: - setInputFiles

            // MARK: - uploadIdRetrieved

            // MARK: - filePartsCreated

            // MARK: - filePartProgressed

            // MARK: - downloadUrlsRetrieved

            // MARK: - fileProgress

}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {

            // MARK: - createThumbImage

            // MARK: - createThumbJpegData

}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {

            // MARK: - build

}

// MARK: - TipsManaging
class TipsManagingMock: NSObject, TipsManaging {
}

// MARK: - UploadProgressing
class UploadProgressingMock: UploadProgressing {

            // MARK: - progress


            // MARK: - fileProgress

}
