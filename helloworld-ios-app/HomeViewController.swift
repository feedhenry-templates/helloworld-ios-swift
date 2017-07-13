/*
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit
import FeedHenry

class HomeViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var result: UITextView!

    override func viewDidLoad() {
        result.contentInset = UIEdgeInsetsMake(20.0, 20.0, 10.0, 10.0);
        super.viewDidLoad()

        // Initialized cloud connection
        FH.init {(resp: Response, error: NSError?) -> Void in
            if let error = error {
                print("FH init failed. Error = \(error)")
                if FH.isOnline == false {
                    self.result.text = "Make sure you're online."
                } else {
                    if error.code == 0 {
                        self.result.text = "Please fill in fhconfig.plist file."
                    } else {
                        self.result.text = "FH init failed. \(error.localizedDescription)"
                    }
                }
                return
            }
            print("initialized OK")
            self.button.isHidden = false
        }
    }


    @IBAction func cloudCall(_ sender: AnyObject) {
        name.endEditing(true)

        let args = ["hello": name.text ?? "world"]

        FH.cloud(path: "hello", method: HTTPMethod.POST,
            args: args as [String : AnyObject]?, headers: nil,
            completionHandler: {(resp: Response, error: NSError?) -> Void in
            if let error = error {
                print("Cloud Call Failed, \(error)")
                self.result.text = "Error during Cloud call: \(error.userInfo[NSLocalizedDescriptionKey]!)"
                return
            }
            if let parsedRes = resp.parsedResponse as? [String:String] {
                self.result.text = parsedRes["msg"]
            }
        })
    }

    // Mark - Dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            name.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

}
