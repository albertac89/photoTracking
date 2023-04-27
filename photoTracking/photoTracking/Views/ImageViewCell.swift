//
//  ImageCell.swift
//  photoTracking
//
//  Created by Albert Aige Cortasa on 25/4/23.
//

import Foundation
import SwiftUI
import Combine

struct ImageViewCell: View {
    var image: ImageModel
    struct Constants {
        static let textInPadding: CGFloat = 5
        static let textBackgoundCornerRadius: CGFloat = 10
        static let textOutPadding: CGFloat = 10
        static let viewShadow: CGFloat = 4
    }
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: image.imageData) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: .gray, radius: Constants.viewShadow)
            Text(image.title.isEmpty ? image.id : image.title)
                .padding(Constants.textInPadding)
                .background(.black)
                .foregroundColor(.white)
                .cornerRadius(Constants.textBackgoundCornerRadius)
                .fontWeight(.medium)
                .padding(Constants.textOutPadding)
                .shadow(color: .gray, radius: Constants.viewShadow)
        }
    }
}

struct ImageViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewCell(image: ImageModel(id: "0", imageData: Data(), title: "Title test"))
    }
}
