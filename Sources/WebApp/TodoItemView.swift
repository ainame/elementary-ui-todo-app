import ElementaryUI

@View
struct TodoItemView {
  let item: TodoItem
  let onClickDeleteButton: () -> Void
  let onClickDoneButton: (TodoItem) -> Void

  @State var isEditMode: Bool = false

  var body: some View {
    div(.class("bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-all duration-300 border-l-4 border-blue-500")) {
      if isEditMode {
        TodoItemEditView(
          item: item,
          onClickCancelButton: {
            isEditMode = false
          },
          onClickDoneButton: { updatedItem in
            isEditMode = false
            onClickDoneButton(updatedItem)
          }
        )
      } else {
        TodoItemViewerView(
          item: item,
          onClickEditButton: { isEditMode = true },
          onClickDeleteButton: onClickDeleteButton
        )
      }
    }
    .animateContainerLayout()
    .animation(.bouncy, value: isEditMode)
  }
}

@View
struct TodoItemViewerView {
  let item: TodoItem
  let onClickEditButton: () -> Void
  let onClickDeleteButton: () -> Void

  var body: some View {
    div {
      // Header with title and action buttons
      div(.class("flex items-center justify-between mb-3")) {
        div(.class("flex items-center gap-3")) {
          span(.class("text-2xl")) {
            "📌"
          }

          h3(.class("text-xl font-bold text-gray-900")) {
            item.title
          }
        }

        div(.class("flex gap-2")) {
          button(.class("text-red-600 hover:text-red-700 font-medium text-sm px-3 py-1 rounded hover:bg-red-50 transition-colors")) {
            "Delete"
          }
          .onClick {
            onClickDeleteButton()
          }

          button(.class("text-blue-600 hover:text-blue-700 font-medium text-sm px-3 py-1 rounded hover:bg-blue-50 transition-colors")) {
            "Edit"
          }
          .onClick {
            onClickEditButton()
          }
        }
      }

      p(.class("text-gray-600 text-base leading-relaxed mb-4 ml-11")) {
        item.description
      }

      div(.class("flex items-center gap-2 ml-11")) {
        span(.class("text-sm")) {
          "🗓️"
        }
        span(.class("text-sm font-medium text-blue-600")) {
          item.deadline
        }
      }
    }
  }
}

@View
struct TodoItemEditView {
  @State var title: String
  @State var description: String
  @State var deadline: String
  let source: TodoItem
  let onClickCancelButton: () -> Void
  let onClickDoneButton: (TodoItem) -> Void

  init(
    item: TodoItem,
    onClickCancelButton: @escaping () -> Void,
    onClickDoneButton: @escaping (TodoItem) -> Void
  ) {
    self.title = item.title
    self.description = item.description
    self.deadline = item.deadline
    self.source = item
    self.onClickCancelButton = onClickCancelButton
    self.onClickDoneButton = onClickDoneButton
  }

  var body: some View {
    div {
      editHeader
      editForm
    }
  }

  var editHeader: some View {
    div(.class("flex items-center justify-between mb-4")) {
      h3(.class("text-xl font-bold text-gray-900")) {
        "Edit Todo"
      }

      div(.class("flex gap-2")) {
        button(.class("text-gray-600 hover:text-gray-700 font-medium text-sm px-3 py-1 rounded hover:bg-gray-100 transition-colors")) {
          "Cancel"
        }
        .onClick { onClickCancelButton() }

        button(.class("bg-blue-600 hover:bg-blue-700 text-white font-medium text-sm px-3 py-1 rounded transition-colors")) {
          "Done"
        }
        .onClick { onClickDoneButton(getUpdatedItem()) }
      }
    }
  }

  var editForm: some View {
    div(.class("space-y-4")) {
      form {
        titleField
        descriptionField
        deadlineField
      }
    }
  }

  var titleField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Title"

      input(.type(.text), .value(title), .id("todo-id"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"))
        .bindValue($title)
    }
  }

  var descriptionField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Description"

      textarea(.id("todo-desc"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 min-h-24")) {
        description
      }
      .onInput { event in
        if let value = event.targetValue {
          description = value
        }
      }
    }
  }

  var deadlineField: some View {
    label(.class("block text-sm font-medium text-gray-700 mb-1")) {
      "Deadline"

      input(.type(.date), .value(deadline), .id("todo-deadline"), .class("w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"))
        .bindValue($deadline)
    }
  }

  func getUpdatedItem() -> TodoItem {
    TodoItem(
      id: source.id,
      title: title,
      description: description,
      deadline: deadline
    )
  }
}
