//
//  Fit_Vein_UI_Tests.swift
//  Fit Vein UI Tests
//
//  Created by Łukasz Janiszewski on 04/01/2022.
//

import XCTest

class Fit_Vein_UI_Tests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        app.activate()
    }

    func testHomeViewNotificationsButton() throws {
        let homeViewNotificationsButton = app.navigationBars.buttons["Notifications"]
        let notificationsViewTexts = app.staticTexts["Hello, World!"]
        
        sleep(3)
        
        homeViewNotificationsButton.tap()
        XCTAssertTrue(notificationsViewTexts.exists)
    }
    
    func testHomeViewSearchButton() throws {
        let homeViewNotificationsButton = app.navigationBars.buttons["Search"]
        let notificationsViewTexts = app.staticTexts["Follow"]
        
        sleep(3)
                
        homeViewNotificationsButton.tap()
        XCTAssertTrue(notificationsViewTexts.exists)
    }
    
    func testHomeViewAddPostTextField() throws {
        let scrollViewsQuery = app.scrollViews
        let homeViewAddPostTextField = scrollViewsQuery.otherElements.staticTexts["What do you want to share?"]
        let addPostViewTexts = app.staticTexts["Add a post"]
        
        sleep(3)
                
        homeViewAddPostTextField.tap()
        XCTAssertTrue(addPostViewTexts.exists)
    }
    
    func testHomeViewMoreButton() throws {
        let homeViewModeButton = app.otherElements.buttons["More"]
        let homeViewSheetEditButton = app.sheets.scrollViews.otherElements.buttons["Edit"]
        
        sleep(3)
        
        homeViewModeButton.tap()
        XCTAssertTrue(homeViewSheetEditButton.exists)
    }
    
//    func testHomeViewLikeButton() throws {
//        let homeViewNotificationsButton = app.navigationBars.buttons["Search"]
//        let notificationsViewTexts = app.staticTexts["Follow"]
//
//        homeViewNotificationsButton.tap()
//        XCTAssertTrue(notificationsViewTexts.exists)
//    }
    
    func testHomeViewCommentButton() throws {
        let scrollViewsQuery = app.scrollViews
        let homeViewCommentButton = scrollViewsQuery.otherElements.containing(.staticText, identifier:"What do you want to share?").children(matching: .button).matching(identifier: "Comment").element(boundBy: 0)
        let commentsViewLikeButton = scrollViewsQuery.otherElements.containing(.image, identifier:"Like").children(matching: .button).matching(identifier: "Like").element(boundBy: 0)
        
        sleep(3)
                
        homeViewCommentButton.tap()
        XCTAssertTrue(commentsViewLikeButton.exists)
    }
    
    func testTabBarHomeTabButton() throws {
        let tabBarHomeTabButton = app.buttons["Home"]
        let homeViewTexts = app.staticTexts["Your friends activity"]
        
        sleep(3)
                
        tabBarHomeTabButton.tap()
        XCTAssertTrue(homeViewTexts.exists)
    }
    
    func testTabBarWorkoutTabButton() throws {
        let tabBarWorkoutTabButton = app.buttons["Workout"]
        let workoutViewTexts = app.staticTexts["Interval"]
        
        sleep(3)
        
        tabBarWorkoutTabButton.tap()
        XCTAssertTrue(workoutViewTexts.exists)
    }
    
    func testTabBarProfileTabButton() throws {
        let tabBarProfileTabButton = app.buttons["Profile"]
        let profileViewTexts = app.staticTexts["Level 1"]
        
        sleep(3)
                
        tabBarProfileTabButton.tap()
        XCTAssertTrue(profileViewTexts.exists)
    }
    
    func testProfileViewTabChangeToWorkouts() throws {
        let tabBarProfileTabButton = app.buttons["Profile"]
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let profileViewHealthSegmentedControl = elementsQuery.buttons["Love"]
        let profileViewHealthSegmentTexts = app.staticTexts["Steps"]
        let profileViewWalkSegmentedControl = elementsQuery/*@START_MENU_TOKEN@*/.buttons["Walk"]/*[[".segmentedControls.buttons[\"Walk\"]",".buttons[\"Walk\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let profileViewWalkSegmentTexts = app.staticTexts["Interval"]
        let profileViewWalkSegmentedControlListView = elementsQuery.navigationBars["Workouts"]/*@START_MENU_TOKEN@*/.buttons["List"]/*[[".segmentedControls.buttons[\"List\"]",".buttons[\"List\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let profileViewWalkSegmentListTexts = app.staticTexts["Interval"]
        
        sleep(3)
        
        tabBarProfileTabButton.tap()
        profileViewWalkSegmentedControl.tap()
        XCTAssertTrue(profileViewWalkSegmentTexts.exists)
        profileViewWalkSegmentedControlListView.tap()
        XCTAssertTrue(profileViewWalkSegmentListTexts.exists)
        profileViewHealthSegmentedControl.tap()
        XCTAssertTrue(profileViewHealthSegmentTexts.exists)
    }
    
    func testProfileViewSettings() throws {
        let tabBarProfileTabButton = app.buttons["Profile"]
        let profileViewMoreButton = app.scrollViews.otherElements.buttons["More"]
        let gitHubFollowingLabel = app.staticTexts["Follow me on GitHub:"]
        
        let tablesQuery = app.tables
        
        let termsAndConditionsTabButton = tablesQuery.buttons["Terms and Conditions"]
        let termsAndConditionsTabTexts = app.staticTexts["This app is a fully open-source and licence-free product."]
        let termsAndConditionsTabBackButton = app.navigationBars["Terms and Conditions"].buttons["Settings"]
        
        let helpTabButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Help"]/*[[".cells[\"Help\"].buttons[\"Help\"]",".buttons[\"Help\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let helpTabTexts = app.staticTexts["describing the matter."]
        let helpTabBackButton = app.navigationBars["Help"].buttons["Settings"]
        
        let logoutButton = tablesQuery.cells["Logout"].children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let logoutConfirmRedButton = app.sheets["Are you sure you want to logout?"].scrollViews.otherElements.buttons["Logout"]
        let logoutCancelButton = app.sheets["Are you sure you want to logout?"].scrollViews.otherElements.buttons["Cancel"]
        
        let deleteAccountButton = tablesQuery.cells["Delete account"].children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let deleteAccountConfirmRedButton = app.sheets["Are you sure you want to delete your account? All data will be lost."].scrollViews.otherElements.buttons["Delete Account"]
        let deleteAccountSheetText = app.staticTexts["Before you delete your account please provide your login credentials to confirm it is really you."]
        let deleteAccountTabEmailTextField = tablesQuery.textFields["E-mail"]
        let deleteAccountTabPasswordTextField = tablesQuery.secureTextFields["Password"]
           
        sleep(3)
        
        tabBarProfileTabButton.tap()
        profileViewMoreButton.tap()
        XCTAssertTrue(gitHubFollowingLabel.exists)
        
        termsAndConditionsTabButton.tap()
        XCTAssertTrue(termsAndConditionsTabTexts.exists)
        termsAndConditionsTabBackButton.tap()
        
        helpTabButton.tap()
        XCTAssertTrue(helpTabTexts.exists)
        helpTabBackButton.tap()
        
        logoutButton.tap()
        XCTAssertTrue(logoutConfirmRedButton.exists)
        XCTAssertTrue(logoutCancelButton.exists)
        logoutCancelButton.tap()
        
        deleteAccountButton.tap()
        XCTAssertTrue(deleteAccountConfirmRedButton.exists)
        deleteAccountConfirmRedButton.tap()
        sleep(1)
        XCTAssertTrue(deleteAccountSheetText.exists)
        deleteAccountTabEmailTextField.tap()
        deleteAccountTabEmailTextField.typeText("email")
        XCTAssertEqual(deleteAccountTabEmailTextField.value as! String, "email")
        deleteAccountTabPasswordTextField.tap()
        deleteAccountTabPasswordTextField.typeText("password")
        XCTAssertEqual(deleteAccountTabPasswordTextField.value as! String, "••••••••")
                
    }
    
    func testSettingsViewChangeEmailTab() {
        let tabBarProfileTabButton = app.buttons["Profile"]
        let profileViewMoreButton = app.scrollViews.otherElements.buttons["More"]
        
        let tablesQuery = app.tables
        
        let changeEmailAddressButton = tablesQuery.cells["Change e-mail address"].children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let changeEmailAddressTabText = app.staticTexts["Before you change your e-mail address please provide your login credentials to confirm it is really you."]
        let changeEmailTabOldEmailTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Old e-mail address"]/*[[".cells[\"Old e-mail address\"].textFields[\"Old e-mail address\"]",".textFields[\"Old e-mail address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let changeEmailTabPasswordTextField = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".cells[\"Password\"].secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let changeEmailTabNewEmailTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["New e-mail address"]/*[[".cells[\"New e-mail address\"].textFields[\"New e-mail address\"]",".textFields[\"New e-mail address\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        sleep(3)
        
        tabBarProfileTabButton.tap()
        profileViewMoreButton.tap()
        changeEmailAddressButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(changeEmailAddressTabText.exists)
        
        changeEmailTabOldEmailTextField.tap()
        changeEmailTabOldEmailTextField.typeText("old_email")
        XCTAssertEqual(changeEmailTabOldEmailTextField.value as! String, "old_email")
        changeEmailTabPasswordTextField.tap()
        changeEmailTabPasswordTextField.typeText("password")
        XCTAssertEqual(changeEmailTabPasswordTextField.value as! String, "••••••••")
        changeEmailTabNewEmailTextField.tap()
        changeEmailTabNewEmailTextField.typeText("new_email")
        XCTAssertEqual(changeEmailTabNewEmailTextField.value as! String, "new_email")
    }
    
    func testSettingsViewChangePasswordTab() {
        let tabBarProfileTabButton = app.buttons["Profile"]
        let profileViewMoreButton = app.scrollViews.otherElements.buttons["More"]
        
        let tablesQuery = app.tables
        
        let changePasswordButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Change password"]/*[[".cells[\"Change password\"].buttons[\"Change password\"]",".buttons[\"Change password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let changePasswordTabText = app.staticTexts["Before you change your password please provide your login credentials to confirm it is really you."]
        let changePasswordTabEmailTextField = tablesQuery.textFields["E-mail"]
        let changePasswordTabOldPasswordTextField = tablesQuery.secureTextFields["Old password"]
        let changePasswordTabNewPasswordTextField = tablesQuery.secureTextFields["New password"]
        
        
        sleep(3)
        
        tabBarProfileTabButton.tap()
        profileViewMoreButton.tap()
        
        sleep(2)
        
        changePasswordButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(changePasswordTabText.exists)
        
        changePasswordTabEmailTextField.tap()
        changePasswordTabEmailTextField.typeText("email")
        XCTAssertEqual(changePasswordTabEmailTextField.value as! String, "email")
        changePasswordTabOldPasswordTextField.tap()
        changePasswordTabOldPasswordTextField.typeText("old_password")
        XCTAssertEqual(changePasswordTabOldPasswordTextField.value as! String, "••••••••••••")
        changePasswordTabNewPasswordTextField.tap()
        changePasswordTabNewPasswordTextField.typeText("new_password")
        XCTAssertEqual(changePasswordTabNewPasswordTextField.value as! String, "••••••••••••")
    }
    
    func testWorkoutTabAddWorkout() {
        let tabBarWorkoutTabButton = app.buttons["Workout"]
        let workoutViewTexts = app.staticTexts["Interval"]
        let addWorkoutButton = app.navigationBars["Workouts"].buttons["Add"]
        let workoutViewTextsFirstTextFieldText = app.staticTexts["Rounds Number"]
        let workoutViewTextsSecondTextFieldText = app.staticTexts["Work Time"]
        let workoutViewTextsThirdTextFieldText = app.staticTexts["Rest Time"]
        let backToMainViewWorkoutTabButton = app.navigationBars["Add Workout"].buttons["Workouts"]
        
        sleep(3)
        
        tabBarWorkoutTabButton.tap()
        XCTAssertTrue(addWorkoutButton.exists)
        addWorkoutButton.tap()
        for viewText in [workoutViewTextsFirstTextFieldText, workoutViewTextsSecondTextFieldText, workoutViewTextsThirdTextFieldText] {
            XCTAssertTrue(viewText.exists)
        }
        backToMainViewWorkoutTabButton.tap()
        XCTAssertTrue(workoutViewTexts.exists)

                
    }
}
