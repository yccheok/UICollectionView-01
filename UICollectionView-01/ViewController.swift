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
    
    private static let padding = CGFloat(8.0)
    private static let minListHeight = CGFloat(44.0)
    
    private static let NOTE_CELL = "NOTE_CELL"
    private static let NOTE_HEADER = "NOTE_HEADER"
    
    private var pinnedNotes: [PlainNote] = Utils.loadAndDecodeJSON(filename: "pinned_plain_note")
    private var normalNotes: [PlainNote] = Utils.loadAndDecodeJSON(filename: "normal_plain_note")
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var layout = Layout.grid
    
    var dataSource: DataSource?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.reloadData()
    }
    
    @IBAction func layoutButtonPressed(_ sender: Any) {
        layout = layout.next()
        
        setupLayout()
        
        // We call reloadData instead of collectionView.collectionViewLayout.invalidateLayout(). We need to ensure
        // updateLayout is executed within setupDataSource.
        collectionView.reloadData()
    }
    
    @IBAction func pinButtonPressed(_ sender: Any) {
        if normalNotes.isEmpty {
            return
        }
        
        let sourceIndex = Int.random(in: 0..<normalNotes.count)
        let destIndex = Int.random(in: 0...pinnedNotes.count)
        var source = normalNotes[sourceIndex]
        source.pinned = true
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
        switch layout {
        case .grid:
            return setupGridLayout()
        case .compactGrid:
            return setupCompactGridLayout()
        case .list:
            return setupListLayout()
        case .compactList:
            return setupCompactListLayout()
        }
    }
    
    private func setupGridLayout(_ itemCountPerRow: Int) {
        let fraction: CGFloat = 1 / CGFloat(itemCountPerRow)
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: ViewController.padding/2, leading: 0, bottom: ViewController.padding/2, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCountPerRow)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: ViewController.padding, leading: ViewController.padding, bottom: ViewController.padding, trailing: ViewController.padding)
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)

        // Switch the layout to UICollectionViewCompositionalLayout
        collectionView.collectionViewLayout = compositionalLayout
    }
    
    private func setupGridLayout() {
        if UIWindow.isPortrait {
            setupGridLayout(2)
        } else {
            setupGridLayout(3)
        }
    }
    
    private func setupCompactGridLayout() {
        if UIWindow.isPortrait {
            setupGridLayout(3)
        } else {
            setupGridLayout(4)
        }
    }
    
    private func setupListLayout() {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: ViewController.padding, leading: ViewController.padding, bottom: ViewController.padding, trailing: ViewController.padding)
        section.interGroupSpacing = ViewController.padding
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)

        // Switch the layout to UICollectionViewCompositionalLayout
        collectionView.collectionViewLayout = compositionalLayout
    }
    
    private func setupCompactListLayout() {
        setupListLayout()
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
            
            if self.pinnedNotes.isEmpty {
                noteHeader.hide()
            } else {
                noteHeader.show()
            }
            
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
        
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
            guard let self = self else { return }
            // As a workaround to update Pin icon.
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        precondition(layout == .grid || layout == .compactGrid)
        
        switch layout {
        case .grid:
            return gridLayout()
        case .compactGrid:
            return compactGridLayout()
        default:
            return .zero
        }
    }
    
    private func gridLayout(_ count: Int) -> CGSize {
        let noOfItems: CGFloat = CGFloat(count)
        let itemWidth = (collectionView.frame.width - ViewController.padding*2.0 - ViewController.padding*(noOfItems-1.0)) / CGFloat(noOfItems)
        
        return CGSize(
            width: itemWidth,
            height: itemWidth
        )
    }
    
    private func gridLayout() -> CGSize {
        if UIWindow.isPortrait {
            return gridLayout(2)
        } else {
            return gridLayout(3)
        }
    }
    
    private func compactGridLayout() -> CGSize {
        if UIWindow.isPortrait {
            return gridLayout(3)
        } else {
            return gridLayout(4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        precondition(layout == .grid || layout == .compactGrid)
        
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

            // Always show.
            noteHeader.show()
            
            let cgSize = noteHeader.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            
            return cgSize
        }
    }
}

