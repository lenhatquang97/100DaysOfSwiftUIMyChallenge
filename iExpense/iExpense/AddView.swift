//
//  AddView.swift
//  iExpense
//
//  Created by LAP13526 on 19/01/2023.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss

    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @ObservedObject var expenses: Expenses

    let types = ["Business", "Personal"]
    
    @State private var currencyCode = "USD"
    let currencyCodes = ["USD", "EUR"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                HStack{
                    TextField("Amount", value: $amount, format: .currency(code: currencyCode))
                        .keyboardType(.decimalPad)
                    Spacer()
                    Picker(selection: $currencyCode, label: EmptyView()){
                        ForEach(currencyCodes, id: \.self) {
                            Text($0)
                        }
                    }
                }

                
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(currencyCode: currencyCode, name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
