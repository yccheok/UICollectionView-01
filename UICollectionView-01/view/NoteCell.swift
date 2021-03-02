//
//  NoteCell.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 28/02/2021.
//

import UIKit

class NoteCell: UICollectionViewCell {

    private static let padding = CGFloat(8.0)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet var bodyLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabelZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bodyLabelZeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabelAndBodyLabelConstraint: NSLayoutConstraint!
    
    var layout: Layout?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabelZeroHeightConstraint.isActive = false
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
        case .grid:
            updateGridLayout()
        case .compactGrid:
            updateCompactGridLayout()
        case .list:
            updateListLayout()
        case .compactList:
            updateCompactListLayout()
        }
        
        self.layout = layout
    }
    
    private func updateGridLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        
        bodyLabelBottomConstraint.isActive = false
        bodyLabel.numberOfLines = 0
        
        if isTitleLabelEmpty {
            titleLabel.isHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabel.isHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        if isBodyLabelEmpty {
            bodyLabel.isHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabel.isHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }
        
        if titleLabel.isHidden || bodyLabel.isHidden {
            titleLabelAndBodyLabelConstraint.constant = 0
        } else {
            titleLabelAndBodyLabelConstraint.constant = NoteCell.padding
        }
    }
    
    private func updateCompactGridLayout() {
        updateGridLayout()
    }
    
    private func updateListLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        
        bodyLabelBottomConstraint.isActive = true
        bodyLabel.numberOfLines = 0

        if isTitleLabelEmpty {
            titleLabel.isHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabel.isHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        if isBodyLabelEmpty {
            bodyLabel.isHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabel.isHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }

        if titleLabel.isHidden || bodyLabel.isHidden {
            titleLabelAndBodyLabelConstraint.constant = 0
        } else {
            titleLabelAndBodyLabelConstraint.constant = NoteCell.padding
        }
    }
    
    private func updateCompactListLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        
        bodyLabelBottomConstraint.isActive = true
        bodyLabel.numberOfLines = 0

        if isTitleLabelEmpty {
            titleLabel.isHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabel.isHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        // In compact list, only either title or body can be shown.
        if isBodyLabelEmpty || !titleLabel.isHidden {
            bodyLabel.isHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabel.isHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }

        if titleLabel.isHidden || bodyLabel.isHidden {
            titleLabelAndBodyLabelConstraint.constant = 0
        } else {
            titleLabelAndBodyLabelConstraint.constant = NoteCell.padding
        }
    }
}
