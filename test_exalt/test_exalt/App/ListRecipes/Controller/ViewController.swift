//
//  ViewController.swift
//  test_empowermentlabs
//
//  Created by iMac on 8/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recipesCollectionView: UICollectionView!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var dateSelectedView: DateSelectedView!
    @IBOutlet weak var namePageDateSelectedView: DateSelectedView!
    @IBOutlet weak var emptyState: UIView!
    
    var listRecipes: ListRecipes?
    var viewModel: ListRecipesViewModel?
    var isFavoriteRecipes = false
    var listFavoritesRecipes = [Result]()
    var selectIndexDefault = 0
    var selectIndexDefaultNumberPage = 0
    var textSeacrh = ""
    var isLoading = true
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func initComponent() {
        viewModel = ListRecipesViewModel(listRecipesViewToViewModel: self)
        isLoading = true
        recipesCollectionView.reloadData()
        viewModel?.getListRecipes(controller: self, text: "", offsetPage: 0, numberPerPage: 10)
        
        searchBarView.delegate = self
        dateSelectedView.delegate = self
        namePageDateSelectedView.delegate = self
        dateSelectedView.textList = viewModel?.getTextFastSearch() ?? []
        dateSelectedView.loadViews()
        recipesCollectionView.register(RecipeCollectionViewCell.nib(), forCellWithReuseIdentifier: RecipeCollectionViewCell.identificador)
        listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
    }
    
    @IBAction func chageValueSegment(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 1 {
            isFavoriteRecipes = true
            listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
            if ((listFavoritesRecipes.isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            recipesCollectionView.reloadData()
        } else {
            isFavoriteRecipes = false
            if (((self.listRecipes?.results ?? []).isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            recipesCollectionView.reloadData()
        }
    }
}
//MARK: -ListRecipesViewToViewModel
extension ViewController: ListRecipesViewToViewModel {
    func succesGetListRecipes(listRecipes: ListRecipes, text: String) {
        self.listRecipes = listRecipes
        self.textSeacrh = text
        isLoading = false
        if (((self.listRecipes?.results ?? []).isEmpty)) {
            namePageDateSelectedView.isHidden = true
            emptyState.isHidden = false
            return
        }
        emptyState.isHidden = true
        namePageDateSelectedView.isHidden = false
        if !(self.listRecipes?.results?.isEmpty ?? false) {
            viewModel?.addTextFastSearch(text: text)
            dateSelectedView.textList = viewModel?.getTextFastSearch() ?? []
            let index = dateSelectedView.textList.firstIndex { text1 in
                return text1 == text
            }
            dateSelectedView.indexDefault = index ?? -1
            dateSelectedView.loadViews()
            
        }
        guard let listRecipes = self.listRecipes else {return}
        namePageDateSelectedView.textList = viewModel?.getListPage(listRecipes: listRecipes) ?? []
        namePageDateSelectedView.indexDefault = selectIndexDefaultNumberPage
        namePageDateSelectedView.loadViews()
        self.recipesCollectionView.reloadData()
    }
    
    func showError(error: String) {
        AlertsNative.showSimpleAlertNoAction(titleText: "Error", subTitleText: error)
    }
}
//MARK: -SearchBarViewDelegate
extension ViewController: SearchBarViewDelegate {
    func onGetText(text: String) {
        viewModel?.getListRecipes(controller: self, text: text, offsetPage: 0, numberPerPage: 10)
    }
    
    func onClearText() {
        viewModel?.getListRecipes(controller: self, text: "", offsetPage: 0, numberPerPage: 10)
    }

}
//MARK: -UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 4
        }
        if isFavoriteRecipes {
            return listFavoritesRecipes.count
        }
        return listRecipes?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
                cell.showSkeletor()
                return cell
            }
        }
        if isFavoriteRecipes {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
                cell.hidSkeletor()
                if let listRecipes = listRecipes {
                    cell.setData(baseUrl: listRecipes.baseURI ?? "", result: listFavoritesRecipes[indexPath.row])
                    let isFavorite = viewModel?.getListFavoriteREcipesIds().first(where: { result1 in
                        return result1.id == listFavoritesRecipes[indexPath.row].id
                    }) != nil
                    cell.isFavorite = isFavorite
                }
                cell.delegate = self
                
                return cell
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
            cell.hidSkeletor()
            if let listRecipes = listRecipes, let result = listRecipes.results {
                cell.setData(baseUrl: listRecipes.baseURI ?? "", result: result[indexPath.row])
                let isFavorite = viewModel?.getListFavoriteREcipesIds().first(where: { result1 in
                    return result1.id == result[indexPath.row].id
                }) != nil
                cell.isFavorite = isFavorite
            }
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
//MARK: -UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {
            return
        }
        
        if isFavoriteRecipes {
            DetailRecipesViewController.show(controller: self, result: listFavoritesRecipes[indexPath.row])
            return
        }
        if let listRecipes = listRecipes, let result = listRecipes.results {
            DetailRecipesViewController.show(controller: self, result: result[indexPath.row])
        }
        
    }
}
//MARK: -UICollectionViewDelegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((self.recipesCollectionView.frame.width / 2) - 64)
        return CGSize(width: width, height: 350)
    }
}
//MARK: -DateSelectedViewDelegate
extension ViewController: DateSelectedViewDelegate {
    func dateSelectedView(dateSelectedView: DateSelectedView, didSelectIndex index: Int, text: String) {
        if dateSelectedView == namePageDateSelectedView {
            selectIndexDefaultNumberPage = index
            isLoading = true
            self.recipesCollectionView.reloadData()
            viewModel?.getListRecipes(controller: self, text: self.textSeacrh, offsetPage: (index * 10), numberPerPage: 10)
            
            return
        }
        self.selectIndexDefault = index
        selectIndexDefaultNumberPage = 0
        self.textSeacrh = text
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListRecipes(controller: self, text: text, offsetPage: 0, numberPerPage: 10)
        
    }
    
    func dateSelectedView(didSelectIndex index: Int, text: String) {
        
    }
}
//MARK: -
extension ViewController: RecipeCollectionViewCellDelegate {
    func onAddAndRemoveFavorite(result: Result) {
        viewModel?.addAndRemoveFavoriteId(result: result)
        listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
        recipesCollectionView.reloadData()
    }
}
