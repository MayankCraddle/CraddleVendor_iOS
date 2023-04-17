//
//  View+Extension.swift
//  FamilyHives (iOS)
//
//  Created by Deepak on 27/05/21.
//

import UIKit

extension UIView {
    public class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
        return Bundle.main.loadNibNamed(String(describing: viewType), owner: nil, options: nil)!.first as! T
    }
    
    public class func instantiateFromNib() -> Self {
        return instantiateFromNib(viewType: self)
    }
}

//MARK:- Extension UIView
extension UIView {
    
    class func fromNib<T : UIView>(xibName: String) -> T {
        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil )![0] as! T
    }
    
    func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    func makeRounded(){
        self.layer.cornerRadius = self.frame.size.height/2
    }
    
    func makeRoundCorner(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeRoundCorner(){
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func makeRoundCornerWithBorder() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    
    func addShadowWithRadiusAndColor(radius:CGFloat, color:UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    func addShadowWithRadiusAndColor(radius: CGFloat ,cornerRadius: CGFloat,color: UIColor, opacity: Float =  0.5){
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
    
    //give the border to UIView
    func border(radius : CGFloat,borderWidth : CGFloat,color :CGColor){
        self.layer.cornerRadius  = radius
        self.layer.borderWidth   = borderWidth
        self.layer.borderColor   = color
    }
    
    //give the circle border to UIView
    func circleBorder(){
        let hight = self.layer.frame.height
        let width = self.layer.frame.width
        if hight < width{
            self.layer.cornerRadius = hight/2
            self.layer.masksToBounds = true
        }
        else{
            self.layer.cornerRadius  = width/2
            self.layer.masksToBounds = true
        }
    }
    
    
    func clearShadow(){
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize.zero
    }
    
    func addShadowWithRoundCorner(color: UIColor = UIColor.lightGray){
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    
    func roundCorners(corners: UIRectCorner, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func addShadowWithRadius(radius: CGFloat ,cornerRadius: CGFloat ){
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}

//MARK: - UIView extension
extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.clipsToBounds = false
//                self.addShadow(cornerRadius: self.layer.cornerRadius)
            }
        }
        
    }
    
//    func addShadow(shadowColor: CGColor = AppColor.AppPinkColor.cgColor,
//                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
//                   shadowOpacity: Float = 0.4,
//                   shadowRadius: CGFloat = 3.0,
//                   cornerRadius: CGFloat = 0) {
//        layer.shadowColor = shadowColor
//        layer.shadowOffset = shadowOffset
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowRadius = shadowRadius
//        layer.cornerRadius = cornerRadius
//    }
}

////MARK:- Adding Attributes to UIView
extension UIView {

@IBInspectable
var borderWidth: CGFloat {
    get {
        return layer.borderWidth
    }
    set {
        layer.borderWidth = newValue
    }
}

@IBInspectable
var borderColor: UIColor? {
    get {
        if let color = layer.borderColor {
            return UIColor(cgColor: color)
        }
        return nil
    }
    set {
        if let color = newValue {
            layer.borderColor = color.cgColor
        } else {
            layer.borderColor = nil
        }
    }
}
}
