import Reactivity

@Reactive
class TodoViewModel {
  private(set) var items: [TodoItem] = []
  private var lastId = 0

  func onClickAddNewButton() {
    lastId += 1
    items.append(
      TodoItem(
        id: lastId,
        title: "Title",
        description: "Description",
        deadline: "2026-01-15"
      )
    )
  }

  func onClickDeleteButton(at index: Int) {
    items.remove(at: index)
  }

  func onClickDoneButton(with item: TodoItem, at index: Int) {
    items[index] = item
  }
}
