// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
//swiftlint:disable function_body_length
//swiftlint:disable line_length
//swiftlint:disable vertical_whitespace

import RxSwift

// MARK: - Type erasure for `ErrorPopoverPresentable`

private class _AnyErrorPopoverPresentableBase<EventType>: ErrorPopoverPresentable {
    init() {
        guard type(of: self) != _AnyErrorPopoverPresentableBase.self else {
            fatalError("_AnyErrorPopoverPresentableBase<EventType> instances can not be created; create a subclass instance instead")
        }
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        fatalError("Must override")
    }
    func setActionSink(_ actionSink: AnyObject?) -> Void {
        fatalError("Must override")
    }
}

private final class _AnyErrorPopoverPresentableBox<Concrete: ErrorPopoverPresentable>: _AnyErrorPopoverPresentableBase<Concrete.EventType> {
    private let concrete: Concrete
    typealias EventType = Concrete.EventType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return concrete.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
    override func setActionSink(_ actionSink: AnyObject?) -> Void {
        return concrete.setActionSink(actionSink)
    }
}

final class AnyErrorPopoverPresentable<EventType>: ErrorPopoverPresentable {
    private let box: _AnyErrorPopoverPresentableBase<EventType>

    init<Concrete: ErrorPopoverPresentable>(_ concrete: Concrete) where Concrete.EventType == EventType {
        self.box = _AnyErrorPopoverPresentableBox(concrete)
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return box.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
    func setActionSink(_ actionSink: AnyObject?) -> Void {
        return box.setActionSink(actionSink)
    }
}

// MARK: - Type erasure for `ErrorPopoverPresentableRawRepresentable`

private class _AnyErrorPopoverPresentableRawRepresentableBase<EventType>: ErrorPopoverPresentableRawRepresentable where EventType: Hashable, EventType: RawRepresentable {
    init() {
        guard type(of: self) != _AnyErrorPopoverPresentableRawRepresentableBase.self else {
            fatalError("_AnyErrorPopoverPresentableRawRepresentableBase<EventType> instances can not be created; create a subclass instance instead")
        }
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        fatalError("Must override")
    }
}

private final class _AnyErrorPopoverPresentableRawRepresentableBox<Concrete: ErrorPopoverPresentableRawRepresentable>: _AnyErrorPopoverPresentableRawRepresentableBase<Concrete.EventType> {
    private let concrete: Concrete
    typealias EventType = Concrete.EventType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return concrete.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

final class AnyErrorPopoverPresentableRawRepresentable<EventType>: ErrorPopoverPresentableRawRepresentable where EventType: Hashable, EventType: RawRepresentable {
    private let box: _AnyErrorPopoverPresentableRawRepresentableBase<EventType>

    init<Concrete: ErrorPopoverPresentableRawRepresentable>(_ concrete: Concrete) where Concrete.EventType == EventType {
        self.box = _AnyErrorPopoverPresentableRawRepresentableBox(concrete)
    }

    func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) -> Observable<EventType> {
        return box.show(relativeTo: positioningRect, of: positioningView, preferredEdge: preferredEdge)
    }
}

// MARK: - Type erasure for `Interactable`

private class _AnyInteractableBase: Interactable {
    init() {
        guard type(of: self) != _AnyInteractableBase.self else {
            fatalError("_AnyInteractableBase instances can not be created; create a subclass instance instead")
        }
    }
}

private final class _AnyInteractableBox<Concrete: Interactable>: _AnyInteractableBase {
    private let concrete: Concrete

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }
}

public final class AnyInteractable: Interactable {
    private let box: _AnyInteractableBase

    public init<Concrete: Interactable>(_ concrete: Concrete) {
        self.box = _AnyInteractableBox(concrete)
    }
}

// MARK: - Type erasure for `Routing`

private class _AnyRoutingBase<InteractorType>: Routing where InteractorType: Interactable {
    init() {
        guard type(of: self) != _AnyRoutingBase.self else {
            fatalError("_AnyRoutingBase<InteractorType> instances can not be created; create a subclass instance instead")
        }
    }

    var interactor: InteractorType {
        get { fatalError("Must override") }
        
    }
}

private final class _AnyRoutingBox<Concrete: Routing>: _AnyRoutingBase<Concrete.InteractorType> {
    private let concrete: Concrete
    typealias InteractorType = Concrete.InteractorType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override var interactor: InteractorType {
        get { return concrete.interactor }
        
    }
}

public final class AnyRouting<InteractorType>: Routing where InteractorType: Interactable {
    private let box: _AnyRoutingBase<InteractorType>

    public init<Concrete: Routing>(_ concrete: Concrete) where Concrete.InteractorType == InteractorType {
        self.box = _AnyRoutingBox(concrete)
    }

    public var interactor: InteractorType {
        get { return box.interactor }
        
    }
}

// MARK: - Type erasure for `SomeRouting`

private class _AnySomeRoutingBase<InteractorType>: SomeRouting where InteractorType: SomeInteractable {
    init() {
        guard type(of: self) != _AnySomeRoutingBase.self else {
            fatalError("_AnySomeRoutingBase<InteractorType> instances can not be created; create a subclass instance instead")
        }
    }

    var interactor: InteractorType {
        get { fatalError("Must override") }
        
    }
}

private final class _AnySomeRoutingBox<Concrete: SomeRouting>: _AnySomeRoutingBase<Concrete.InteractorType> {
    private let concrete: Concrete
    typealias InteractorType = Concrete.InteractorType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override var interactor: InteractorType {
        get { return concrete.interactor }
        
    }
}

public final class AnySomeRouting<InteractorType>: SomeRouting where InteractorType: SomeInteractable {
    private let box: _AnySomeRoutingBase<InteractorType>

    public init<Concrete: SomeRouting>(_ concrete: Concrete) where Concrete.InteractorType == InteractorType {
        self.box = _AnySomeRoutingBox(concrete)
    }

    public var interactor: InteractorType {
        get { return box.interactor }
        
    }
}

// MARK: - Type erasure for `ThrowingGenericBuildable`

private class _AnyThrowingGenericBuildableBase<EventType>: ThrowingGenericBuildable {
    init() {
        guard type(of: self) != _AnyThrowingGenericBuildableBase.self else {
            fatalError("_AnyThrowingGenericBuildableBase<EventType> instances can not be created; create a subclass instance instead")
        }
    }

    func build() throws -> AnyErrorPopoverPresentable<EventType> {
        fatalError("Must override")
    }
}

private final class _AnyThrowingGenericBuildableBox<Concrete: ThrowingGenericBuildable>: _AnyThrowingGenericBuildableBase<Concrete.EventType> {
    private let concrete: Concrete
    typealias EventType = Concrete.EventType

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func build() throws -> AnyErrorPopoverPresentable<EventType> {
        return try concrete.build()
    }
}

final class AnyThrowingGenericBuildable<EventType>: ThrowingGenericBuildable {
    private let box: _AnyThrowingGenericBuildableBase<EventType>

    init<Concrete: ThrowingGenericBuildable>(_ concrete: Concrete) where Concrete.EventType == EventType {
        self.box = _AnyThrowingGenericBuildableBox(concrete)
    }

    func build() throws -> AnyErrorPopoverPresentable<EventType> {
        return try box.build()
    }
}
