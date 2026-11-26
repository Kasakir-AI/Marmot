import XCTest
@testable import Marmot

/// The fix Marmot suggests when an item can't be moved to the Trash.
final class PermissionHintTests: XCTestCase {

    func testABlockedAppPointsToAppManagement() {
        for path in ["/Applications/Slack.app", NSHomeDirectory() + "/Applications/Tool.app"] {
            let hint = PlanExecutor.failureHint(path: path, permissionError: true, finderStderr: "")
            XCTAssertTrue(hint.contains(Permissions.appManagementHint), path)
        }
    }

    func testABlockedFileStillPointsToFullDiskAccess() {
        let hint = PlanExecutor.failureHint(path: "/Library/Caches/thing.db", permissionError: true, finderStderr: "")
        XCTAssertTrue(hint.contains("Full Disk Access"))
        XCTAssertFalse(hint.contains(Permissions.appManagementHint))
    }

    func testFinderAutomationRefusalComesFirst() {
        let hint = PlanExecutor.failureHint(path: "/Applications/Slack.app", permissionError: true,
                                            finderStderr: "execution error: Not authorized (-1743)")
        XCTAssertTrue(hint.contains("Automation"))
    }

    func testOtherErrorsGetNoHint() {
        XCTAssertEqual(PlanExecutor.failureHint(path: "/Applications/Slack.app", permissionError: false,
                                                finderStderr: ""), "")
    }
}
