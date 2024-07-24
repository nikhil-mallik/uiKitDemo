//
//  FoodItemsTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 18/07/24.
//

import UIKit

class FoodItemsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemBgView: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var priceAmount: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    
    // MARK: - Variable
    var setNotificationTime: Date!
    var foodItem: FoodEntity? {
        didSet {
            itemsConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    // MARK: - UI Setup
    private func configureUI() {
        itemBgView.clipsToBounds = false
        itemBgView.layer.cornerRadius = 15
        itemBgView.backgroundColor = .systemGray6
    }
    
    // MARK: - Configuration
    func itemsConfiguration() {
        guard let foodItem else { return }
        itemName.text = "Item: " + (foodItem.itemName ?? "")
        priceAmount.text = "Price: " + "\(foodItem.priceAmt)"
        quantity.text = "Quantity: " + "\(foodItem.quantities)"
        totalAmount.text = "Total: " + "\(foodItem.totalPrice)"
        orderDate.text = "Order Date: " + getDateOnly(from: foodItem.purchaseDate ?? Date())
        setExpireDateLabel(foodItem.expireDate ?? Date())
        setNotificationTime = foodItem.notificationTime
    }
    
    // MARK: - Expiry Date Handling
    private func setExpireDateLabel(_ expireDateValue: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let expiryDate = calendar.startOfDay(for: expireDateValue)
        let daysToExpiry = calendar.dateComponents([.day], from: today, to: expiryDate).day ?? 0
        
        addPostOneDayBeforeNotifications(calendar: calendar, date: expiryDate)
        
        switch daysToExpiry {
        case 0:
            setExpireDateText("Expire: Today", color: .red)
            postNotifications(date: expiryDate, onDay: "today")
        case 1:
            setExpireDateText("Expire: Tomorrow", color: .orange)
        case 2:
            setExpireDateText("Expires in 2 days", color: .orange)
        case 3:
            setExpireDateText("Expires in 3 days", color: .orange)
        case 4:
            setExpireDateText("Expires in 4 days", color: .orange)
        case ..<0:
            setExpireDateText("Item is Expired", color: .red)
        default:
            setExpireDateText("Expires on: " + getDateOnly(from: expiryDate), color: .black)
        }
    }
    
    // MARK: - Helper Method to Set Expiry Date Label Text and Color
    private func setExpireDateText(_ text: String, color: UIColor) {
        expireDate.text = text
        expireDate.textColor = color
    }
    
    func addPostOneDayBeforeNotifications(calendar: Calendar, date: Date) {
        if let oneDayBefore = calendar.date(byAdding: .day, value: -1, to: date) {
            postNotifications(date: oneDayBefore, onDay: "tomorrow")
        }
    }
    
    // MARK: - Notification Posting
    func postNotifications(date: Date, onDay day: String) {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: foodItem!.notificationTime!)
        let minutes = calendar.component(.minute, from: foodItem!.notificationTime!)
        let repeating = day == "today" ? false : true
        NotificationCenter.default.post(name: .sendNotification, object: nil, userInfo: [
            "title": foodItem!.categoryName ?? "" ,
            "body": "\(foodItem!.itemName ?? "") is going to expire \(day)",
            "hours": hours,
            "minutes": minutes,
            "date" : date,
            "isDaily": repeating
        ])
    }
    
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
