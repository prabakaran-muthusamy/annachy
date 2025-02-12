//
//  HomeCollectionViewCell.swift
//  Annachy
//
//  Created by Prabakaran Muthusamy on 12/02/25.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private weak var baseView: UIView!
    private weak var productImageView: UIImageView!
    private weak var productNameLabel: UILabel!
    private weak var productPriceLabel: UILabel!
    private weak var categoryLabel: UILabel!
    private weak var ratingStackView: UIStackView!
    private weak var addToCartButton: UIButton!
    
    private var isGridView: Bool = true
    
    private var hasSetupConstraints: Bool = false
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with product: ProductModel, isGridView: Bool) {
        self.isGridView = isGridView
        productNameLabel.text = product.title
        productPriceLabel.text = "₹\(product.price)"
        categoryLabel.text = product.category.capitalized
        
        if let url = URL(string: product.image) {
            productImageView.kf.setImage(with: url)
            productImageView.kf.indicatorType = .activity
        }
        
        updateStarRating(product.rating.rate)
        
        hasSetupConstraints = false
        baseView.removeConstraints(baseView.constraints)
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Private Methods
    
    private func createRatingStars() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .lightGray
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            starImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
            stackView.addArrangedSubview(starImageView)
        }
        
        return stackView
    }
    
    private func updateStarRating(_ rating: Double) {
        for (index, star) in ratingStackView.arrangedSubviews.enumerated() {
            if let starImageView = star as? UIImageView {
                starImageView.tintColor = index < Int(rating) ? .systemYellow : .lightGray
            }
        }
    }
    
    // MARK: - UI and Constraints methods
    
    private func setupViews() {
        contentView.backgroundColor = .white
        
        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.backgroundColor = .white
        baseView.layer.cornerRadius = 8
        baseView.layer.masksToBounds = true
        baseView.layer.borderWidth = 0.5
        baseView.layer.borderColor = UIColor.lightGray.cgColor
        
        let productImageView = UIImageView()
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        
        let productNameLabel = UILabel()
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.textAlignment = .center
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        productNameLabel.textColor = .black
        productNameLabel.numberOfLines = 2
        
        let productPriceLabel = UILabel()
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.textAlignment = .center
        productPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        productPriceLabel.textColor = .darkGray
        
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont.systemFont(ofSize: 13)
        categoryLabel.textColor = .gray
        
        let ratingStackView = createRatingStars()
        
        let addToCartButton = UIButton(type: .custom)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.setTitle("Add to Cart", for: .normal)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = UIColor.appThemeColor
        addToCartButton.layer.cornerRadius = 5
        addToCartButton.clipsToBounds = true
        
        contentView.addSubview(baseView)
        baseView.addSubview(productImageView)
        baseView.addSubview(productNameLabel)
        baseView.addSubview(categoryLabel)
        baseView.addSubview(productPriceLabel)
        baseView.addSubview(ratingStackView)
        baseView.addSubview(addToCartButton)
        
        self.baseView = baseView
        self.productImageView = productImageView
        self.productNameLabel = productNameLabel
        self.productPriceLabel = productPriceLabel
        self.categoryLabel = categoryLabel
        self.ratingStackView = ratingStackView
        self.addToCartButton = addToCartButton
    }
    
    private func setupConstraints() {
        
        if isGridView {
            NSLayoutConstraint.activate([
                baseView.topAnchor.constraint(equalTo: contentView.topAnchor),
                baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                productImageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 10),
                productImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
                productImageView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
                productImageView.heightAnchor.constraint(equalToConstant: 90),
                
                productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 10),
                productNameLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 12),
                productNameLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
                productPriceLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 12),
                productPriceLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                categoryLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 10),
                categoryLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 12),
                categoryLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                ratingStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
                ratingStackView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
                ratingStackView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -8),
                ratingStackView.heightAnchor.constraint(equalToConstant: 15),
                
                addToCartButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10),
                addToCartButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                addToCartButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -12),
                addToCartButton.heightAnchor.constraint(equalToConstant: 30)])
        } else {
            NSLayoutConstraint.activate([
                baseView.topAnchor.constraint(equalTo: contentView.topAnchor),
                baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                productImageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 10),
                productImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 12),
                productImageView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -12),
                productImageView.widthAnchor.constraint(lessThanOrEqualTo: baseView.widthAnchor, multiplier: 0.4),
                
                productNameLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 12),
                productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
                productNameLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
                productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
                productPriceLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                categoryLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 10),
                categoryLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
                categoryLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -12),
                
                ratingStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 10),
                ratingStackView.centerXAnchor.constraint(equalTo: addToCartButton.centerXAnchor),
                ratingStackView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -12),
                ratingStackView.heightAnchor.constraint(equalToConstant: 15),
                
                addToCartButton.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
                addToCartButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
                addToCartButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -12),
                addToCartButton.heightAnchor.constraint(equalToConstant: 30)])
        }
    }

    override func updateConstraints() {
        if !hasSetupConstraints {
            setupConstraints()
            hasSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
