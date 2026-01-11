import Reactivity

@Reactive
class TodoViewModel {
  private(set) var items: [TodoItem] = []

  func onClickAddNewButton() {
    items.append(
      TodoItem(
        id: (items.last?.id ?? 0) + 1,
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
