//
//  NoteHeader.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 28/02/2021.
//

import UIKit

class NoteHeader: UICollectionReusableView {
    private static let padding = CGFloat(8.0)
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var labelZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet var bottomPaddingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ noteSection: NoteSection) {
        switch noteSection {
        case .normal:
            label.text = "Normal"
        case .pin:
            label.text = "Pinned"
        }
    }
    
    func hide() {
        labelZeroHeightConstraint.isActive = true
        topPaddingConstraint.constant = 0
        bottomPaddingConstraint.constant = 0
    }
    
    func show() {
        labelZeroHeightConstraint.isActive = false
        topPaddingConstraint.constant = NoteHeader.padding
        bottomPaddingConstraint.constant = NoteHeader.padding
    }
    
}
