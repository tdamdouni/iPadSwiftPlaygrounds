//
//  AudioMenuController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit

protocol AudioMenuDelegate: class {
    func enableBackgroundAudio(_ isEnabled: Bool)
    func enableCharacterAudio(_ isEnabled: Bool)
}

class AudioMenuController: UITableViewController {
    
    static let cellIdentifier = "SwitchTableViewCell"
    
    enum CellIndex: Int {
        case backgroundAudio
        case characterAudio
    }
    
    // MARK: Properties
    
    weak var delegate: AudioMenuDelegate?
    
    var backgroundAudioEnabled = Persisted.isBackgroundAudioEnabled
    
    var characterAudioEnabled = Persisted.areSoundEffectsEnabled
    
    // MARK: View Controller Life-Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: AudioMenuController.cellIdentifier)
        
        preferredContentSize = CGSize(width: 250, height: 87)
        tableView.tableFooterView = UIView()
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = CellIndex(rawValue: indexPath.row) else {
            fatalError("Invalid index \(indexPath.row) in \(self)")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioMenuController.cellIdentifier, for: indexPath)        
        cell.textLabel?.font = UIFont(name: "SanFranciscoDisplay-Regular", size: 17)
        
        let switchControl = UISwitch()
        cell.accessoryView = switchControl

        switch index {
        case .backgroundAudio:
            cell.textLabel?.text = "Background music"
            switchControl.isOn = backgroundAudioEnabled
            
            switchControl.addTarget(self, action: #selector(toggleBackgroundAudio(_:)), for: .valueChanged)
        
        case .characterAudio:
            cell.textLabel?.text = "Sound effects"
            switchControl.isOn = characterAudioEnabled

            switchControl.addTarget(self, action: #selector(toggleCharacterAudio(_:)), for: .valueChanged)
        }
        
        return cell
    }
    
    // MARK: Switch Actions
    
    func toggleBackgroundAudio(_ control: UISwitch) {
        delegate?.enableBackgroundAudio(control.isOn)
    }
    
    func toggleCharacterAudio(_ control: UISwitch) {
        delegate?.enableCharacterAudio(control.isOn)
    }
}
