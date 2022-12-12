//
//  TitleSupplementaryView.swift
//  Yummie
//
//  Created by Андрей Яфаркин on 28.10.2022.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
  
  // MARK: - View Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  let headerLabel: UILabel = {
    let element = UILabel()
    element.translatesAutoresizingMaskIntoConstraints = false
    element.adjustsFontForContentSizeCategory = true
    element.font = UIFont.preferredFont(forTextStyle: .title1)
    element.textColor = .black
    element.backgroundColor = .specialBackground
    return element
  }()
}

// MARK: - Setup
private extension TitleSupplementaryView {
  func setup() {
    setupViews()
    setConstraints()
  }
  
  func setupViews() {
    addSubview(headerLabel)
  }
  
  func setConstraints() {
    headerLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(10)
    }
  }
}
