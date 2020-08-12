//
//  DesigntimeFirestoreBoardRepository.swift
//  LifeGameApp
//
//  Created by Yusuke Hosonuma on 2020/08/12.
//

final class DesigntimeFirestoreBoardRepository: FirestoreBoardRepositoryProtorol {
    var items: [BoardDocument] = [
        BoardDocument(id: "1", title: "Nebura", board: BoardPreset.nebura.board),
        BoardDocument(id: "2", title: "Spaceship", board: BoardPreset.spaceShip.board),
    ]
    
    func get(by id: String, handler: @escaping (BoardDocument) -> Void) {
        guard let item = items.first(where: { $0.id == id }) else { return }
        handler(item)
    }

    func getAll(handler: @escaping ([BoardDocument]) -> Void) {
        handler(items)
    }
    
    func update(_ document: BoardDocument) {
        guard let index = items.firstIndex(where: { $0.id == document.id }) else { return }
        items[index] = document
    }
}
