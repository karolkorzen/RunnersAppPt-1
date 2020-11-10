//
//  UploadTweetController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 10/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel


class UploadPostController: UIViewController {
    // MARK: - Properties
    
    private let user: User
    private let config: UploadPostConfiguration
    private lazy var viewModel = UploadPostViewModel(config: config)
    //private let imagePicker = UIImagePickerController()
//    private var selectedImage: UIImage? {
//        didSet{
//            postImage.image = selectedImage
//            selectImageButton.isHidden = true
//        }
//    }
    
//    lazy var postImage: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.clipsToBounds = true
//        iv.backgroundColor = .lightGray
//        iv.layer.cornerRadius = 10
//        iv.layer.masksToBounds = true
//
//        return iv
//    }()
//
//    private var selectImageButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = .bluish
//        button.setTitle("Add Image", for: .normal)
//        button.titleLabel?.textAlignment = .center
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
//
//        return button
//    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainAppColor
        button.setTitle("Share", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y:0, width: 64, height: 32)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleUploadPost), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 10
        iv.backgroundColor = .mainAppColor
        return iv
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .mainAppColor
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    // MARK: - Lifecycle
    
    init(user: User, config: UploadPostConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureUI()
        configureMentionHandler()
        //configureImagePicker()
        
        switch config {
        case .post:
            print("Post")
        case.reply(let post):
            //FIXME: Make this view smaller
            print("Replying to \(post.user)")
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//         self.addKeyboardObserver()
//     }
//
//     override func viewWillDisappear(_ animated: Bool) {
//         self.removeKeyboardObserver()
//     }
    
    // MARK: - Selectors
    
//    @objc func handleAddImage(){
//        self.present(imagePicker, animated: true, completion: nil)
//    }

    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUploadPost(){
        guard let caption = captionTextView.text else {return}
        PostService.shared.uploadPost(caption: caption, type: config) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
                return
            }
            if case .reply(let post) = self.config {
                print("DEBUG: AM I HERE?")
                
                NotificationService.shared.uploadNotification(type: .reply, post: post)
            }
            // inject uploadMentionNotificationHere
            //self.dismiss(animated: true, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)  //FIXME: MAKE EVERYTHING LIKE THAT ESSA BYCZQ I MEAN DISMISS ON INSIDE SERVICE
    }
    // MARK: - API
    
    func setCurrentUserProfileImageURL(completion: @escaping(URL) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { (user) in
            guard let url = user.profileImageUrl else {return}
            completion(url)
        }
    }
    
    func uploadMentionNotification(forCaption caption: String,forPost post: Post) {
        guard caption.contains("@") else {return}
        let words = caption.components(separatedBy: .whitespacesAndNewlines)
        
        words.forEach { (word) in
            guard word.hasPrefix("@") else {return}
            
            var username = word.trimmingCharacters(in: .symbols)
            username = username.trimmingCharacters(in: .punctuationCharacters)
            
            UserService.shared.fetchUser(uid: username) { (user) in
                NotificationService.shared.uploadNotification(type: .mention, post: post, user: user)
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        //FIXME: - Keyboard on fisplay
        
        view.backgroundColor = .white
        configureNavigationBar()
        
        //FIXME: - I CAN DO IT BETTER
        //profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        setCurrentUserProfileImageURL { (url) in
            self.profileImageView.sd_setImage(with: url)
        }

        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)

//        let stackAddPhoto = UIStackView(arrangedSubviews: [selectImageButton, postImage])
//        stackAddPhoto.axis = .horizontal
//        stackAddPhoto.spacing = 12
//        view.addSubview(stackAddPhoto)
//        postImage.isHidden = true
//        stackAddPhoto.backgroundColor = .brown
//
//        stackAddPhoto.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: self.view.frame.height/2)
//        
//        view.addSubview(selectImageButton)
//        selectImageButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 50)
//
//        view.addSubview(postImage)
//        postImage.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: view.frame.width - 32)

        
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else {return}
        replyLabel.text = replyText
        replyLabel.isUserInteractionEnabled = true
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .mainAppColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func configureMentionHandler(){
        replyLabel.handleMentionTap { (mention) in
            
            
        }
    }
    
    /* image picker
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
     */
}

//extension UploadPostController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("DEBUG: selected image")
//        guard let image = info[.editedImage] as? UIImage else {return}
//        self.selectedImage = image
//        print("DEBUG: selected image")
//        dismiss(animated: true, completion: nil)
//    }
//}
