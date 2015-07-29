//
//  TableViewCell.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-04.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class NelpTasksTableViewCell: UITableViewCell {
  
  var titleLabel: UILabel!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.clipsToBounds = true
    
    let cellView = UIView(frame: self.bounds)
    cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
    
    let titleLabel = UILabel()
    titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    cellView.addSubview(titleLabel)
    self.titleLabel = titleLabel
    
    let views = ["titleLabel": titleLabel]
    cellView.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "|-30-[titleLabel]-40-|",
        options:NSLayoutFormatOptions.AlignAllLeft,
        metrics:nil,
        views:views
      )
    )
    cellView.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-5-[titleLabel]|",
        options:NSLayoutFormatOptions.AlignAllLeft,
        metrics:nil,
        views:views
      )
    )
    
    self.addSubview(cellView)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
  }
  
  override func setHighlighted(highlighted: Bool, animated: Bool) {
  }
  
  static var reuseIdentifier: String {
    get {
      return "NelpTasksTableViewCell"
    }
  }
  
  func setNelpTask(nelpTask: FindNelpTask) {
    titleLabel.text = nelpTask.title
  }
}
