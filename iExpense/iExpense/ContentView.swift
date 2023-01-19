//
//  ContentView.swift
//  iExpense
//
//  Created by LAP13526 on 17/01/2023.
//

import SwiftUI
import Foundation

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let currencyCode: String
    let name: String
    let type: String
    let amount: Double
}

struct CustomStyle: ViewModifier {
    var amount: Double
    func body(content: Content) -> some View {
        if amount < 10 {
            content
                .font(.title3)
        } else if amount < 100 {
            content.font(.title2).foregroundColor(.red)
        } else {
            content.font(.title).foregroundColor(.green)
        }
        
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}


struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false

    func removeItemInBusiness(at offsets: IndexSet) {
        var businessItems = expenses.items.filter({$0.type == "Business"})
        let index = Int(offsets.first ?? -1)
        if index != -1 {
            let item = businessItems.remove(at: index)
            expenses.items.removeAll(where: {$0.id == item.id})
        }
    }
    
    func removeItemInPersonal(at offsets: IndexSet) {
        var personalItems = expenses.items.filter({$0.type == "Personal"})
        let index = Int(offsets.first ?? -1)
        if index != -1 {
            let item = personalItems.remove(at: index)
            expenses.items.removeAll(where: {$0.id == item.id})
        }
    }
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Business")){
                    ForEach(expenses.items.filter({$0.type == "Business"})) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: item.currencyCode))
                                .modifier(CustomStyle(amount: item.amount))
                        }
                    }
                    .onDelete(perform: removeItemInBusiness)
                }
                Section(header: Text("Personal")){
                    ForEach(expenses.items.filter({$0.type == "Personal"})) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text(item.amount, format: .currency(code: item.currencyCode))
                                .modifier(CustomStyle(amount: item.amount))
                        }
                    }
                    .onDelete(perform: removeItemInPersonal)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button{
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
