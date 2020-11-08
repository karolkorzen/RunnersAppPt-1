//
//  EditProfileController.swift
//  RunnersAppPt-1
//
//  Created by Karol Korzeń on 26/10/2020.
//  Copyright © 2020 Karol Korzeń. All rights reserved.
//

import UIKit

private let reuseIdentifier = "reuseID"

protocol EditProfileControllerDelegate: class {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

class EditProfileController: UITableViewController {
    // MARK: - Properties
    
    private var user: User
    private var userBackup: User?
    private lazy var headerView = EditProfileHeader(user: user)
    private let footerView = EditProfileFooterView()
    private let imagePicker = UIImagePickerController()
    private var userInfoChanged = false
    private var imageChanged = false
    weak var delegate: EditProfileControllerDelegate?
    private var selectedImage: UIImage? {
        didSet{
            navigationItem.rightBarButtonItem?.isEnabled = true
            headerView.profileImageView.image = selectedImage
            imageChanged = true
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        self.userBackup = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImagePicker()
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
        if let backup = userBackup {
            self.user = backup
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        if userInfoChanged{

            updateUserData()
        }
        if imageChanged {
            updateProfileImage()
        } else {
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    // MARK: - Api
    
    func updateUserData() {
        UserService.shared.saveUserData(user: user) { (err, ref) in
            if let error = err {
                print("ERROR: \(error)")
            }
            //self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    func updateProfileImage(){
        guard let image = selectedImage else {return}
        UserService.shared.updateProfileImage(image: image) { (profileImageUrl) in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, wantsToUpdate: self.user)
        }
    }
    
    // MARK: - Helpers
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .pinkish
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView(){
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 200)
        footerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

// MARK: - UITableViewDataSource

extension EditProfileController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return 0}
        return option == .bio ? 100 : 48
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func enableDoneButton(){
        guard let userBackup = self.userBackup else {return}
        if (user.fullname == userBackup.fullname) && (user.username == userBackup.username) && (user.bio == userBackup.bio){
            userInfoChanged = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else {return}
        
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else {return}
            if fullname != user.fullname {
                user.fullname = fullname
                enableDoneButton()
            }
        case .username:
            guard let username = cell.infoTextField.text else {return}
            if username != user.username {
                user.username = username
                enableDoneButton()
            }
        case .bio:
            if user.bio != cell.bioTextView.text {
                user.bio = cell.bioTextView.text
                enableDoneButton()
            }
        }
    }
}

// MARK: - EditProfileFooterDelegate

extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert,animated: true,completion: nil)
    }
}
