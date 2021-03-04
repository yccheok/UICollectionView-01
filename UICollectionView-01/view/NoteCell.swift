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
    
    @IBOutlet var bottomStackView: UIStackView!
    @IBOutlet var labelLabel: UILabel!
    @IBOutlet var reminderLabel: UILabel!
    
    var layout: Layout?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setup(_ plainNote: PlainNote) {
        titleLabel.text = plainNote.title
        bodyLabel.text = plainNote.body

        // TODO:
        labelLabel.text = nil
        reminderLabel.text = nil
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
        let isLabelLabelEmpty = String.isNullOrEmpty(labelLabel.text)
        let isReminderLabelEmpty = String.isNullOrEmpty(reminderLabel.text)
        
        titleLabel.setContentHuggingPriority(.init(999), for: .vertical)
        bodyLabel.setContentHuggingPriority(.init(999), for: .vertical)
        
        if isTitleLabelEmpty {
            titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
        }
        
        if isBodyLabelEmpty {
            bodyLabel.isHidden = true
        } else {
            bodyLabel.isHidden = false
        }
        
        bottomStackView.isHidden = false
    }
    
    private func updateCompactGridLayout() {
        updateGridLayout()
    }
    
    private func updateListLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        let isLabelLabelEmpty = String.isNullOrEmpty(labelLabel.text)
        let isReminderLabelEmpty = String.isNullOrEmpty(reminderLabel.text)
        
        titleLabel.setContentHuggingPriority(.init(251), for: .vertical)
        bodyLabel.setContentHuggingPriority(.init(251), for: .vertical)
        
        if isTitleLabelEmpty {
            titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
        }
        
        if isBodyLabelEmpty {
            bodyLabel.isHidden = true
        } else {
            bodyLabel.isHidden = false
        }
        
        if isLabelLabelEmpty && isReminderLabelEmpty {
            bottomStackView.isHidden = true
        } else {
            bottomStackView.isHidden = false
        }
        
        // In list view, we can't hide everything. Something has to be shown.
        if titleLabel.isHidden && bodyLabel.isHidden && bottomStackView.isHidden {
            bodyLabel.isHidden = false
        }
    }
    
    private func updateCompactListLayout() {
        let isTitleLabelEmpty = String.isNullOrEmpty(titleLabel.text)
        let isBodyLabelEmpty = String.isNullOrEmpty(bodyLabel.text)
        let isLabelLabelEmpty = String.isNullOrEmpty(labelLabel.text)
        let isReminderLabelEmpty = String.isNullOrEmpty(reminderLabel.text)
        
        titleLabel.setContentHuggingPriority(.init(251), for: .vertical)
        bodyLabel.setContentHuggingPriority(.init(251), for: .vertical)
        
        if isTitleLabelEmpty {
            titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
        }
        
        // We show either title or body, in compact list.
        if isBodyLabelEmpty || !titleLabel.isHidden {
            bodyLabel.isHidden = true
        } else {
            bodyLabel.isHidden = false
        }
        
        if isLabelLabelEmpty && isReminderLabelEmpty {
            bottomStackView.isHidden = true
        } else {
            bottomStackView.isHidden = false
        }
        
        // In list view, we can't hide everything. Something has to be shown.
        if titleLabel.isHidden && bodyLabel.isHidden && bottomStackView.isHidden {
            bodyLabel.isHidden = false
        }
    }
}
