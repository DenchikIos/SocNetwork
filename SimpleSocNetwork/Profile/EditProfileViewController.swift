import UIKit

class EditProfileViewController: UIViewController {
    
    weak var delegate: UpdateTableViewDelegate?
    private var coreDataService = CoreDataService.shared
    private var profile: ProfileData?
    
    private enum NameOfRow: String, CaseIterable {
        case name = "Name"
        case surname = "Surname"
        case birthday = "Birthday"
        case hometown = "Hometown"
        case job = "Job"
        case save = "Save"
    }
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(EditProfileViewCell.self, forCellReuseIdentifier: EditProfileViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.rowHeight = 30
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 30
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(profile: ProfileData?) {
        super.init(nibName: nil, bundle: nil)
        self.profile = profile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscriptKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unSubscriptKeyboardEvents()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundCream")
        view.addSubviews(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -35),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor/*, constant: -35*/)
        ])
    }
    
    private func subscriptKeyboardEvents() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unSubscriptKeyboardEvents() {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRectangle.height, right: 0)
            self.tableView.contentInset = edgeInsets
            self.tableView.scrollIndicatorInsets = edgeInsets
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}

extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NameOfRow.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileViewCell.identifier, for: indexPath) as? EditProfileViewCell else {return UITableViewCell(frame: .zero)}
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5
        switch indexPath.section {
            case 0:
                cell.updateCell(textholder: "Name", text: profile?.name, isDatePicker: false, hiden: false)
            case 1:
                cell.updateCell(textholder: "Surname", text: profile?.surname, isDatePicker: false, hiden: false)
            case 2:
                cell.updateCell(textholder: "Birthday", text: profile?.dayBirth, isDatePicker: true, hiden: false)
            case 3:
                cell.updateCell(textholder: "Hometown", text: profile?.hometown, isDatePicker: false, hiden: false)
            case 4:
                cell.updateCell(textholder: "Job", text: profile?.userJob, isDatePicker: false, hiden: false)
        case 5:
                cell.updateCell(textholder: "", text: "", isDatePicker: false, hiden: true)
                cell.contentView.backgroundColor = UIColor(named: "backgroundCream")
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.layer.borderWidth = 1
                cell.textLabel?.layer.borderColor = UIColor(named: "textMainBlack")!.cgColor
                cell.textLabel?.layer.cornerRadius = 5
                cell.textLabel?.text = "Save".localized
            default:
                break
            }
        return cell
    }
    
}

extension EditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return NameOfRow.name.rawValue.localized
            case 1:
                return NameOfRow.surname.rawValue.localized
            case 2:
                return NameOfRow.birthday.rawValue.localized
            case 3:
                return NameOfRow.hometown.rawValue.localized
            case 4:
                return NameOfRow.job.rawValue.localized
            case 5:
                return " "
            default:
                fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 {
            var textArray = [String]()
            guard let allLoadedCells = tableView.cells as? [EditProfileViewCell] else {return}
            for cell in allLoadedCells {
                textArray.append(cell.returnedText() ?? "")
            }
            profile?.name = textArray[0]
            profile?.surname = textArray[1]
            profile?.dayBirth = textArray[2]
            profile?.hometown = textArray[3]
            profile?.userJob = textArray[4]
            coreDataService.saveContext()
            delegate?.updateTableView()
            dismiss(animated: true)
        }
    }
    
}
