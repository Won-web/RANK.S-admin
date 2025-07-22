import Foundation
import UIKit

public enum PagingMenuItemSize {
  case fixed(width: CGFloat, height: CGFloat)
  
  case sizeToFit(minWidth: CGFloat, height: CGFloat)
}

public extension PagingMenuItemSize {
  
  var width: CGFloat {
    switch self {
    case let .fixed(width, _): return width
    case let .sizeToFit(minWidth, _): return minWidth
    }
  }
  
  var height: CGFloat {
    switch self {
    case let .fixed(_, height): return height
    case let .sizeToFit(_, height): return height
    }
  }
  
}
