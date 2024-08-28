import UIKit

extension UITableView {
    
    public var cells: [UITableViewCell] {
          (0..<self.numberOfSections).indices.map { (sectionIndex: Int) -> [UITableViewCell] in
              (0..<self.numberOfRows(inSection: sectionIndex)).indices.compactMap { (rowIndex: Int) -> UITableViewCell? in
                  self.cellForRow(at: IndexPath(row: rowIndex, section: sectionIndex))
              }
          }.flatMap { $0 }
    }
    
}
