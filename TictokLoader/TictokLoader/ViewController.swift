//
//  ViewController.swift
//  TictokLoader
//
//  Created by Darren Nguyen on 22/09/2022.
//

import UIKit
import AVKit
import GSPlayer
class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let videos = [
        "https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
        "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
    ]
    @objc dynamic var currentIndex = 0
    var oldAndNewIndices = (0,0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        AVPlayer(playerItem: AVPlayerItem?)
//        AVPlayerItem(url: URL(string: ""))
        VideoPreloadManager.shared.set(waiting: videos.compactMap({URL(string: $0)!}))
        VideoPreloadManager.shared.didStart = {
            print("----")
        }
        VideoPreloadManager.shared.didFinish = { er in
            print("+++")
        }
        collectionView.register(UINib(nibName: "DisplayVideoCell", bundle: nil), forCellWithReuseIdentifier: "DisplayVideoCell")
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print(indexPaths)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? DisplayVideoCell {
            cell.pause()
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? DisplayVideoCell {
            cell.configure(url: videos[indexPath.row])
        }

    }
}
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayVideoCell", for: indexPath) as? DisplayVideoCell else {
            fatalError()
        }
        cell.replay()
        return cell
    }
    
    
}

// MARK: - ScrollView Extension
extension ViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = targetContentOffset.pointee
        let index = collectionView.indexPathForItem(at: point)
        collectionView.indexPathsForVisibleItems.forEach({ ip in
            if let cell = collectionView.cellForItem(at: ip) as? DisplayVideoCell,
               let index = collectionView.indexPathForItem(at: point),
                ip.row != index.row
               {
                cell.pause()
            }
        })
        print(collectionView.indexPathsForVisibleItems)
        print(index)
    }
}
