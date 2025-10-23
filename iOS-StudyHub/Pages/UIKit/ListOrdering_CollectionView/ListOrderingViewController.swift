//
//  ListOrderingViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 7/25/25.
//

import UIKit
import SnapKit

class ListOrderingViewController: UIViewController {
    
    var cellModels: [ListCellModel] = [.init(isImmutable: true, name: "순서 변경 불가 셀"),
                                       .init(name: "순서 변경 가능 셀1"),
                                       .init(name: "순서 변경 가능 셀2"),
                                       .init(name: "순서 변경 가능 셀3"),
                                       .init(name: "순서 변경 가능 셀4 셀 높이 테스트 셀 높이 테스트"),
                                       .init(name: "순서 변경 가능 셀5"),
                                       .init(name: "순서 변경 가능 셀6"),
                                       .init(name: "순서 변경 가능 셀7")]

    private var listCollectionView = {
        let layout = UICollectionViewFlowLayout().do {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 10
        }
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.listCollectionView.reloadData()
    }
    
    private func setupUI() {
        self.view.do { superView in
            superView.backgroundColor = .white
            
            self.listCollectionView.do {
                $0.delegate = self
                $0.dataSource = self
                $0.dragDelegate = self
                $0.dropDelegate = self
                $0.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
                    $0.leading.trailing.equalToSuperview()
                }
            }
        }
    }
}

extension ListOrderingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        cell.displayCell(cellModel: self.cellModels[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.cellModels.count
    }
}

extension ListOrderingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        let estimatedHeight: CGFloat = 200
        
        let dummyCell = ListCell(frame: .init(x: 0, y: 0, width: width, height: estimatedHeight))
        dummyCell.displayCell(cellModel: self.cellModels[indexPath.row])
        dummyCell.layoutIfNeeded()
        
        let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: width, height: estimatedHeight))
        
        return CGSize(width: width, height: estimatedSize.height)
    }
}

extension ListOrderingViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard !self.cellModels[indexPath.row].isImmutable else {
            return []
        }
        
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCell else {
            return nil
        }
        
        let parameters = UIDragPreviewParameters()
        // 카드 컨테이너 영역만 프리뷰로 표시 (둥근 모서리 적용)
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentsContainerFrame, cornerRadius: 16)
        parameters.backgroundColor = UIColor.clear  // 배경색 투명
        return parameters
    }
}

extension ListOrderingViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ListCell else {
            return nil
        }
        
        let parameters = UIDragPreviewParameters()
        // 카드 컨테이너 영역만 프리뷰로 표시 (둥근 모서리 적용)
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentsContainerFrame, cornerRadius: 16)
        parameters.backgroundColor = UIColor.clear  // 배경색 투명
        return parameters
    }
    
    /// 드래그 하는 동안 호출되는 함수
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard collectionView.hasActiveDrag else { return UICollectionViewDropProposal(operation: .forbidden) }
        
        guard let destinationIndexPath = destinationIndexPath else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        
        guard !self.cellModels[destinationIndexPath.row].isImmutable else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
        guard let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath else { return }
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        collectionView.performBatchUpdates ({
            let sourceItem = self.cellModels.remove(at: sourceIndexPath.row)
            self.cellModels.insert(sourceItem, at: destinationIndexPath.row)
            collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        })
    }
}
