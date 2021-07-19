    import Foundation
    import UIKit
     
     class SwViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
     {
        
     //@IBO weak var collectionView: UICollectionView!
        
        let kScaleBoundLower: CGFloat = 0.5
        let kScaleBoundUpper: CGFloat = 2.0
    var lastVisibleIndex:IndexPath!
    var firstVisibleIndex:IndexPath!
    var avgIndexFloat:Float = 0.0;
    var avgIndex=0;
   
    var column = 5;
    var Iwidth:CGFloat=0;
        var collectionView:UICollectionView!
        var imageView:UIImageView!
        var scale: CGFloat = 0.5
        var fitCells = false
        var animatedZooming = false
        var frame_width:CGFloat = 0;
        private var gesture: UIPinchGestureRecognizer?

        override func viewDidLoad()
    {
    super.viewDidLoad()
         let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
        // layout.itemSize = CGSize(width:view.frame.width,height:700)
        layout.minimumInteritemSpacing = 0
         layout.minimumLineSpacing = 0
       // let layout = ColumnFlowLayout(
      //  cellsPerRow: 5,
       // minimumInteritemSpacing: 10,
      //  minimumLineSpacing: 10,
       //sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
       // )

        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            collectionView.setCollectionViewLayout(layout,animated: true)
        animatedZooming = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
       // Default scale is the average between the lower and upper bound
        //scale = (kScaleBoundUpper + kScaleBoundLower) / 2.0

    // Register a random cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //    collectionView.collectionViewLayout.invalidateLayout()

    // Add the pinch to zoom gesture
        gesture = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture(_:)))
        if let gesture = gesture {
          collectionView.addGestureRecognizer(gesture)
        }
            

    }

    // MARK: - Accessors
    func setScale(scale: CGFloat) {
    // Make sure it doesn't go out of bounds
    if scale < kScaleBoundLower {
    self.scale = kScaleBoundLower
    } else if scale > kScaleBoundUpper {
    self.scale = kScaleBoundUpper
    } else {
    self.scale = scale
    }
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 30
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        frame_width = collectionView.frame.width;
        Iwidth = frame_width/CGFloat(column);
     //   collection
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var view:UIView!
        var image:UIImage!
        
    // Alternate cells between red and blue
        if(cell.contentView.subviews.count == 0){
            imageView = UIImageView(frame:CGRect(x:0,y:0,width:Iwidth,height:Iwidth))
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            image = UIImage(named: String(format: "%i", indexPath.row + 1))
            //image.resizableImage(withCapInsets:UIEdgeInsets(top:2 , left:2, bottom:2, right:2),resizingMode: .stretch);
            imageView.image = image;
            cell.contentView.addSubview(imageView)
        }
        else{
             
            imageView  =     cell.contentView.subviews[0] as? UIImageView;
            image = UIImage(named: String(format: "%i", indexPath.row + 1))
            imageView.image = image;
            imageView.frame = CGRect(x:0,y:0,width:Iwidth,height:Iwidth)
            cell.contentView.subviews[0].contentMode = UIView.ContentMode.scaleAspectFill;
          
        }
      
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    // Main use of the scale property
          if scale < CGFloat(1) {
            column = 5;
          }
          else if scale > CGFloat(1) && scale < CGFloat(1.5) {
            column = 3;
          }
          else if scale > CGFloat(1.5) {
            column = 1;
          }
       let arrayOfVisibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if(arrayOfVisibleItems.count > 0){
           lastVisibleIndex   = arrayOfVisibleItems.last
           firstVisibleIndex  = arrayOfVisibleItems.first
           avgIndexFloat  = Float(CGFloat(lastVisibleIndex.row) + CGFloat(firstVisibleIndex.row)/scale);
           avgIndex = Int(avgIndexFloat)
           collectionView.scrollToItem(at: IndexPath(row:avgIndex, section:0), at: .bottom, animated:false)
        }
        
       //
        
        //let scaledWidth:CGFloat = 50 * scale;
        let scaledWidth:CGFloat = collectionView.frame.width / CGFloat(column)
        //let scaledWidth:CGFloat = (collectionView.frame.width / CGFloat(5));
     //let width:CGFloat = [UIScreen mainScreen].bounds.size.width * scale
    if fitCells {
       // let cols = floor(collectionView.frame.width  / scaledWidth)
    let totalSpacingSize = CGFloat(5 * (column - 1)) // 10 is defined in the xib
    let fittedWidth = (collectionView.frame.width  - totalSpacingSize) / CGFloat(column)
    return CGSize(width: fittedWidth, height: fittedWidth)
    } else {
    return CGSize(width: scaledWidth, height: scaledWidth)
    }
    }

    // MARK: - Gesture Recognizers
    static var didReceivePinchGestureScaleStart: CGFloat = 0.0

        @objc  func didReceivePinchGesture(_ gesture: UIPinchGestureRecognizer?) {

    if gesture?.state == .began {
    // Take an snapshot of the initial scale
        SwViewController.didReceivePinchGestureScaleStart = scale
        return
    }
    if gesture?.state == .changed {
    // Apply the scale of the gesture to get the new scale
    scale = SwViewController.didReceivePinchGestureScaleStart * (gesture?.scale ?? 0.0)

    if animatedZooming {
      collectionView.removeGestureRecognizer(gesture!)
      let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
          //layout.itemSize = CGSize(width:view.frame.width,height:700)
          layout.minimumInteritemSpacing = 0
          layout.minimumLineSpacing = 0
          collectionView.setCollectionViewLayout(layout, animated: true) { [self] finished in
          collectionView.addGestureRecognizer(gesture!)
          collectionView.reloadData()
          collectionView.collectionViewLayout.invalidateLayout()
    }
    } else {
         collectionView.reloadData()
         collectionView.collectionViewLayout.invalidateLayout()
    }
}
}
}
