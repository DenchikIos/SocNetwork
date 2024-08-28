import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "none")
    }
    
    var localizedTableNameLocalizable: String {
        NSLocalizedString(self, tableName: "Localizable", comment: "none")
    }
    
}
