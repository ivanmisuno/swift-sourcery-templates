//
//  SwiftSourceryTemplatesTests.swift
//  SwiftSourceryTemplatesTests
//
//  Created by Ivan Misuno on 18/07/2018.
//  Copyright © 2018 AlbumPrinter BV. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import ExampleProjectSpm

class SwiftSourceryTemplatesMocksSpec: QuickSpec {
  override static func spec() {
    describe("UploadProgressingMock") {
      var sut: UploadProgressingMock!
      beforeEach {
        sut = UploadProgressingMock()
      }
      it("progressGetCount == 0") {
        expect(sut.progressGetCount) == 0
      }
    } // describe("UploadProgressingMock")

    describe("InteractableMock") {
      var sut: InteractableMock!
      beforeEach {
        sut = InteractableMock()
      }
      it("activateCallCount == 0") {
        expect(sut.activateCallCount) == 0
      }
    } // describe("InteractableMock")

    describe("mock with AnyObserver") {
      var sut: SomeEntityBindableMock!
      beforeEach {
        sut = SomeEntityBindableMock()
      }
      describe("entityObserver() called on the mock") {
        beforeEach {
          _ = sut.entityObserver()
        }
        it("entityObserver call count increases") {
          expect(sut.entityObserverCallCount) == 1
        }
        context("entityObserver.on() called") {
          beforeEach {
            sut.entityObserver().onNext("next element")
          }
          it("entityObserverEvent call count increased") {
            expect(sut.entityObserverEventCallCount) == 1
          }
        } // context("entityObserver.on() called")
      }
    } // describe("mock with AnyObserver")
  }
}
