//
//  NoteCell.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 28/02/2021.
//

import UIKit

class NoteCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var bodyLabelZeroHeightConstraint: NSLayoutConstraint!
    
    var layout: Layout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bodyLabelZeroHeightConstraint.isActive = false
    }

    func setup(_ plainNote: PlainNote) {
        titleLabel.text = plainNote.title
        bodyLabel.text = plainNote.body
    }
    
    func updateLayout(_ layout: Layout) {
        if self.layout == layout {
            return
        }
        
        switch layout {
        case Layout.grid:
            bottomConstraint.isActive = false
            bodyLabel.numberOfLines = 0
            
            bodyLabelZeroHeightConstraint.isActive = false
        case Layout.list:
            bottomConstraint.isActive = true
            bodyLabel.numberOfLines = 0
            
            if String.isNullOrEmpty(bodyLabel.text) {
                bodyLabelZeroHeightConstraint.isActive = true
            } else {
                bodyLabelZeroHeightConstraint.isActive = false
            }
        }
        
        self.layout = layout
    }
}
