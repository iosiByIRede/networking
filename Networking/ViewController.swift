//
//  ViewController.swift
//  Networking
//
//  Created by Pedro on 02/01/23.
//

import UIKit

class ViewController: UIViewController {

    let networkService = NetworkService.shared

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPost()
    }

    private func requestPost() {
        let postRequest = Post.Request(postID: 1)
        networkService.request(postRequest) { result in
            switch result {
            case .failure(let error):
                print(error.rawValue)
            case .success(let response):
                self.titleLabel.text = response.title
                self.textView.text = response.body
            }
        }
    }
}
