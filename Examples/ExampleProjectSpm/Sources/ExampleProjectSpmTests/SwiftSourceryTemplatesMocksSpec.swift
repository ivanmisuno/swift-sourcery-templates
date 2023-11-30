//
//  SwiftSourceryTemplatesTests.swift
//  SwiftSourceryTemplatesTests
//
//  Created by Ivan Misuno on 18/07/2018.
//  Copyright © 2018 AlbumPrinter BV. All rights reserved.
//

import Quick
import Nimble
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
  }
}
