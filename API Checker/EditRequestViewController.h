//
//  EditRequestViewController.h
//  API Checker
//
//  Created by Jack Stenglein on 5/12/17.
//  Copyright © 2017 JackStenglein. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    MethodType,
    Timeout
}SelectionTypes;

typedef enum {
    Body,
    Authorization,
    Headers
}FooterTypes;

@interface EditRequestViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSNumber *requestNumber;

@property (strong, nonatomic) NSDictionary *request;

/*!
 @brief View showing the current HTTP method.
 @discussion This view holds the button that allows the user to switch the method. The view requires an outlet to change the border styling.
 */
@property (strong, nonatomic) IBOutlet UIView *methodTypeView;

/*!
 @brief Allows the user to switch the HTTP method type.
 @discussion This button requires an outlet to switch the text after the user has chosen an HTTP method.
 */
@property (strong, nonatomic) IBOutlet UIButton *methodTypeButton;

/*!
 @brief Shows the request URL.
 @discussion This view contains the TextField that allows the user to enter the request URL. The view requires an outlet to change the border styling.
 */
@property (strong, nonatomic) IBOutlet UIView *requestStringView;


@property (strong, nonatomic) IBOutlet UITextField *requestStringField;


/*!
 @brief Displays the current timeout for the request.
 @discussion This view contains the button that allows the user to switch the timeout. The view requires an outlet to change the border styling.
 */
@property (strong, nonatomic) IBOutlet UIView *timeoutView;

/*!
 @brief Allows the user to change the request timeout.
 @discussion This button requires an outlet to switch the text after the user has chosen a timeout.
 */
@property (strong, nonatomic) IBOutlet UIButton *timeoutButton;

/*!
 @brief Displays the request name.
 @discussion This view contains the TextField that allows the user to enter the request URL. The view requires an outlet to change the border styling.
 */
@property (strong, nonatomic) IBOutlet UIView *requestNameView;


@property (strong, nonatomic) IBOutlet UITextField *requestNameField;


/*!
 @brief Changes the footer to the body.
 @discussion This button requires an outlet in order to change the font size when it is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIButton *bodyButton;

/*!
 @brief Acts as an underline for the bodyButton.
 @discussion This view requires an outlet in order to show/hide it when body is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIView *bodyLine;

/*!
 @brief Changes the footer to the authorization.
 @discussion This button requires an outlet in order to change the font size when it is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIButton *authButton;

/*!
 @brief Acts as an underline for the authButton.
 @discussion This view requires an outlet in order to show/hide it when authorization is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIView *authLine;

/*!
 @brief Changes the footer to the headers.
 @discussion This button requires an outlet in order to change the font size when it is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIButton *headersButton;

/*!
 @brief Acts as an underline for the headersButton.
 @discussion This view requires an outlet in order to show/hide it when headers is selected/deselected.
 */
@property (strong, nonatomic) IBOutlet UIView *headersLine;

/*!
 @brief Contains the UIPickerView for the timeout and HTTP method.
 @discussion This view requires an outlet in order to animate its appearance.
 */
@property (strong, nonatomic) IBOutlet UIView *selectionView;

/*!
 @brief The height constraint of the selectionView.
 @discussion This constraint requires an outlet in order to animate the selectionView.
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionViewHeight;

/*!
 @brief The bottom constrain of the selectionView.
 @discussion This constraint requires an outlet in order to animate the selectionView.
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *selectionViewBottom;

/*!
 @brief Informs the user whether they are picking the timeout or the HTTP method.
 @discussion This label requires an outlet in order to change its text depending on what is being selected.
 */
@property (strong, nonatomic) IBOutlet UILabel *selectionLabel;

/*!
 @brief Provides choices for the HTTP method and the timeout.
 @discussion This picker view requires an outlet in order to change its rows depending on what is being selected.
 */
@property (strong, nonatomic) IBOutlet UIPickerView *picker;

/*!
 @brief Displays the body and headers.
 */
@property (strong, nonatomic) IBOutlet UITableView *tableView;

/*!
 @brief Allows the user to switch the HTTP method.
 @discussion Animates a selection view that slides up from the bottom of the screen.
 @param sender The button that triggered the method call.
 */
- (IBAction)selectMethodType:(id)sender;

/*!
 @brief Allows the user to change the request timeout.
 @discussion Animates a selection view that slides up from the bottom of the screen.
 @param sender The button that triggered the method call.
 */
- (IBAction)selectTimeout:(id)sender;

/*!
 @brief Changes the footer to Body, Authorization or Headers.
 @param sender The button that triggered the method call.
 */
- (IBAction)selectFooterType:(UIButton *)sender;

/*!
 @brief Animates the closing of the selectionView.
 @discussion Slides the selectionView off the bottom of the screen.
 @param sender The button that triggered the method call.
 */
- (IBAction)closeSelectionView:(id)sender;


- (IBAction)saveRequest:(id)sender;

- (IBAction)cancel:(id)sender;

@end
