//
//  EditInstructionsController.swift
//  FoodSpace
//
//  Created by Corey Howell on 11/4/16.
//  Copyright © 2016 Pan Labs. All rights reserved.
//

import UIKit

class EditInstructionsController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var instructions = [String]() {
        didSet {
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })
        }
    }
    
    var parentView: UIViewController?
    
    let cellId = "cellId"
    
    let backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    var forceEdit: Bool?
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(InstructionsCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        
        setupKeyboardObservers()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        collectionView?.addGestureRecognizer(longPressGesture)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.left
        collectionView?.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureRight.direction = UISwipeGestureRecognizerDirection.right
        collectionView?.addGestureRecognizer(swipeGestureRight)
        
        lineNumberWidth = estimateFrameForText("UPPERCASE", font: BaseTextView.Fonts.smallLightFont!, width: 200).height + 15
        
        collectionView?.backgroundView = backgroundView
        editButton.addTarget(self, action: #selector(handleEditInstruction), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(handleDeleteInstruction), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _forceEdit = forceEdit {
            if (_forceEdit == true && instructionIndexBeingEdited != nil) {
                handleEditInstruction()
                return
            }
        }
        inputContainerView.inputTextField.becomeFirstResponder()
    }
    
    func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([
            NSForegroundColorAttributeName : UIColor.white], for: .normal)
        
        navigationItem.title = "Recipe"
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Lato-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.barTintColor = ColorPalette.BrandGreen
        navigationController?.navigationBar.backgroundColor = ColorPalette.BrandGreen
        
        edgesForExtendedLayout = []
    }
    
    lazy var inputContainerView: InputContainerView = {
        let inputContainerView = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        inputContainerView.parentController = self
        return inputContainerView
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
    }
    
    func handleKeyboardDidShow() {
        if instructions.count > 0 {
            let indexPath = IndexPath(item: instructions.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instructions.count
    }
    
    // lets get some constants to make size prediction easier
    let containerViewLeftConstant = CGFloat(10)
    let containerViewRightConstant = CGFloat(10)
    let numberViewLeftConstant = CGFloat(10)
    let numberViewRightConstant = CGFloat(10)
    var lineNumberWidth: CGFloat?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstructionsCell
        
        cell.index = indexPath.item
        cell.containerViewLeftConstant = containerViewLeftConstant
        cell.containerViewRightConstant = containerViewRightConstant
        cell.numberViewLeftConstant = numberViewLeftConstant
        cell.numberViewRightConstant = numberViewRightConstant
        cell.lineNumberHeight = lineNumberWidth
        
        let instruction = instructions[(indexPath as NSIndexPath).item]
        
        cell.instruction = instruction
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 60
        
        let instruction = instructions[(indexPath as NSIndexPath).item]
        
        let width = UIScreen.main.bounds.width
        
        let textViewWidth = width - (containerViewLeftConstant + numberViewLeftConstant + lineNumberWidth! + numberViewRightConstant + containerViewRightConstant)
        
        let minimumHeight = lineNumberWidth! + 20
        let estimatedHeight = estimateFrameForText(instruction, font: BaseTextView.Fonts.smallLightFont!, width: textViewWidth).height + 10
        
        height = estimatedHeight > minimumHeight ? estimatedHeight : minimumHeight

        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move your data order
        
        let selectedInstruction = instructions.remove(at: sourceIndexPath.item)
        instructions.insert(selectedInstruction, at: destinationIndexPath.item)
        DispatchQueue.main.async(execute: {
            collectionView.reloadData()
        })
    }
    
    var instructionIndexBeingEdited: IndexPath?
    var instructionCellBeingEdited: InstructionsCell?
    var sendButtonTitle: String? {
        didSet {
            guard let sendButtonTitle = sendButtonTitle else {
                return
            }
            inputContainerView.sendButton.setTitle(sendButtonTitle, for: UIControlState())
            
            if (sendButtonTitle == "Edit") {
                inputContainerView.cancelEditButton.isHidden = false
                inputContainerView.editBannerLabel.isHidden = false
            } else {
                inputContainerView.cancelEditButton.isHidden = true
                inputContainerView.editBannerLabel.isHidden = true
            }
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleSend() {
        if (!inputContainerView.inputTextField.text!.isEmpty) {
            
            if (instructionIndexBeingEdited != nil && instructionCellBeingEdited != nil) {
                instructions[(instructionIndexBeingEdited?.item)!] = (instructionCellBeingEdited?.textView.text!)!
                instructionIndexBeingEdited = nil
                instructionCellBeingEdited = nil
                sendButtonTitle = "Add"
                inputContainerView.inputTextField.text = ""
                
                return
            }
            
            instructions.append(inputContainerView.inputTextField.text!)
            inputContainerView.inputTextField.text = ""
        }
    }
    
    func cancelEdit() {
        instructionCellBeingEdited?.textView.text = instructions[(instructionIndexBeingEdited?.item)!]
        
        instructionIndexBeingEdited = nil
        instructionCellBeingEdited = nil
        sendButtonTitle = "Add"
        inputContainerView.inputTextField.text = ""
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        cancelEdit()
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
            return
        }
        
        guard let cell = self.collectionView?.cellForItem(at: selectedIndexPath) else {
            return
        }
        
        cancelEdit()
        
        if (gesture.direction == .left) {
            collectionView?.backgroundView?.addSubview(editButton)
            collectionView?.backgroundView?.addSubview(deleteButton)
            
            deleteButton.anchorWithConstantsToTop(top: nil, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: containerViewRightConstant)
            deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            deleteButton.backgroundColor = .red
            deleteIndexPath = selectedIndexPath
            
            editButton.anchorWithConstantsToTop(top: nil, left: nil, bottom: nil, right: deleteButton.leftAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: containerViewRightConstant)
            editButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            editButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            editButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            editButton.backgroundColor = .lightGray
            instructionIndexBeingEdited = selectedIndexPath
            
            let cellPosition = CGPoint(x: cell.frame.origin.x - 200.0, y: cell.frame.origin.y)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
            }, completion: nil)
        }
        
        if (gesture.direction == .right) {
            
            if (cell.frame.origin.x < (collectionView?.frame.origin.x)!) {
                let cellPosition = CGPoint(x: cell.frame.origin.x + 200.0, y: cell.frame.origin.y)
                deleteIndexPath = nil
                instructionIndexBeingEdited = nil
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
                    self.deleteButton.removeFromSuperview()
                    self.editButton.removeFromSuperview()
                }, completion: nil)
            }
            
        }
    }
    
    func handleEditInstruction() {
        if (instructionIndexBeingEdited != nil) {
            if let cell: InstructionsCell  = collectionView?.cellForItem(at: instructionIndexBeingEdited!) as? InstructionsCell {
                instructionCellBeingEdited = cell
                inputContainerView.inputTextField.text = instructions[(instructionIndexBeingEdited?.item)!]
                sendButtonTitle = "Edit"
                
                if (forceEdit == true) {
                    inputContainerView.inputTextField.becomeFirstResponder()
                    forceEdit = false
                }
                if (cell.frame.origin.x < (collectionView?.frame.origin.x)!) {
                    let cellPosition = CGPoint(x: cell.frame.origin.x + 200.0, y: cell.frame.origin.y)
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
                    }, completion: nil)
                }
            }
        }
    }
    
    var deleteIndexPath: IndexPath?
    func handleDeleteInstruction() {
        guard let deleteIndexPath = deleteIndexPath else {
            return
        }
        
        guard let cell = collectionView?.cellForItem(at: deleteIndexPath) else {
            return
        }
        
        let cellPosition = CGPoint(x: cell.frame.origin.x + 100.0, y: cell.frame.origin.y)
        cell.frame = CGRect(x: cellPosition.x, y: cellPosition.y, width: cell.frame.size.width, height: cell.frame.size.height)
        
        deleteButton.removeFromSuperview()
        instructions.remove(at: deleteIndexPath.item)

        collectionView?.performBatchUpdates({
            
            self.collectionView?.deleteItems(at: NSArray(object: deleteIndexPath) as [AnyObject] as! [IndexPath])
            
        }, completion: {
            (finished: Bool) in
            
            self.collectionView?.reloadItems(at: self.collectionView!.indexPathsForVisibleItems)
            
        })
        self.deleteIndexPath = nil
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    // MARK: - Navigation Handlers
    
    func handleCancel() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleDone() {
        if let parentView: EditRecipeController = parentView as? EditRecipeController {
            parentView.instructions = instructions
            parentView.instructionsCollectionViewReloadData(newHeight: (collectionView?.contentSize.height)! + 10)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

















































import UIKit

class InputContainerView: UIView, UITextFieldDelegate {
    
    weak var parentController: EditInstructionsController? {
        didSet {
            sendButton.addTarget(parentController, action: #selector(EditInstructionsController.handleSend), for: .touchUpInside)
            cancelEditButton.addTarget(parentController, action: #selector(EditInstructionsController.cancelEdit), for: .touchUpInside)
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter instructions..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = BaseTextView.Fonts.smallRegularFont
        textField.delegate = self
        return textField
    }()
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    let sendButton = UIButton(type: .system)
    let cancelEditButton = UIButton(type: .system)
    let editBannerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        sendButton.setTitle("Add", for: UIControlState())
        sendButton.tintColor = ColorPalette.BrandGreen
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelEditButton.setTitle("X", for: UIControlState())
        cancelEditButton.setTitleColor(.red, for: UIControlState())
        cancelEditButton.translatesAutoresizingMaskIntoConstraints = false
        cancelEditButton.isHidden = true
        
        editBannerLabel.text = "Editing instruction..."
        editBannerLabel.textColor = .lightGray
        editBannerLabel.font = UIFont(name: "Lato-Light", size: 12)
        editBannerLabel.translatesAutoresizingMaskIntoConstraints = false
        editBannerLabel.isHidden = true
            
        //what is handleSend?
        
        addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(cancelEditButton)
        //x,y,w,h
        cancelEditButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cancelEditButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cancelEditButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cancelEditButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(editBannerLabel)
        //x,y,w,h
        editBannerLabel.anchorWithConstantsToTop(top: topAnchor, left: inputTextField.leftAnchor, bottom: nil, right: nil, topConstant: 1, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        parentController?.handleSend()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (parentController?.instructionCellBeingEdited != nil && parentController?.instructionIndexBeingEdited != nil) {
            
            let text: NSString = (parentController?.instructionCellBeingEdited?.textView.text ?? "") as NSString
            let resultString = text.replacingCharacters(in: range, with: string)
            parentController?.instructionCellBeingEdited?.textView.text = resultString
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
