//
//  JHMoreOptionView
//  JHUIKit
//
//  Created by junqhao on 2022/5/26.
//

import UIKit
import Masonry

struct JHMoreOption : OptionSet{
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let none = JHMoreOption(rawValue: 0)
    public static let insert = JHMoreOption(rawValue: 1 << 0)
    public static let delete = JHMoreOption(rawValue: 1 << 1)
    public static let all : JHMoreOption = [insert,delete]
}

@objcMembers class JHMoreOptionBridge : NSObject{
    public static let insert = NSInteger(JHMoreOption.insert.rawValue)
    public static let delete = NSInteger(JHMoreOption.delete.rawValue)
}

@objc class JHMoreOptionView: UIView {
    lazy var contentView : UIView = UIView(frame: CGRect.zero)
    
    var moreOption: JHMoreOption = .all{
        didSet{
            self.resetContentView();
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white;
        self.layer.borderColor = UIColor.yellow.cgColor;
        self.layer.borderWidth = 1;
        self.addSubview(self.contentView)
        self.resetContentView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resetContentView()->Void{
        for subView in self.contentView.subviews{
            subView.removeFromSuperview();
        }
        
        if self.moreOption.contains(.insert){
            self.addOptionSubView(title: "插入一条",opt: JHMoreOption.insert.rawValue)
        }
      
        if self.moreOption.contains(.delete){
            self.addOptionSubView(title: "删除本条",opt: JHMoreOption.delete.rawValue)
        }
       
        self.frame.size = self.contentView.frame.size;
    }
    
    @objc private func buttonClick(button : UIButton)->Void{
        self.routerEvent(withName: "optSelected", userInfo: ["opt" : button.tag])
    }
    
    private func addOptionSubView(title : String,opt:Int)->Void{
        let button : UIButton = UIButton.init();
        button.tag = opt;
        button.setTitle(title, for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.frame = CGRect.init(x: 0, y: self.contentView.subviews.count * 30, width: 100, height: 30);
        button.addTarget(self, action: #selector(buttonClick(button:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(button);
        self.contentView.frame.size = CGSize.init(width: 100, height: self.contentView.subviews.count * 30)
    }
    
}
