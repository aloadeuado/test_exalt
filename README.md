# test_exalt

La aplicación es una muestra de las fotos publicadas dia tras dia de la nasa.

## Installation

Use cocoa pods [cocoapods](https://cocoapods.org/) he instala los pods de dependencias .

```bash
pod install
```

## Dependencias Usadas

```javascript
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'test_empowermentlabs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SDWebImage', '~> 5.13.2'
  pod 'SkeletonView', '~> 1.30.4'
  # Pods for test_empowermentlabs

  target 'test_empowermentlabsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'test_empowermentlabsUITests' do
    # Pods for testing
  end

end
```

- SDWebImage: descargar imagenes y menejo de cache para su reconsumo posteriormente.
- SkeletonView: para la evidencia de fragmento de desgradado mientras trae los datos o responde en EndPoint seleccionado.

## Arquitectura usada
- mvvm: la idea es la implementación de [POP](https://medium.com/globallogic-latinoamerica-mobile/la-programaci%C3%B3n-orientada-a-protocolos-en-swift-3548ed2dc2f1) conjunto con un viewModel con los protocolos
```swift
import Foundation
import UIKit

protocol ListRecipesViewToViewModel {
    func succesGetListRecipes(listRecipes: ListRecipes, text: String)
    func showError(error: String)
}

protocol ListRecipesViewModelToView: AnyObject {
    func getListRecipes(controller:UIViewController, text: String, offsetPage: Int, numberPerPage: Int)
    func addTextFastSearch(text: String)
}
```
- y por medio de binding se entregar los resuelto en los servicios para las vistas

```swift
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
```
- se agrego una arquitectura repository para el manejo de storage
- una clase de trato de data dependiendo de la necesidad del negocio
```swift
import Foundation
import UIKit

class ApiServices {
    enum Method : String {
        case post = "POST"
        case put = "PUT"
        case get = "GET"
        case patch = "PATCH"
    }
    
    func requestHttpwithUrl<T : Codable>(EpUrl: String, method: ApiServices.Method, withData parameters: [String:Any], modelType:T.Type, completionHandler: @escaping (Bool, T?, Error?) -> Void) {
        
        let request_url = URL(string: EpUrl)
        
        let request:NSMutableURLRequest = NSMutableURLRequest()
        print("[URL REQUEST=>]: \(request_url)")
        print("[PARAMETERS=>]: \(parameters)")
        request.url = request_url
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        if method != .get {
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData
        }
        let session = URLSession.init(configuration: .default)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            let response = (response as? HTTPURLResponse)
            print("[CODE STATUS=>]: \(response)")
            if response?.statusCode == 200 {
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let textJson = String(decoding: safeData, as: UTF8.self)
                        print("[RESPONSE=>]: \(textJson)")
                        let decodedData = try decoder.decode(modelType, from: safeData)
                        DispatchQueue.main.async {
                            completionHandler(true, decodedData, nil)
                        }
                    } catch let error{
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completionHandler(false, nil, error)
                        }
                    }
                }else{
                    print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
                        completionHandler(false, nil, error)
                    }
                }
            }else{
                print("[ERROR=>]: \(error?.localizedDescription ?? "")")
                if let safeData = data{
                    let textJson = String(decoding: safeData, as: UTF8.self)
                    print("[RESPONSE=>]: \(textJson)")
                    let decoder = JSONDecoder()
                    DispatchQueue.main.async {
                        completionHandler(false, nil, nil)
                    }
                }else{
                    completionHandler(false, nil, nil)
                }
            }
        })
        task.resume()
    }
}

```

- y una etapa de encapsulamiento mas dedicada al negocio
```swift
import Foundation

struct Recipes {
    static func getListRecipes(text:String, offsetOnPage: Int, numberOfItems: Int, complete: @escaping ((Bool, ListRecipes?, String) -> Void)) {
        let url = getListRecipesUrl().replacingOccurrences(of: "&{text}", with: "\(text)").replacingOccurrences(of: "&{offset}", with: "\(offsetOnPage)").replacingOccurrences(of: "&{number}", with: "\(numberOfItems)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: ListRecipes.self) { success, listRecipes, error in
            DispatchQueue.main.async {
                complete(success, listRecipes, error?.localizedDescription ?? "")
            }
        }
    }
    
    static func getDetailRecipes(idRecipe: Int, complete: @escaping ((Bool, DetailRecipes?, String) -> Void) ) {
        let url = getDetailRecipesUrl().replacingOccurrences(of: "&{idRecipe}", with: "\(idRecipe)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: DetailRecipes.self) { success, detailRecipes, error in
            DispatchQueue.main.async {
                complete(success, detailRecipes, error?.localizedDescription ?? "")
            }
        }
    }
}
```
- y por medio del viewModel nos comunicamos con las vista.

```swift
import Foundation
import UIKit
class ListRecipesViewModel {
    var listRecipesViewToViewModel: ListRecipesViewToViewModel?
    init(listRecipesViewToViewModel: ListRecipesViewToViewModel) {
        self.listRecipesViewToViewModel = listRecipesViewToViewModel
    }
}
//MARK: -ListRecipesViewModelToView
extension ListRecipesViewModel: ListRecipesViewModelToView {
    func getListRecipes(controller: UIViewController, text: String, offsetPage: Int, numberPerPage: Int) {
        Recipes.getListRecipes(text: text, offsetOnPage: offsetPage, numberOfItems: numberPerPage) {[weak self] success, listRecipes, error in
            if success {
                guard let self = self, let listRecipes = listRecipes else {return}
                self.listRecipesViewToViewModel?.succesGetListRecipes(listRecipes: listRecipes, text: text)
            } else {
                AlertsNative.showSimpleAlertNoAction(titleText: "Error", subTitleText: error)
            }
        }
    }
    
    func addTextFastSearch(text: String) {
        addTextFastSearchUtil(text: text)
    }
    
    func getTextFastSearch() -> [String] {
        return getTextFastSearchUtil()
    }
    
    func getListFavoriteREcipesIds() -> [Result] {
        return FavoriteDefault.getFavoriteRecipe()
    }
    
    func addAndRemoveFavoriteId(result: Result) {
        FavoriteDefault.addFavoriteRecipe(result: result)
    }
    
    func getListPage(listRecipes: ListRecipes) -> [String] {
        var listText = [String]()
        let listData:Int = (listRecipes.totalResults ?? 0) / 10

        var index1 = 0
        for _ in 0...listData {
            
            index1 += 10
            listText.append("\(index1 - 9)...\(index1)")
        }
        if ((listRecipes.totalResults ?? 0) % 10) > 0 {
            listText.append("\(index1 - 9)...\((listRecipes.totalResults ?? 0))")
        }
        
        return listText
    }
}

```

## Depliegue continuo(CD)
- se contemplo utilizar [fastlane](https://fastlane.tools/) pero al final nos fuimos por [bitrise](https://app.bitrise.io/) por que por medio de cajones por debamos nos construye nuestro documento [fastlane](https://fastlane.tools/)

- empezamos con la configuracion del proyecto seleccion del repo y la rama

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.20.37%20a.%C2%A0m..png?alt=media&token=162e5d7a-01f1-4b8b-9365-e4d773ec2cf8)

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.21.26%20a.%C2%A0m..png?alt=media&token=b32dbbed-f91e-49fa-ace2-a8f31a9b0896)

- al terminar la configuración encontraremos un dashboard con el resumen de nuestra configuración

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.22.40%20a.%C2%A0m..png?alt=media&token=b2fe0b65-072f-4c74-b1bd-b123d2e70496)

- posteriormente podemos empezar a gregar cajones que por debajo configuran nuestra fastlane o incluso otras herramientas

- en este caso agregaremos una de [firebase distribution](https://firebase.google.com/?gclid=CjwKCAjwq9mLBhB2EiwAuYdMtU3Cg_kLyrNm1v0lD4kAFiKr2atanP8hXV7_ifKCnyOyJ_uNDFPenBoC8NAQAvD_BwE&gclsrc=aw.ds)

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testyummy-26178.appspot.com/o/Captura%20de%20Pantalla%202021-10-26%20a%20la(s)%2012.27.45%20a.%C2%A0m..png?alt=media&token=8705c329-f616-484a-a26a-4bb627b0aa65)

- configuramos nuestra consola de firebase
- agregamos los correos a los que queremos liberar la version qa en develop segun ambiente

![firebasestorage](https://firebasestorage.googleapis.com/v0/b/testmeli-e8ffc.appspot.com/o/Captura%20de%20pantalla%202023-06-08%20a%20la(s)%209.54.07%20p.m..png?alt=media&token=6cb49210-2770-43fc-959f-526ce1bfa738&_gl=1*3714xu*_ga*NjIzMzk4NzExLjE2ODI4NzIxNjU.*_ga_CW55HF8NVT*MTY4NjI3OTI1Ny4xMC4xLjE2ODYyNzkyNzkuMC4wLjA.)

- y cada vez que hagamos un pull request a nuestra rama qa tendremos automáticamente un build con las características de workflow ya construidas



## Video demostrativo Lista Recetas

[![IMAGE ALT TEXT HERE](https://firebasestorage.googleapis.com/v0/b/pruebacyxtera-4bc18.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202023-02-10%20at%2016.12.14.png?alt=media&token=b6185015-0789-41ff-8a75-13e2c55ca49a)](https://youtu.be/MqNg5m9Alhg)

## Video demostrativo Detalle Recetas

[![IMAGE ALT TEXT HERE](https://firebasestorage.googleapis.com/v0/b/pruebacyxtera-4bc18.appspot.com/o/Simulator%20Screen%20Shot%20-%20iPhone%2011%20Pro%20Max%20-%202023-02-10%20at%2016.12.14.png?alt=media&token=b6185015-0789-41ff-8a75-13e2c55ca49a)](https://youtube.com/shorts/MleNZDTURvY)

