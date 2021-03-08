# UICollectionView-01

Currently, we're implementing a collection view, which enables user to change layout during runtime (Tapping on "layout" button). There're 4 layouts being supported

- Grid layout
- Compact grid layout
- List layout
- Compact list layout

There are 2 sections in the collection view - pinned section & normal section. User can move the note around, by tapping "Pin" and "UnPin" button. Animation will be played.

The animation is performed automatically via Apple's own diffable data source framework.

Master branch
=============
All the 4 layouts are implemented using `UICollectionViewFlowLayout`. However, such implementation are buggy, when comes with "List layout" and "Compact list layout". When user performs "Pin" and "UnPin", we can notice the performed animation is pretty strange.

Usually, it will comes with the following warnings

```
2021-03-09 00:43:56.867387+0800 UICollectionView-01[3236:91509] [Snapshotting] Snapshotting a view (0x7fa5431b3a80, UICollectionView_01.NoteCell) that has not been rendered at least once requires afterScreenUpdates:YES.
```


horizontal-stackview branch
===========================

This branch is used to overcome the animation bug encountered in Master branch.

For Grid layout and Compact grid layout, we are using `UICollectionViewFlowLayout`.

For List layout and Compact list layout, we are using `UICollectionViewCompositionalLayout`.

This able to "solve" the animation bug encountered in Master branch. However, it doesn't come with additional problem.

1. We have no idea how to hide the header in `UICollectionViewCompositionalLayout`. In `UICollectionViewFlowLayout`, we can hide the header using the following function.

```
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
            
            let cgSize = noteHeader.systemLayoutSizeFitting(
                CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            
            return cgSize
        }
    }
```

2. When we perform switch from `UICollectionViewCompositionalLayout` to `UICollectionViewFlowLayout`, the scroll position of collection view changed! We expect the scroll position of collection view unchanged, when we are switching to different layout.
