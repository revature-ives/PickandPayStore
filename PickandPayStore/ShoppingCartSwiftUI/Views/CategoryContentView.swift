//
//  CategoryContentView.swift
//  PickandPayStore
//
//  Created by costin popescu on 4/5/22.
//

import SwiftUI
import MapKit

struct CategoryContentView: View {
    
    //State variables for searchbar
    @State var searchText = ""
    @State var searching = false
    @State var pastSearches = [String]()
    
    // Instance of CartManager and ProductsManager so you can access its functions and //properties.
    // Added cartManager to ProductCart and CartView.
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var productsManager: ProductsManager
    
    
    var category: CategoryM
    var productsList: [ProductM]
    
    // Need this variables for the lazy view grid.
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        
       //Create SearchBar outside of scrollview so it always shows on top
        SearchBar(searchText: $searchText, searching: $searching, pastSearches: $pastSearches)
        
            ScrollView{
                
                // Here you iterate over the Product list.
                LazyVGrid(columns: columns, spacing: 20){
                    
                    //Filter list based on text in search bar
                    ForEach(productsList.filter({ (product: ProductM) -> Bool in
                        return product.name.lowercased().hasPrefix(searchText.lowercased()) || searchText == ""
                    }), id: \.id)  { product in
                        
                        //Add a navigation link to each product card
                        NavigationLink(destination: ProductDetailView(product: product)
                                        .environmentObject(cartManager)
                                        .environmentObject(productsManager))
                        {
                        ProductCard(product: product)
                            .environmentObject(cartManager)
                            
                        }
                            
                    }
                }
                .padding()
            
               
            .navigationTitle(Text(category.name))
                
            //If using the search bar, add a cancel search button
            .toolbar{
                if searching{
                    Button("Cancel Search"){
                        searchText = ""
                        withAnimation{
                            searching = false
                            UIApplication.shared.dismissKeyboard()
                        }
                    }
                }
                //Navigate to the CartView
                NavigationLink {
                    // This is the destination.
                    CartView()
                        .environmentObject(cartManager)
                } label: {
                    //On CartButton click go to CartView.
                    CartButton(numberOfProducts: cartManager.products.count)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct CategoryContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryContentView(category:CategoryM(name: "ground", imageName: "speeder" ),
                            productsList: ProductsManager().getProductsOfCategory(category: 1))
            .environmentObject(ProductsManager())
    }
}
