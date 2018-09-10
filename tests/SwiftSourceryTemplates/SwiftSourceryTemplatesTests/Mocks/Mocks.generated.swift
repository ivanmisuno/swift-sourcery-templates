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

// MARK: - ErrorPopoverBuildable
class ErrorPopoverBuildableMock: ErrorPopoverBuildable {
}

// MARK: - ErrorPopoverBuildableRawRepresentable
class ErrorPopoverBuildableRawRepresentableMock: ErrorPopoverBuildableRawRepresentable {
}

// MARK: - ErrorPopoverPresentable
class ErrorPopoverPresentableMock<TypeEventType>: ErrorPopoverPresentable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType
}

// MARK: - ErrorPopoverPresentableRawRepresentable
class ErrorPopoverPresentableRawRepresentableMock<TypeEventType>: ErrorPopoverPresentableRawRepresentable where TypeEventType: RawRepresentable, TypeEventType: Hashable {

    // MARK: - Generic typealiases
    typealias EventType = TypeEventType
}

// MARK: - ExifImageAttributeProviding
class ExifImageAttributeProvidingMock: ExifImageAttributeProviding {
}

// MARK: - ImageAttributeProviding
class ImageAttributeProvidingMock: ImageAttributeProviding {
}

// MARK: - LegacyProtocol
class LegacyProtocolMock: NSObject, LegacyProtocol {
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

// MARK: - MutableUploadProgressing
class MutableUploadProgressingMock: MutableUploadProgressing {
    var progress: Observable<Result<Double>> {
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()
}

// MARK: - ThumbCreating
class ThumbCreatingMock: ThumbCreating {
}

// MARK: - TipsManagerBuilding
class TipsManagerBuildingMock: TipsManagerBuilding {
}

// MARK: - TipsManaging
class TipsManagingMock: TipsManaging {
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
    var progress: Observable<Result<Double>> {
        if let handler = progressGetHandler {
            return handler()
        }
        return progressSubject.asObservable()
    }
    var progressGetHandler: (() -> Observable<Result<Double>>)? = nil
    lazy var progressSubject = PublishSubject<Result<Double>>()
}
