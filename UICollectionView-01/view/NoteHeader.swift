//
//  NoteHeader.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 28/02/2021.
//

import UIKit

class NoteHeader: UICollectionReusableView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet var labelZeroHeightConstraint: NSLayoutConstraint!
    
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
    }
    
    func show() {
        labelZeroHeightConstraint.isActive = false
    }
    
}
