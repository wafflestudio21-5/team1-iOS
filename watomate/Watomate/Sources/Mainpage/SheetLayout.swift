//
//  SheetLayout.swift
//  Watomate
//
//  Created by 이수민 on 2024/01/11.
//  Copyright © 2024 tuist.io. All rights reserved.
//

import UIKit

func setSheetLayout(for viewController: UIViewController) {
    viewController.modalPresentationStyle = .pageSheet
    
    let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
    let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
        // safe area bottom 제외
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0

        return 300 - safeAreaBottom
    }
    
    if let sheet = viewController.sheetPresentationController {
        sheet.detents = [customDetent, .large()]
        sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        sheet.prefersGrabberVisible = true
    }
}


