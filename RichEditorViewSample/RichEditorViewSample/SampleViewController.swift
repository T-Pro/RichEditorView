//
//  SampleViewController.swift
//  RichEditorViewSample
//
//  Created by Ayyarappan K on 04/06/24.
//  Copyright © 2024 Caesar Wirth. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        table.register(UINib(nibName: "SampleTableCell", bundle: nil), forCellReuseIdentifier: "SampleTableCell")
        table.delegate = self
        table.dataSource = self
        
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
}

extension SampleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SampleTableCell", for: indexPath) as! SampleTableCell
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
