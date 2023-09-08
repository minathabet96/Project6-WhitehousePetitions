//
//  ViewController.swift
//  Project7 - Whitehouse Petitions
//
//  Created by Mina Thabet on 27/08/2023.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(credits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filter))
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
    }
    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }
        else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
       
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
            }
                performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
        @objc func credits(){
            let ac = UIAlertController(title: nil, message: "This data is brought to you from the \"WeThePeople\" Whitehouse API", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }

    @objc func filter() {
        let ac = UIAlertController(title: "Enter your word Search", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Search", style: .default){
            [weak self, weak ac] _ in
            if let searchWord = ac?.textFields?[0].text {
                self?.search(searchWord)
            }
        }
        )
        present(ac, animated: true)
    }
    func search(_ searchWord: String){
        for petition in petitions {
        if petition.title.contains(searchWord){
            filteredPetitions.append(petition)
            }
            
            tableView.reloadData()

        }
    }
    func parse(json: Data){
        let decoder = JSONDecoder()
        if let jsonpetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonpetitions.results
                tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            }
        else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredPetitions.isEmpty {
            return filteredPetitions.count
        } else {
            return petitions.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if !filteredPetitions.isEmpty {
            let petition1 = filteredPetitions[indexPath.row]
            cell.textLabel?.text = petition1.title
            cell.detailTextLabel?.text = petition1.body
        } else {
            let petition = petitions[indexPath.row]
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        }
        return cell
    }
   @objc func showError(){
            let ac = UIAlertController(title: "Loading Error", message: "There was an error. Please check your connection!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .destructive))
            present(ac, animated:true)
    }
}
