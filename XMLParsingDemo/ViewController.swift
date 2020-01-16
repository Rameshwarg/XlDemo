//
//  ViewController.swift
//  XMLParsingDemo
//
//  Created by Sandeep Kakde on 01/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

import UIKit
import CoreData


class ViewController: BaseViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var elementName: String = String()
    var newsTitle = String()
    let dataBaseOperation = DataBaseOperation()
    var newsArray = [String]()
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        getLatestData()
    }
    
    func initialize() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        getLatestData()
        refreshControl.endRefreshing()
        
    }
    func getLatestData() {
        activityIndicatorBegin()
        DispatchQueue.global().sync {
            getAllLatestNewsFromServer()
        }
    }
    
    func getAllLatestNewsFromServer() {
        APICall().getNewsData { (dataFromServer, response, error) in
            if let data = dataFromServer {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
                DispatchQueue.main.async {
                    self.getAllLatestNewsFromLocal()
                }
            }
        }
    }
    
    func getAllLatestNewsFromLocal() {
        guard let result = dataBaseOperation.retrieveNewsData() else { return  }
        if newsArray.count > 0 {
            newsArray.removeAll()
        }
        for data in result {
            newsArray.append(data.value(forKey: "title") as! String)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        activityIndicatorEnd()
    }
    
    //MARK: XMLParser delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "title" {
            newsTitle = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title" {
            dataBaseOperation.createData(news: TechnologyNews(newsTitle: newsTitle))
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if self.elementName == "title" {
                newsTitle += data
            }
        }
    }
    
    
    //MARK: table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.newsTitleLabel.text = newsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let title = newsArray[indexPath.row]
            dataBaseOperation.deleteNewsData(title: title)
            newsArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}



