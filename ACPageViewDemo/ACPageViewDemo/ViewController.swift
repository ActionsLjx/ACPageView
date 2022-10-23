//
//  ViewController.swift
//  ACPageViewDemo
//
//  Created by ljx on 2022/10/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pageview = ACPageView.init(frame: CGRect.init(x: 0, y: 58, width: self.view.bounds.width, height: self.view.bounds.height - 58))
        self.view.addSubview(pageview)
        pageview.delegate = self
        pageview.configTitles(titles: ["标题一","标题二","标题三","标题四"], showType: .equal, titleHeight: 40)
        // Do any additional setup after loading the view.
    }


}


extension ViewController: ACPageViewDelegate {
    func ACPageViewPagesCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACPageViewDefaultCellID, for: indexPath)
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.red
        }else{
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
}
