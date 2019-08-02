//
//  ViewController.swift
//  VQ_videoeditor_app
//
//  Created by Roman Kravtsov on 06/07/2019.
//  Copyright © 2019 Roman Kravtsov. All rights reserved.
//

import UIKit

struct cellData {
    var opened = false
    var title = ""
    var sectionData = [String]()
    
}

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tableViewData = [cellData]()
    let imagePicker = UIImagePickerController()
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData.append(cellData(opened: false, title: "Start new project", sectionData: ["Record new video", "Open video file", "Open image"]))
        tableViewData.append(cellData(opened: false, title: "Recent projects", sectionData: ["Instagram video", "1st project", "Untitled"]))
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableViewData[indexPath.section].opened.toggle()
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        } else if indexPath.section == 0 && indexPath.row == 2 {
            openPicker()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        imagePicker.dismiss(animated: true)
        guard let videoURL = videoURL else { return }
        
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: "mainScreen") as? MainScreenViewController {
            mainVC.modalPresentationStyle = .overFullScreen
            mainVC.videoURL = videoURL
            present(mainVC, animated: true)
        }
       
    }
    
    func openPicker() {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.movie"]
        
        present(imagePicker, animated: true)
    }


}

