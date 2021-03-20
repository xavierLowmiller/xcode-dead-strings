import XCTest
@testable import DeadStrings

final class FileParserTests: XCTestCase {
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
}
