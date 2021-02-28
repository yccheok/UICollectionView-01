//
//  ViewController.swift
//  UICollectionView-01
//
//  Created by Cheok Yan Cheng on 27/02/2021.
//

import UIKit

class ViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<NoteSection, PlainNote>
    typealias Snapshot = NSDiffableDataSourceSnapshot<NoteSection, PlainNote>
    
    private static let NOTE_CELL = "NOTE_CELL"
    private static let NOTE_HEADER = "NOTE_HEADER"
    
    private var pinnedNotes: [PlainNote] = Utils.loadAndDecodeJSON(filename: "pinned_plain_note")
    private var normalNotes: [PlainNote] = Utils.loadAndDecodeJSON(filename: "normal_plain_note")
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var layout = Layout.grid
    
    var dataSource: DataSource?

    @IBAction func layoutButtonPressed(_ sender: Any) {
        if layout == .grid {
            layout = .list
        } else {
            layout = .grid
        }
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func pinButtonPressed(_ sender: Any) {
        if normalNotes.isEmpty {
            return
        }
        
        let sourceIndex = Int.random(in: 0..<normalNotes.count)
        let destIndex = Int.random(in: 0...pinnedNotes.count)
        var source = normalNotes[sourceIndex]
        source.pinned = false
        pinnedNotes.insert(source, at: destIndex)
        normalNotes.remove(at: sourceIndex)
        applySnapshot(true)
    }
    
    @IBAction func unpinButtonPressed(_ sender: Any) {
        if pinnedNotes.isEmpty {
            return
        }
        
        let sourceIndex = Int.random(in: 0..<pinnedNotes.count)
        let destIndex = Int.random(in: 0...normalNotes.count)
        var source = pinnedNotes[sourceIndex]
        source.pinned = false
        normalNotes.insert(source, at: destIndex)
        pinnedNotes.remove(at: sourceIndex)
        applySnapshot(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupLayout()
        setupDataSource()
        applySnapshot(false)
    }

    private func setupCollectionView() {
        let noteCellNib = NoteCell.getUINib()
        collectionView.register(noteCellNib, forCellWithReuseIdentifier: ViewController.NOTE_CELL)
        
        let noteHeaderNib = NoteHeader.getUINib()
        collectionView.register(noteHeaderNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ViewController.NOTE_HEADER)
        
        collectionView.delegate = self
    }
    
    private func setupLayout() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    private func setupDataSource() {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] (collectionView, indexPath, plainNote) -> UICollectionViewCell? in
                
                guard let self = self else { return nil }
                
                guard let noteCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ViewController.NOTE_CELL,
                    for: indexPath) as? NoteCell else {
                    return nil
                }
                
                noteCell.setup(plainNote)
                
                noteCell.updateLayout(self.layout)
                
                return noteCell
            }
        )
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) ->
            UICollectionReusableView? in
            
            guard let self = self else { return nil }
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            guard let noteHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ViewController.NOTE_HEADER,
                for: indexPath) as? NoteHeader else {
                return nil
            }
            
            let noteSection = dataSource.snapshot().sectionIdentifiers[indexPath.section]

            noteHeader.setup(noteSection)
            
            return noteHeader
        }
        
        self.dataSource = dataSource
    }
    
    private func applySnapshot(_ animatingDifferences: Bool) {
        var snapshot = Snapshot()
        
        if !pinnedNotes.isEmpty {
            let noteSection = NoteSection.pin
            snapshot.appendSections([noteSection])
            snapshot.appendItems(pinnedNotes, toSection: noteSection)
        }
        
        if !normalNotes.isEmpty {
            let noteSection = NoteSection.normal
            snapshot.appendSections([noteSection])
            snapshot.appendItems(normalNotes, toSection: noteSection)
        }
        
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences) {
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layout {
        case .grid:
            return gridLayout()
        case .list:
            return listLayout(indexPath)
        }
    }
    
    private func gridLayout() -> CGSize {
        let noOfItems = 2
        let itemWidth = UIScreen.main.bounds.width / CGFloat(noOfItems)
        
        return CGSize(
            width: itemWidth,
            height: itemWidth
        )
    }
    
    private func listLayout(_ indexPath: IndexPath) -> CGSize {
        let plainNote: PlainNote
        
        if (indexPath.section == 0) {
            if (!pinnedNotes.isEmpty) {
                plainNote = pinnedNotes[indexPath.item]
            } else {
                precondition(!normalNotes.isEmpty)
                
                plainNote = normalNotes[indexPath.item]
            }
        } else {
            plainNote = normalNotes[indexPath.item]
        }
        
        guard let noteCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ViewController.NOTE_CELL,
            for: indexPath) as? NoteCell else {
            return CGSize(width: 0, height: 0)
        }
        
        noteCell.setup(plainNote)
        
        noteCell.updateLayout(self.layout)
        
        let cgSize = noteCell.systemLayoutSizeFitting(
           CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
           withHorizontalFittingPriority: .required,
           verticalFittingPriority: .fittingSizeLevel
       )
        
        return cgSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if pinnedNotes.isEmpty {
            // Do not show header.
            
            return .init(width: 0, height: 0)
        } else {
            // Calculate the correct height of header.
            
            let noteHeader = NoteHeader.instanceFromNib()
            
            if (section == 0) {
                if (!pinnedNotes.isEmpty) {
                    noteHeader.setup(.pin)
                } else {
                    precondition(!normalNotes.isEmpty)
                    
                    noteHeader.setup(.normal)
                }
            } else {
                noteHeader.setup(.normal)
            }
            
            let cgSize = noteHeader.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            
            return cgSize
        }
    }
}

