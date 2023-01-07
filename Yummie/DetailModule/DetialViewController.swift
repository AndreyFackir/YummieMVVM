//
//  DetialViewController.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 31.10.2022.
//

import UIKit
import SnapKit
import ProgressHUD
import Combine

final class DetialViewController: UIViewController {
  var detailViewModel: DetailViewModel
  private var subscriptions: Set<AnyCancellable> = []
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    showDetail()
  }
  
  init(detailViewModel: DetailViewModel) {
    self.detailViewModel = detailViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  private lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    scroll.keyboardDismissMode = .interactive
    return scroll
  }()
  
  private lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let detailImage: UIImageView = {
    let element = UIImageView()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.contentMode = .scaleAspectFill
    element.layer.masksToBounds = true
    return element
  }()
  
  private var horizontalStack = UIStackView()
  
  private let dishLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.numberOfLines = 0
    return element
  }()
  
  private let dishCalories: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.textColor = .red
    return element
  }()
  
  private let descriptionDishesLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.numberOfLines = 0
    element.textColor = .systemGray
    return element
  }()
  
  private let nameTextField: UITextField = {
    let element = UITextField()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.backgroundColor = .specialBackground
    element.layer.cornerRadius = 10
    element.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: element.frame.height))
    element.leftViewMode = .always
    element.clearButtonMode = .always
    element.returnKeyType = .done
    element.placeholder = "Enter your name"
    return element
  }()
  
  private let addToChartButton: UIButton = {
    let element = UIButton()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.setTitle("Add to Chart", for: .normal)
    element.setTitleColor(.white, for: .normal)
    element.addTarget(self, action: #selector(addToChartButtonTapped), for: .touchUpInside)
    element.layer.cornerRadius = 10
    element.backgroundColor = .blue
    element.addShadowOnView()
    return element
  }()
  
  // MARK: - Methods
  
  @objc private func addToChartButtonTapped() {
    guard let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
      ProgressHUD.showError("Please, enter your name")
      return
    }
    ProgressHUD.show("Placing order...")
    detailViewModel.placeDiffOrders(name: name)
  }
  
  private func showDetail() {
    detailViewModel.dish == nil ? showDetailCategoryDishes() : showDetailDishes()
  }
  
  private func showDetailDishes() {
    dishLabel.text = detailViewModel.dish?.name
    dishCalories.text = "\(detailViewModel.dish?.calories ?? 0) kCal"
    descriptionDishesLabel.text = detailViewModel.dish?.description
    guard let imageUrl = detailViewModel.dish?.image else { return }
    detailImage.loadImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { image in
        self.detailImage.image = image
      }
      .store(in: &subscriptions)
  }
  
  private func showDetailCategoryDishes() {
    dishLabel.text = detailViewModel.datum?.name
    dishCalories.text = "\(detailViewModel.datum?.calories ?? 0) kCal"
    descriptionDishesLabel.text = detailViewModel.datum?.description
    guard let imageUrl = detailViewModel.datum?.image else { return }
    detailImage.loadImage(url: imageUrl)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        
      } receiveValue: { image in
        self.detailImage.image = image
      }
      .store(in: &subscriptions)
  }
}

// MARK: - Setup

private extension DetialViewController {
  func setup() {
    registerForKeyboardNotificaion()
    setupViews()
    setConstraints()
    tapGesture()
    nameTextField.delegate = self
  }
  
  func tapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
    scrollView.addGestureRecognizer(tapGesture)
  }
  
  @objc func hideKeyBoard() {
    nameTextField.resignFirstResponder()
    removeForKeyboardNotificaion()
  }
  
  func setupViews() {
    view.addSubview(scrollView)
    view.backgroundColor = .white
    scrollView.addSubview(containerView)
    containerView.addSubview(detailImage)
    horizontalStack = UIStackView(arrangedSubviews: [dishLabel, dishCalories], axis: .horizontal, spacing: 10)
    horizontalStack.distribution = .equalSpacing
    containerView.addSubview(horizontalStack)
    containerView.addSubview(descriptionDishesLabel)
    containerView.addSubview(addToChartButton)
    containerView.addSubview(nameTextField)
  }
  
  func setConstraints() {
    scrollView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalToSuperview()
    }
    containerView.snp.makeConstraints { make in
      make.top.leading.trailing.bottom.equalTo(scrollView)
      make.width.equalTo(scrollView.snp.width)
      make.height.equalTo(scrollView.snp.height)
    }
    detailImage.snp.makeConstraints { make in
      make.top.equalTo(containerView).inset(-100)
      make.height.equalTo(containerView.snp.width)
      make.width.equalTo(containerView.snp.width)
    }
    horizontalStack.snp.makeConstraints { make in
      make.top.equalTo(detailImage.snp.bottom).inset(-10)
      make.leading.trailing.equalToSuperview().inset(10)
    }
    descriptionDishesLabel.snp.makeConstraints { make in
      make.top.equalTo(horizontalStack.snp_bottomMargin).inset(-10)
      make.leading.trailing.equalToSuperview().inset(10)
    }
    nameTextField.snp.makeConstraints { make in
      make.top.equalTo(descriptionDishesLabel.snp_bottomMargin).inset(-30)
      make.centerX.equalTo(containerView.snp.centerX)
      make.width.equalTo(containerView.snp.width).multipliedBy(0.6)
      make.height.equalTo(containerView.snp.width).multipliedBy(0.1)
    }
    addToChartButton.snp.makeConstraints { make in
      make.top.equalTo(nameTextField.snp_bottomMargin).inset(-30)
      make.centerX.equalTo(containerView.snp.centerX)
      make.width.equalTo(containerView.snp.width).multipliedBy(0.6)
      make.height.equalTo(containerView.snp.width).multipliedBy(0.1)
    }
  }
  
  func registerForKeyboardNotificaion() {
    
    //обсервер когда клава появляется
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    //обсервер когда клава исчезает
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func removeForKeyboardNotificaion() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  //если клава появилась двигаем  наверх
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= keyboardSize.height / 2
      }
    }
  }
  
  //есди спряталась - возвращаем на место
  @objc func keyboardWillHide() {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }
}
// MARK: - UITextFieldDelegate
extension DetialViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    nameTextField.resignFirstResponder()
  }
}
