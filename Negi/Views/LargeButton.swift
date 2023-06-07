//
//  LargeButton.swift
//  Negi
//
//  Created by William Martin on 6/6/23.
//

import SwiftUI

struct LargeButton: View {
    var labelText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(labelText)
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(width: 350, height: 50)
                .background(.blue)
                .cornerRadius(15)
                .padding()
        })
    }
}

struct LargeButton_Previews: PreviewProvider {
    static var previews: some View {
        LargeButton(labelText: "Confirm", action: {})
    }
}
