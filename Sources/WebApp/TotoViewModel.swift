import Reactivity

@Reactive
class TodoViewModel {
  var items: [TodoItem] = []

  func onAddNew() {
    onAddNew(
      TodoItem(
        id: (items.last?.id ?? 0) + 1,
        title: "Title",
        description: "Description",
        deadline: "2026-01-15"
      )
    )
  }

  func onAddNew(_ item: TodoItem) {
    items.append(item)
  }

  func onDelete(at index: Int) {
    items.remove(at: index)
  }

  func onUpdate(item: TodoItem, at index: Int) {
    items[index] = item
  }
}
