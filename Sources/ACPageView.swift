//
//  ACPageView.swift
//  ACPageViewDemo
//
//  Created by lAC on 2022/10/22.
//

import UIKit

let ACScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ACScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let ACPageViewDefaultCellID = "ACPageViewDefaultCellID"
enum ACTitleShowType{
    case equal //固定不滑动 均分
    case auto // 可滑n多个
}

class ACPageView: UIView {
    
    lazy private var pagesTitleCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let view = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(UINib.init(nibName: "ACPageTitleCell", bundle: nil), forCellWithReuseIdentifier: ACPageTitleCellID)
        return view
    }()
    
    lazy private var sliderLine:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 1))
        view.backgroundColor = UIColor.red
        return view
    }()
    
    lazy private var pagesCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let view = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ACPageViewDefaultCellID)
        return view
    }()
    
    private var titles:[String] = []
    private var canScroll:Bool = false
    private var titleBarShowType:ACTitleShowType = .equal
    
    //当前页面id
    private var _selectId = 0
    private var selectId:Int {
        set {
            let oldIndexPath = IndexPath(row: _selectId, section: 0)
            let selectIndexPath = IndexPath(row: newValue, section: 0)
            _selectId = newValue
            UIView.performWithoutAnimation {
                self.pagesTitleCollectionView.reloadItems(at: [oldIndexPath,selectIndexPath])
            }
        }
        get {
            return _selectId
        }
    }
    
    //是否是点击title切换页面
    private var isClickedScoll:Bool = false
    
    //滑块相关
    private var lineDefaultCenterX:CGFloat = 0
    private var lineAbleScrollWidth:CGFloat = ACScreenWidth
    
    var lineWidth:CGFloat = 10
    var lineHeight:CGFloat = 1
    var lineColor:UIColor = UIColor.black
    var lineCornerRadius:CGFloat = 0
    //pages 代理
    var delegate:ACPageViewDelegate?
    
    //标题样式
    var defaultTitleColor:UIColor = UIColor.black
    var defaultTitleBgColor:UIColor = UIColor.white
    var defaultTitleFont:UIFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    var selectTitleColor:UIColor = UIColor.black
    var selectTitleBgColor:UIColor = UIColor.white
    var selectTitleFont:UIFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromUI(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialFromUI(frame:CGRect) {
        self.addSubview(self.pagesTitleCollectionView)
        self.pagesTitleCollectionView.addSubview(self.sliderLine)
        self.addSubview(self.pagesCollectionView)
        self.pagesTitleCollectionView.delegate = self
        self.pagesTitleCollectionView.dataSource = self
        
        self.pagesCollectionView.delegate = self
        self.pagesCollectionView.dataSource = self
        self.pagesCollectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    
    override func layoutSubviews() {
       
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
            if ("contentOffset" == keyPath) {
                let progress = pagesCollectionView.contentOffset.x / CGFloat(self.titles.count - 1) / ACScreenWidth

                let lineCenterX = lineDefaultCenterX + progress * lineAbleScrollWidth
                self.sliderLine.center.x = lineCenterX
                if(isClickedScoll){
                    return
                }
                //如果是点击滑动则不执行下面的方法
                var selectID = Int(floor(self.pagesCollectionView.contentOffset.x / ACScreenWidth))
                selectID = selectID > 0 ? selectID : 0
                self.selectId = selectID
        
            }
    }
    
    private func configEqualTitles(height:CGFloat) {
        let titleWidth = ACScreenWidth / CGFloat(self.titles.count)
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: titleWidth, height: height)
        self.pagesTitleCollectionView.frame = CGRect.init(x: 0, y: 0, width: ACScreenWidth, height: height)
        self.pagesTitleCollectionView.collectionViewLayout = layout
        self.pagesTitleCollectionView.contentSize = CGSize.init(width: ACScreenWidth, height: height)
        self.pagesTitleCollectionView.reloadData()

        self.lineAbleScrollWidth = titleWidth * CGFloat((self.titles.count - 1))
        self.lineDefaultCenterX = titleWidth/2
        self.sliderLine.backgroundColor = lineColor
        self.sliderLine.frame = CGRect.init(x: 0, y: height - lineHeight, width: lineWidth, height: lineHeight)
        self.sliderLine.center.x = self.lineDefaultCenterX
        self.sliderLine.bringSubviewToFront(self.pagesTitleCollectionView)
        
        self.pagesCollectionView.frame = CGRect.init(x: 0, y: height, width: ACScreenWidth, height: self.frame.height - height)
        self.pagesCollectionView.contentSize = CGSize.init(width: ACScreenWidth * CGFloat(self.titles.count), height: self.pagesCollectionView.frame.height)
        let pagesLayout = UICollectionViewFlowLayout.init()
        pagesLayout.minimumLineSpacing = 0
        pagesLayout.minimumInteritemSpacing = 0
        pagesLayout.scrollDirection = .horizontal
        pagesLayout.itemSize = CGSize.init(width: ACScreenWidth, height: self.pagesCollectionView.frame.height)
        
        self.pagesCollectionView.collectionViewLayout = pagesLayout
        self.pagesCollectionView.reloadData()
        self.pagesCollectionView.isPagingEnabled = true
    
    }

    //界面移除时候销毁
    deinit {
        print("ACPageView销毁")
        NotificationCenter.default.removeObserver(self.pagesCollectionView, forKeyPath: "contentOffset")
    }
    
}

//MARK: 外部配置ACPageView方法
extension ACPageView {
    func configTitles(titles:[String],showType:ACTitleShowType,titleHeight:CGFloat){
        if(titles.count == 0){
            return
        }
        self.titles = titles
        switch showType {
        case .equal:
            configEqualTitles(height: titleHeight)
            break
        case .auto:
            break
        }
    }
    
    func isSliderViewHidden(isHidden:Bool){
        self.sliderLine.isHidden = isHidden
    }
    
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String){
        self.pagesCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String){
        self.pagesCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }

    
}

extension ACPageView:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.isEqual(self.pagesTitleCollectionView)){
            return self.titlesCollectionView(collectionView, cellForItemAt: indexPath)
        }
        if let delegate = self.delegate {
            return delegate.ACPageViewPagesCollectionView(collectionView, cellForItemAt: indexPath)
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACPageViewDefaultCellID, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.isEqual(self.pagesTitleCollectionView)){
            self.titlesCollectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    
}


//MARK: pagesTitleCollectionView collectionDelegate
extension ACPageView{
    
    func titlesCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACPageTitleCellID, for: indexPath) as! ACPageTitleCell
        cell.titleLab.text = self.titles[indexPath.row]
        let isSelectId = self.selectId == indexPath.row
        cell.titleLab.textColor = isSelectId ? selectTitleColor : defaultTitleColor
        cell.titleLab.font = isSelectId ? selectTitleFont : defaultTitleFont
        cell.backgroundColor = isSelectId ? selectTitleBgColor : defaultTitleBgColor
        return cell
    }
    
    func titlesCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isClickedScoll = true
        self.selectId = indexPath.row
        UIView.animate(withDuration: 0.3) {
            self.pagesCollectionView.isPagingEnabled = false
            self.pagesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.pagesCollectionView.isPagingEnabled = true
                self.isClickedScoll = false
            }
        }

    }
    
}

@objc protocol ACPageViewDelegate {
    
    func ACPageViewPagesCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell;

    
    @objc optional func ACPageViewPagesCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath);
    
}
