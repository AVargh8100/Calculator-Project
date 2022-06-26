//
//  ViewController.swift
//  Pokemon
//
//  Created by Consultant on 6/17/22.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    let database = DatabaseHandler.shared
    var offset: Int = 0
    var limit: Int = 30
    var endOfPage = false
    var pokemons = [Pokemon]()
    var favorites: [PokemonsCore]?{
        didSet {
            /*
             with the didSet property observer the code below executes whenever a property has changed.
             That meas for us the array of User objects is updated and we reload the tableview in real time

             https://nshipster.com/swift-property-observers/
             */
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getPokemons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = database.fetch(PokemonsCore.self)
    }
    
    //MARK: - Helper Functions
    func setUp(){
        title = "Pokemon list"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func getPokemons(completed: ((Bool) -> Void)? = nil){
            for item in (self.offset..<(self.offset + self.limit)) {
                let components = URLComponents(string: "\(Conts.baseURL)/\(item + 1)/")!
                URLSession.shared.getRequest(components: components){ result in
                    switch result{
                    case .success(let result):
                        DispatchQueue.main.async {
                            let name = result["name"] as! String
                            let sprites = result["sprites"] as! [String: Any]
                            let imageUrl = sprites["front_default"] as! String
                            let baseExperience = result["base_experience"] as! Int
                            let typesObject = result["types"] as! [[String:Any]]
                            var types:[String] = []
                            for item in typesObject{
                                let type = item["type"] as! [String: String]
                                types.append(type["name"]!)
                            }
                            let stats = result["stats"] as! [[String: Any]]
                            let hp = stats[0]["base_stat"] as! Int
                            let attack = stats[1]["base_stat"] as! Int
                            let defense = stats[2]["base_stat"] as! Int
                            let specialAttack = stats[3]["base_stat"] as! Int
                            let specialDefense = stats[4]["base_stat"] as! Int
                            let speed = stats[5]["base_stat"] as! Int
                            let weight = result["weight"] as! Int
                            let height = result["height"] as! Int
                            let pokemon = Pokemon(
                                    name: name,
                                    imageUrl: imageUrl,
                                    types: types,
                                    baseExperience: baseExperience,
                                    hp: hp,
                                    attack: attack,
                                    defense: defense,
                                    specialAttack: specialAttack,
                                    specialDefense: specialDefense,
                                    speed: speed,
                                    height: height,
                                    weight: weight
                            )
                            self.pokemons.append(pokemon)
                            self.endOfPage = self.offset == 150
                            self.offset =  self.offset + 1 <= 150 ? self.offset + 1 : 150
                            self.limit = self.offset == 150 ? 1 : 30
                        
                            self.tableView.reloadData()
                                
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    
                }
            
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listSection = TableSection(rawValue: section) else { return 0 }
        switch listSection {
        case .list:
            return pokemons.count
        case .loader:
            return pokemons.count >= limit && !endOfPage ? 1 : 0
        case .endOfList:
            return offset == 150 ? 1 : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)  as! PokemonTableViewCell
        
        switch section {
            case .list:
                let pokemon = pokemons[indexPath.row]
                cell.textLabel?.textColor = .label
                cell.textLabel?.text = pokemon.name
                cell.imageView?.getImage(from: URL(string: pokemon.imageUrl)!)
                cell.detailTextLabel?.text = pokemon.types.joined(separator: ", ")
                cell.delegate = self
            case .loader:
                cell.textLabel?.text = "Loading.."
                cell.textLabel?.textColor = .systemBlue
            case .endOfList:
                cell.textLabel?.text = "End of the list"
                cell.imageView?.image = nil
                cell.detailTextLabel?.text = ""
                cell.textLabel?.textColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = TableSection(rawValue: indexPath.section) else { return }
        guard !pokemons.isEmpty else { return }
        
        if section == .loader {
            print("load new data..")
            if(!endOfPage){
                getPokemons() { [weak self] success in
                    if !success {
                        self?.hideBottomLoader()
                    }
                }
            }
           
        }
    }
    
    private func hideBottomLoader(){
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: self.pokemons.count - 1, section: TableSection.list.rawValue)
            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.pokemon = pokemons[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != pokemons.count){
            performSegue(withIdentifier: "detailSegue", sender: self)
        }
    }
    

    
}

extension ViewController: PassDataToList{
    func passSelectedRowData(cell: UITableViewCell) {
        print("Clicked here")
        let indexTapped = tableView.indexPath(for: cell)!.row
//        let element = database.find(PokemonsCore.self, name: "Hello")
//        print(element)
        
//        if let elementIndex = UserDefaults.standard.favorites.firstIndex(of: indexTapped.row){
//            UserDefaults.standard.favorites.remove(at: elementIndex)
//        }else{
//            UserDefaults.standard.favorites.append(indexTapped.row)
//        }
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
    }
}

