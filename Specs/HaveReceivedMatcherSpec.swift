import Quick
import Nimble
import Fake4SwiftMatchers

class HaveReceivedMatcherSpec: QuickSpec {
    override func spec() {
        describe("HaveReceived") {
            var myFake: FakeFixture!

            beforeEach {
                myFake = FakeFixture()
            }

            it("is truthy when the specified method was called") {
                myFake.doStuff()

                expect(myFake).to(haveReceived("doStuff"))
            }

            it("is falsy when the specified method was not called") {
                expect(myFake).toNot(haveReceived("doStuff"))
            }

            describe("methods with arguments") {
                beforeEach {
                    myFake.doCoolStuff(withThings: "?bananas¿", andThangs: "")
                }

                it("is truthy when the arguments can be matched") {
                    expect(myFake).to(haveReceived("doCoolStuff"))
                    expect(myFake).to(haveReceived("doCoolStuff").with("?bananas¿", ""))
                }

                it("is falsy when the arguments can not be matched") {
                    expect(myFake).toNot(haveReceived("doCoolStuff").with("¡apples!", ""))
                    expect(myFake).toNot(haveReceived("doCoolStuff").with("?bananas¿", "apples :("))
                }
            }
        }
    }
}
