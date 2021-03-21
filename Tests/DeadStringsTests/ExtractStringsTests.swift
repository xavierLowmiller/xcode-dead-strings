import XCTest
@testable import DeadStrings

final class ExtractStringsTests: XCTestCase {
    func testStringExtractionFromSwiftFile() {
        let swiftFile = ##"""
        //
        //  ContentView.swift
        //

        import SwiftUI

        struct ContentView: View {
            @State private var mail = """
            a@b.com
            """
            @State private var password = #"secret"#

            var body: some View {
                VStack(spacing: 8) {
                    Text("")
                    TextField("Mail Address", text: $mail)
                        .disabled(true)
                        .border(Color.black, width: 1)
                    SecureField("Password", text: $password)
                        .border(Color.black, width: 1)
                }.padding()
            }
        }

        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
        """##

        let parsedStrings = extractStrings(from: swiftFile)

//        XCTAssert(parsedStrings.contains(""))
//        XCTAssert(parsedStrings.contains("a@b.com"))
        XCTAssert(parsedStrings.contains("Mail Address"))
        XCTAssert(parsedStrings.contains("Password"))
        XCTAssert(parsedStrings.contains("secret"))
    }

    func testStringExtractionFromObjcFile() {
        let objcFile = ##"""
        - (void)viewDidLoad {
            [super viewDidLoad];

            self.title = @"My View Controller";
        }

        - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = "test";
            return cell;

        }
        """##

        let parsedStrings = extractStrings(from: objcFile)

        XCTAssert(parsedStrings.contains("My View Controller"))
        XCTAssert(parsedStrings.contains("Cell"))
        XCTAssert(parsedStrings.contains("test"))
    }

    func testStringExtractionFromPlistFile() {
        let plistFile = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>CFBundleDevelopmentRegion</key>
            <string>en</string>
            <key>NSCameraUsageDescription</key>
            <string>Wanna take pictures? Enable the camera!</string>
            <key>NSFaceIDUsageDescription</key>
            <string>Use FaceID to log in</string>
            <key>NSLocationWhenInUseUsageDescription</key>
            <string>Find yourself more easily</string>
            <key>NSPhotoLibraryUsageDescription</key>
            <string>For picking images to upload</string>
            <key>UIUserInterfaceStyle</key>
            <string>Light</string>
        </dict>
        </plist>
        """

        let strings = extractStrings(from: plistFile, isPlist: true)

        XCTAssert(strings.contains("CFBundleDevelopmentRegion"))
        XCTAssert(strings.contains("NSCameraUsageDescription"))
        XCTAssert(strings.contains("NSFaceIDUsageDescription"))
        XCTAssert(strings.contains("NSLocationWhenInUseUsageDescription"))
        XCTAssert(strings.contains("NSPhotoLibraryUsageDescription"))
        XCTAssert(strings.contains("UIUserInterfaceStyle"))
    }

    func testExtractingStringsFromFile() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("MixedObjCProjectForLocalizedString")
            .appendingPathComponent("AppDelegate.m")

        let strings = extractStrings(fromFileAt: url)

        XCTAssert(strings.contains("Default Configuration"))
    }

    func testExtractingStringsFromActualProject() {
        let url = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("MixedObjCProjectForLocalizedString")

        let strings = extractStrings(fromFilesAt: url)

        // ViewController.m
        XCTAssert(strings.contains("push_first_vc"))
        XCTAssert(strings.contains("my_view_controller"))

        // SwiftViewController.swift
        XCTAssert(strings.contains("my_swift_view_controller"))
        XCTAssert(strings.contains("push_second_vc"))

        // SwiftUIView.swift
        XCTAssert(strings.contains("login_title"))
        XCTAssert(strings.contains("mail_address_placeholder"))
        XCTAssert(strings.contains("password_placeholder"))
        XCTAssert(strings.contains("swiftui_view_title"))

        // Not localized
        XCTAssert(strings.contains("secret"))
        XCTAssert(strings.contains("Default Configuration"))

        // Dead strings
        XCTAssertFalse(strings.contains("dead_string"))
    }
}
