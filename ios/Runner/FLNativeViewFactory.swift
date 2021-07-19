import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
   
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}
 let kScaleBoundLower: CGFloat = 0.5
        let kScaleBoundUpper: CGFloat = 2.0
    var lastVisibleIndex:IndexPath!
    var firstVisibleIndex:IndexPath!
    var avgIndexFloat:Float = 0.0;
    var avgIndex=0;
    var column = 5;
    var Iwidth:CGFloat=0;

class FLNativeView: NSObject, FlutterPlatformView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var _collectionViewData:Array<Any>?
    private var _json_string:String?
    private var _view: UIView
    private var _channel:FlutterMethodChannel!
    // private var Products[String:Any]?;
    private var blogPosts: [ProductImages]?
    private var collectionView:UICollectionView!
            var imageView:UIImageView!
            var scale: CGFloat = 0.5
            var fitCells = false
            var animatedZooming = false
            var frame_width:CGFloat = 0;
            private var gesture: UIPinchGestureRecognizer?
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
    
        _view = UIView()
    
        //_view.frame = frame;
        super.init()
        
        _channel   = FlutterMethodChannel(name: "Products",
                                             binaryMessenger: messenger!)

        _channel.setMethodCallHandler({ [self](call: FlutterMethodCall, result: FlutterResult) -> Void in
               switch call.method {
               case "receiveFromFlutter":
                let args = call.arguments as? [String: Any]
                  self.receiveFromFlutter(args: args!)
                break

               case  "GridCount":
                let args = call.arguments as! [String:Any];
                setColumn(args: args)
                break
               default:
                   result(FlutterMethodNotImplemented)
               }
             }
           )
        
        // iOS views can be created here
        createNativeView(view: _view)
        
    }
    
    func setColumn(args:[String:Any]) {
        column = args["text"] as! Int;
        if column == 1 {
            scale = 1.6
        }
        else if column == 3 {
            scale = 1.2
        }
        else if column == 5 {
            scale = 0.5
        }
        collectionView.reloadData();
        collectionView.collectionViewLayout.invalidateLayout();
    }
    
    func receiveFromFlutter(args:[String:Any]){
       let json_string = args["text"] as? String;
        let decoder =   JSONDecoder();
        blogPosts =  try! decoder.decode([ProductImages].self, from: (json_string?.data(using: .utf8))!);
        
         collectionView.reloadData();
         collectionView.collectionViewLayout.invalidateLayout();
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        //_view.backgroundColor = UIColor.white
        //_view.translatesAutoresizingMaskIntoConstraints = false
        //var collectionView:UICollectionView!
              let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame:CGRect(x:0,y:0,width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height),collectionViewLayout: layout)
                     collectionView.setCollectionViewLayout(layout,animated: true)
        collectionView.backgroundColor = .white
        
        animatedZooming = false
        collectionView.delegate = self
                collectionView.dataSource = self
        _view.addSubview(collectionView)
        //collectionView.translatesAutoresizingMaskIntoConstraints = false

                collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        gesture = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture(_:)))
        if let gesture = gesture {
          collectionView.addGestureRecognizer(gesture)
        }
      //  nativeLabel.text = "Native text from iOS"
       // nativeLabel.textColor = UIColor.white
        //nativeLabel.textAlignment = .center
        //nativeLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 48.0)
        //_view.addSubview(nativeLabel)
    }
    struct ProductImages: Codable {
        var product_id: Int
        var image_name: String
        var image_path: String
        var created_at:String
        var created_by:String?
        var updated_at:String
        var updated_by:String?
        
    }



       // MARK: - UICollectionViewDataSource
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return blogPosts == nil ? 0:blogPosts?.count as! Int ;
        }


        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            frame_width = collectionView.frame.width;
            Iwidth = frame_width/CGFloat(column);
         //   collection
          

//              let arrayOfVisibleItems = collectionView.indexPathsForVisibleItems.sorted()
//                       if(arrayOfVisibleItems.count > 0){
//                          lastVisibleIndex   = arrayOfVisibleItems.last
//                          firstVisibleIndex  = arrayOfVisibleItems.first
//                          avgIndexFloat  = Float(CGFloat(lastVisibleIndex.row) + CGFloat(firstVisibleIndex.row)/scale);
//                          avgIndex = Int(avgIndexFloat)
//                          collectionView.scrollToItem(at: IndexPath(row:avgIndex, section:0), at: .bottom, animated:false)
//                       }
            var _:UIView!
            var image:UIImage!
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            let obj = blogPosts![indexPath.row]
            
           // cell.backgroundColor = .green
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let image_path = obj.image_path
            let image_name = obj.image_name
            let imageURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(image_path+"/"+image_name);
        // Alternate cells between red and blue
            cell.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tap(_:))))
           
            
            if(cell.contentView.subviews.count == 0){
                imageView = UIImageView(frame:CGRect(x:0,y:0,width:Iwidth,height:Iwidth))
                
                imageView.contentMode = UIView.ContentMode.scaleAspectFill
                image = UIImage(contentsOfFile: imageURL.path)
        
                imageView.image = image.imageWithInsets(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5));
                
                cell.contentView.addSubview(imageView)
            }
            else{
                imageView  =     cell.contentView.subviews[0] as? UIImageView;
                image = UIImage(contentsOfFile: imageURL.path)
                imageView.image = image.imageWithInsets(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5));
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
//

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
    
    
    
    @objc func tap(_ sender: UITapGestureRecognizer) {

       let location = sender.location(in: self.collectionView)
       let indexPath = self.collectionView.indexPathForItem(at: location)

        if (indexPath?.row) != nil {
            _channel.invokeMethod("sendFromNative",arguments:_collectionViewData?[indexPath!.row])
       }
    }
    
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
extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
}