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
    @IBOutlet var bodyLabelGreaterThanBottomConstraint: NSLayoutConstraint!
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
        var titleLabelIsHidden = false
        var bodyLabelIsHidden = false
        
        bodyLabelBottomConstraint.isActive = false
        bodyLabelGreaterThanBottomConstraint.isActive = true
        bodyLabel.numberOfLines = 0
        
        if isTitleLabelEmpty {
            titleLabelIsHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabelIsHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        if isBodyLabelEmpty {
            bodyLabelIsHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabelIsHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }
        
        if titleLabelIsHidden || bodyLabelIsHidden {
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
        var titleLabelIsHidden = false
        var bodyLabelIsHidden = false
        
        bodyLabelBottomConstraint.isActive = true
        bodyLabelGreaterThanBottomConstraint.isActive = false
        bodyLabel.numberOfLines = 0

        if isTitleLabelEmpty {
            titleLabelIsHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabelIsHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        if isBodyLabelEmpty {
            bodyLabelIsHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabelIsHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }

        if titleLabelIsHidden || bodyLabelIsHidden {
            titleLabelAndBodyLabelConstraint.constant = 0
        } else {
            titleLabelAndBodyLabelConstraint.constant = NoteCell.padding
        }
    }
    
    private func updateCompactListLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        var titleLabelIsHidden = false
        var bodyLabelIsHidden = false
        
        bodyLabelBottomConstraint.isActive = true
        bodyLabelGreaterThanBottomConstraint.isActive = false
        bodyLabel.numberOfLines = 0

        if isTitleLabelEmpty {
            titleLabelIsHidden = true
            titleLabelZeroHeightConstraint.isActive = true
        } else {
            titleLabelIsHidden = false
            titleLabelZeroHeightConstraint.isActive = false
        }
        
        // In compact list, only either title or body can be shown.
        if isBodyLabelEmpty || !titleLabelIsHidden {
            bodyLabelIsHidden = true
            bodyLabelZeroHeightConstraint.isActive = true
        } else {
            bodyLabelIsHidden = false
            bodyLabelZeroHeightConstraint.isActive = false
        }

        if titleLabelIsHidden || bodyLabelIsHidden {
            titleLabelAndBodyLabelConstraint.constant = 0
        } else {
            titleLabelAndBodyLabelConstraint.constant = NoteCell.padding
        }
    }
}
