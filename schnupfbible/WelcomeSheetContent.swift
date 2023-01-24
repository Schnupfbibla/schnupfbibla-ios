//
//  OnboardingSheetContent.swift
//  schnupfbible
//
//  Created by Jesse Born on 20.01.23.
//

import Foundation
import WelcomeSheet

let OnboardingWelcomeSheetPages = [
        WelcomeSheetPage(title: "Wilkommen in der \"Schnupfbiblä\"", rows: [
            WelcomeSheetPageRow(imageSystemName: "figure.wave",
                                title: "Hoi!",
                                content: "Die Schnupfbiblä sammelt seit 2023 Schnupfsprüche. Stöbere doch ein bisschen herum."),
            
            WelcomeSheetPageRow(imageSystemName: "18.circle",
                                title: "Explizite Inhalte",
                                content: "Standartmässig sind explizite Inhalte deaktiviert. In den Einstellungen kann dies angepasst werden."),
            WelcomeSheetPageRow(imageSystemName: "square.and.pencil",
                                title: "Eigene Sprüche beitragen",
                                content: "In den Einstellungen findest du die Möglichkeit, dein eigenes lyrisches Meisterwerk in die Schnupfbiblä übertragen zu lassen."),
            
            WelcomeSheetPageRow(imageSystemName: "hand.raised.circle",
                                title: "Schnupftabak ist ein Tabakerzeugnis",
                                content: "Tabak ist ein Suchtmittel und kann abhängig machen. Die Einnahme von Tabakprodukten wird nicht empfohlen. Bitte beachte, dass in bestimmten Regionen Jugendschutzgesetze gelten und das Verkaufs- und Erwerbsalter für Tabakprodukte beschränkt sein könnte.")
        ], mainButtonTitle: "Priis!")
    ]

let SubmissionThankYouPages = [
        WelcomeSheetPage(title: "Danke für deinen Beitrag", rows: [
            WelcomeSheetPageRow(imageSystemName: "checkmark.seal",
                                title: "Vielen dank!",
                                content: "Wir haben deinen vorgeschlagenen Spruch erhalten und werden ihn in den nächsten Tagen sorgfältig prüfen. Bitte beachte, dass es möglicherweise einige Zeit dauern kann, bis der Spruch freigeschaltet wird. Wir bitten um dein Verständnis, dass wir jeden Beitrag einzeln überprüfen, um sicherzustellen, dass er den Richtlinien entspricht und für unsere Community angemessen ist."),
            
        ], mainButtonTitle: "Priis!")
    ]
